USE [Project_Sbyt]
GO

------------------------------------------------------------------------------------------------------------------------
-- переводим БД в однопользователский режим
ALTER DATABASE Project_Sbyt SET SINGLE_USER WITH ROLLBACK IMMEDIATE

-- необходимо включить service broker
ALTER DATABASE Project_Sbyt SET ENABLE_BROKER;	

-- Разрешаем доверенные подключения
ALTER DATABASE Project_Sbyt SET TRUSTWORTHY ON; 
-- посмотрим свойства БД через студию
select DATABASEPROPERTYEX ('Project_Sbyt','UserAccess');
SELECT is_broker_enabled FROM sys.databases WHERE name = 'Project_Sbyt';

-- Добавим авторизацию для sa, для доступа с других серверов
ALTER AUTHORIZATION  
   ON DATABASE::Project_Sbyt TO [sa]; 

-- вернем режим БД 
ALTER DATABASE Project_Sbyt SET MULTI_USER WITH ROLLBACK IMMEDIATE
GO
------------------------------------------------------------------------------------------------------------------------

--Подготовим Service Brocker

--Создадим сообщения
CREATE MESSAGE TYPE
[//Sbyt/SB/RequestMessage]
VALIDATION=WELL_FORMED_XML;

CREATE MESSAGE TYPE
[//Sbyt/SB/ReplyMessage]
VALIDATION=WELL_FORMED_XML; 

GO

--Создадим контракт
CREATE CONTRACT [//Sbyt/SB/Contract]
      ([//Sbyt/SB/RequestMessage]
         SENT BY INITIATOR,
       [//Sbyt/SB/ReplyMessage]
         SENT BY TARGET
      );
GO

--Создадим очереди
CREATE QUEUE sbyt.TargetQueueSbyt;
CREATE QUEUE sbyt.InitiatorQueueSbyt;
GO

--Создадим сервис обслуживающий очередь
CREATE SERVICE [//Sbyt/SB/TargetService]
       ON QUEUE sbyt.TargetQueueSbyt
       ([//Sbyt/SB/Contract]);
GO

CREATE SERVICE [//Sbyt/SB/InitiatorService]
       ON QUEUE sbyt.InitiatorQueueSbyt
       ([//Sbyt/SB/Contract]);
GO

------------------------------------------------------------------------------------------------------------------------

--Создадим процедуру отправки запроса

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
	DECLARE @RequestMessage NVARCHAR(4000); --сообщение, которое будем отправлять
	
	BEGIN TRAN --начинаем транзакцию

	IF ( @curr_date is null )
	SET @curr_date = current_timestamp;

   IF ( @user is null )
	SET @user = SYSTEM_USER;

   IF ( @hostname is null )
	SET @hostname = host_name(); 

   IF ( @TableName is null )
	SET @TableName = ''; 

   DECLARE @userID int;
   Select @userID = Row_id from sbyt.Пользователи u Where u.Логин = @user;
   IF ( @userID is null )
	Select @userID = Row_id from sbyt.Пользователи u Where u.Логин = 'System';

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

--Создадим процедуру приемки запроса
CREATE or ALTER PROCEDURE sbyt.proc_write_journal_SB_GetMessage
AS
BEGIN

	DECLARE @TargetDlgHandle UNIQUEIDENTIFIER, --идентификатор диалога
			@Message NVARCHAR(4000),--полученное сообщение
			@MessageType Sysname,--тип полученного сообщения
			@ReplyMessage NVARCHAR(4000),--ответное сообщение
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

	--SELECT @Message; --выводим в консоль полученный месседж

	SET @xml = CAST(@Message AS XML); -- получаем xml из мессаджа

	--SELECT @xml; 

	--получаем данные из xml
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
    Select @userID = Row_id from sbyt.Пользователи u Where u.Логин = @user;
    IF ( @userID is null )
	 Select @userID = Row_id from sbyt.Пользователи u Where u.Логин = 'System';
	
	--Вставим запись в нашу таблицу
	IF (@descr is not null) -- Есть что записать
	begin
		INSERT INTO [Sbyt].[Журнал_изменений]
		  (Дата,  Журнал_Пользователь,  Действие, Журнал_Счет, Журнал_Договор, Таблица, ИмяКомпьютера, Операция)
		VALUES
		  ( @curr_date, @userID, ISNULL( @descr, '' ),  @account, @contract, @TableName, @hostname, @operation);
	end;

	--SELECT @Message AS ReceivedRequestMessage, @MessageType, @user, @curr_date, @descr, @account, @contract, @TableName, @hostname, @operation; --в лог
	
	-- Confirm and Send a reply
	IF @MessageType=N'//Sbyt/SB/RequestMessage'
	BEGIN
		SET @ReplyMessage =N'<ReplyMessage> Message received </ReplyMessage>'; 

		SEND ON CONVERSATION @TargetDlgHandle
		MESSAGE TYPE
		[//Sbyt/SB/ReplyMessage]
		(@ReplyMessage);
		END CONVERSATION @TargetDlgHandle;--закроем диалог со стороны таргета
	END 
	
	--SELECT @ReplyMessage AS SentReplyMessage; --в лог
	COMMIT TRAN;
END;

GO

------------------------------------------------------------------------------------------------------------------------

--Создадим процедуру подтверждения запроса
CREATE PROCEDURE sbyt.proc_write_journal_SB_ConfirmMessage
AS
BEGIN
	--Receiving Reply Message from the Target.	
	DECLARE @InitiatorReplyDlgHandle UNIQUEIDENTIFIER, --хэндл диалога
			@ReplyReceivedMessage NVARCHAR(1000) 
	
	BEGIN TRAN; 

	    --получим сообщение из очереди инициатора
		RECEIVE TOP(1)
			@InitiatorReplyDlgHandle=Conversation_Handle
			,@ReplyReceivedMessage=Message_Body
		FROM sbyt.InitiatorQueueSbyt; 
		
		END CONVERSATION @InitiatorReplyDlgHandle; --закроем диалог со стороны инициатора
		--оба участника диалога должны завершить его
		--https://docs.microsoft.com/ru-ru/sql/t-sql/statements/end-conversation-transact-sql?view=sql-server-ver15
		
		SELECT @ReplyReceivedMessage AS ReceivedRepliedMessage; --в консоль

	COMMIT TRAN; 
END

------------------------------------------------------------------------------------------------------------------------
--Автоматизируем 

ALTER QUEUE sbyt.[InitiatorQueueSbyt] WITH STATUS = ON , RETENTION = OFF , POISON_MESSAGE_HANDLING (STATUS = OFF) 
	, ACTIVATION (   STATUS = ON ,
        PROCEDURE_NAME = sbyt.proc_write_journal_SB_ConfirmMessage, MAX_QUEUE_READERS = 1, EXECUTE AS OWNER) ; 

GO
ALTER QUEUE sbyt.[TargetQueueSbyt] WITH STATUS = ON , RETENTION = OFF , POISON_MESSAGE_HANDLING (STATUS = OFF)
	, ACTIVATION (  STATUS = ON ,
        PROCEDURE_NAME = sbyt.proc_write_journal_SB_GetMessage, MAX_QUEUE_READERS = 1, EXECUTE AS OWNER) ; 

GO
