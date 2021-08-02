USE [Project_Sbyt]
GO

------------------------------------------------------------------------------------------------------------------------
-- ��������� �� � ������������������� �����
ALTER DATABASE Project_Sbyt SET SINGLE_USER WITH ROLLBACK IMMEDIATE

-- ���������� �������� service broker
ALTER DATABASE Project_Sbyt SET ENABLE_BROKER;	

-- ��������� ���������� �����������
ALTER DATABASE Project_Sbyt SET TRUSTWORTHY ON; 
-- ��������� �������� �� ����� ������
select DATABASEPROPERTYEX ('Project_Sbyt','UserAccess');
SELECT is_broker_enabled FROM sys.databases WHERE name = 'Project_Sbyt';

-- ������� ����������� ��� sa, ��� ������� � ������ ��������
ALTER AUTHORIZATION  
   ON DATABASE::Project_Sbyt TO [sa]; 

-- ������ ����� �� 
ALTER DATABASE Project_Sbyt SET MULTI_USER WITH ROLLBACK IMMEDIATE
GO
------------------------------------------------------------------------------------------------------------------------

--���������� Service Brocker

--�������� ���������
CREATE MESSAGE TYPE
[//Sbyt/SB/RequestMessage]
VALIDATION=WELL_FORMED_XML;

CREATE MESSAGE TYPE
[//Sbyt/SB/ReplyMessage]
VALIDATION=WELL_FORMED_XML; 

GO

--�������� ��������
CREATE CONTRACT [//Sbyt/SB/Contract]
      ([//Sbyt/SB/RequestMessage]
         SENT BY INITIATOR,
       [//Sbyt/SB/ReplyMessage]
         SENT BY TARGET
      );
GO

--�������� �������
CREATE QUEUE sbyt.TargetQueueSbyt;
CREATE QUEUE sbyt.InitiatorQueueSbyt;
GO

--�������� ������ ������������� �������
CREATE SERVICE [//Sbyt/SB/TargetService]
       ON QUEUE sbyt.TargetQueueSbyt
       ([//Sbyt/SB/Contract]);
GO

CREATE SERVICE [//Sbyt/SB/InitiatorService]
       ON QUEUE sbyt.InitiatorQueueSbyt
       ([//Sbyt/SB/Contract]);
GO

------------------------------------------------------------------------------------------------------------------------

--�������� ��������� �������� �������

CREATE or ALTER PROCEDURE sbyt.proc_write_journal_SB_SendMessage
   @user nvarchar(256),
   @curr_date datetime2,
   @descr nvarchar(1000),
   @account int,
   @contract int,
   @TableName nvarchar(256),
   @hostname nvarchar(256),
   @operation nvarchar(256)
AS
BEGIN
	SET NOCOUNT ON;

	--Sending a Request Message to the Target	
	DECLARE @InitDlgHandle UNIQUEIDENTIFIER; --open init dialog
	DECLARE @RequestMessage NVARCHAR(4000); --���������, ������� ����� ����������
	
	BEGIN TRAN --�������� ����������

	IF ( @curr_date is null )
	SET @curr_date = current_timestamp;

   IF ( @user is null )
	SET @user = SYSTEM_USER;

   IF ( @hostname is null )
	SET @hostname = host_name(); 

   IF ( @TableName is null )
	SET @TableName = ''; 

   DECLARE @userID int;
   Select @userID = Row_id from sbyt.������������ u Where u.����� = @user;
   IF ( @userID is null )
	Select @userID = Row_id from sbyt.������������ u Where u.����� = 'System';

	--Prepare the Message  !!!auto generate XML
	SELECT @RequestMessage = (SELECT @user		as UserName, 
									 @curr_date as curr_date, 
									 @descr		as descr, 
									 @account	as account, 
									 @contract	as NumContract,
									 @TableName as TableName,
									 @hostname	as hostname,
									 @operation as Operation
							  FOR XML RAW, root('RequestMessage')); 

	--Determine the Initiator Service, Target Service and the Contract 
	BEGIN DIALOG @InitDlgHandle
	FROM SERVICE
	[//Sbyt/SB/InitiatorService]
	TO SERVICE
	'//Sbyt/SB/TargetService'
	ON CONTRACT
	[//Sbyt/SB/Contract]
	WITH ENCRYPTION=OFF; 

	--Send the Message
	SEND ON CONVERSATION @InitDlgHandle 
	MESSAGE TYPE
	[//Sbyt/SB/RequestMessage]
	(@RequestMessage);
	COMMIT TRAN 
END;

GO

------------------------------------------------------------------------------------------------------------------------

--�������� ��������� ������� �������
CREATE or ALTER PROCEDURE sbyt.proc_write_journal_SB_GetMessage
AS
BEGIN

	DECLARE @TargetDlgHandle UNIQUEIDENTIFIER, --������������� �������
			@Message NVARCHAR(4000),--���������� ���������
			@MessageType Sysname,--��� ����������� ���������
			@ReplyMessage NVARCHAR(4000),--�������� ���������
			@xml XML; 

	DECLARE	@user nvarchar(256),
			@curr_date datetime2,
			@descr nvarchar(1000),
			@account int,
			@contract int,
			@TableName nvarchar(256),
			@hostname nvarchar(256),
			@operation nvarchar(256)
	
	BEGIN TRAN; 

	--Receive message from Initiator
	RECEIVE TOP(1)
		@TargetDlgHandle = Conversation_Handle,
		@Message = Message_Body,
		@MessageType = Message_Type_Name
	FROM sbyt.TargetQueueSbyt; 

	--SELECT @Message; --������� � ������� ���������� �������

	SET @xml = CAST(@Message AS XML); -- �������� xml �� ��������

	--SELECT @xml; 

	--�������� ������ �� xml
	SELECT @user		= Inf.Oper.value('@UserName'	,'nvarchar(256)'),
	       @curr_date	= Inf.Oper.value('@curr_date'	,'datetime2'),
		   @descr		= Inf.Oper.value('@descr'		,'nvarchar(1000)'),
		   @account		= Inf.Oper.value('@account'		,'int'),
		   @contract	= Inf.Oper.value('@NumContract'	,'int'),
		   @TableName	= Inf.Oper.value('@TableName'	,'nvarchar(256)'),
		   @hostname	= Inf.Oper.value('@hostname'	,'nvarchar(256)'),
		   @operation	= Inf.Oper.value('@Operation'	,'nvarchar(256)')
	FROM @xml.nodes('/RequestMessage/row') as Inf(Oper);

    DECLARE @userID int;
    Select @userID = Row_id from sbyt.������������ u Where u.����� = @user;
    IF ( @userID is null )
	 Select @userID = Row_id from sbyt.������������ u Where u.����� = 'System';
	
	--������� ������ � ���� �������
	IF (@descr is not null) -- ���� ��� ��������
	begin
		INSERT INTO [Sbyt].[������_���������]
		  (����,  ������_������������,  ��������, ������_����, ������_�������, �������, �������������, ��������)
		VALUES
		  ( @curr_date, @userID, ISNULL( @descr, '' ),  @account, @contract, @TableName, @hostname, @operation);
	end;

	--SELECT @Message AS ReceivedRequestMessage, @MessageType, @user, @curr_date, @descr, @account, @contract, @TableName, @hostname, @operation; --� ���
	
	-- Confirm and Send a reply
	IF @MessageType=N'//Sbyt/SB/RequestMessage'
	BEGIN
		SET @ReplyMessage =N'<ReplyMessage> Message received </ReplyMessage>'; 

		SEND ON CONVERSATION @TargetDlgHandle
		MESSAGE TYPE
		[//Sbyt/SB/ReplyMessage]
		(@ReplyMessage);
		END CONVERSATION @TargetDlgHandle;--������� ������ �� ������� �������
	END 
	
	--SELECT @ReplyMessage AS SentReplyMessage; --� ���
	COMMIT TRAN;
END;

GO

------------------------------------------------------------------------------------------------------------------------

--�������� ��������� ������������� �������
CREATE PROCEDURE sbyt.proc_write_journal_SB_ConfirmMessage
AS
BEGIN
	--Receiving Reply Message from the Target.	
	DECLARE @InitiatorReplyDlgHandle UNIQUEIDENTIFIER, --����� �������
			@ReplyReceivedMessage NVARCHAR(1000) 
	
	BEGIN TRAN; 

	    --������� ��������� �� ������� ����������
		RECEIVE TOP(1)
			@InitiatorReplyDlgHandle=Conversation_Handle
			,@ReplyReceivedMessage=Message_Body
		FROM sbyt.InitiatorQueueSbyt; 
		
		END CONVERSATION @InitiatorReplyDlgHandle; --������� ������ �� ������� ����������
		--��� ��������� ������� ������ ��������� ���
		--https://docs.microsoft.com/ru-ru/sql/t-sql/statements/end-conversation-transact-sql?view=sql-server-ver15
		
		SELECT @ReplyReceivedMessage AS ReceivedRepliedMessage; --� �������

	COMMIT TRAN; 
END

------------------------------------------------------------------------------------------------------------------------
--�������������� 

ALTER QUEUE sbyt.[InitiatorQueueSbyt] WITH STATUS = ON , RETENTION = OFF , POISON_MESSAGE_HANDLING (STATUS = OFF) 
	, ACTIVATION (   STATUS = ON ,
        PROCEDURE_NAME = sbyt.proc_write_journal_SB_ConfirmMessage, MAX_QUEUE_READERS = 1, EXECUTE AS OWNER) ; 

GO
ALTER QUEUE sbyt.[TargetQueueSbyt] WITH STATUS = ON , RETENTION = OFF , POISON_MESSAGE_HANDLING (STATUS = OFF)
	, ACTIVATION (  STATUS = ON ,
        PROCEDURE_NAME = sbyt.proc_write_journal_SB_GetMessage, MAX_QUEUE_READERS = 1, EXECUTE AS OWNER) ; 

GO
