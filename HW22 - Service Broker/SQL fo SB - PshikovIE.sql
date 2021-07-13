--��

--�������� ������� ��� ������������ ������� ��� �������� �� ������� Invoices. ��� ������ ��������� ��� �������� ������ � ������� ������ ������������ ������.
--��� ��������� ������� ���������� ����� �� ���������� ������� (Orders) �� ������� �� �������� ������ ������� � ����������� ������� ����� � ����� �������.
--���������, ��� �� ��������� ���������� � ���������� ������� � � ��� ��� �� �������.

USE [WideWorldImporters];

------------------------------------------------------------------------------------------------------------------------
-- ��������� �� � ������������������� �����
ALTER DATABASE WideWorldImporters SET SINGLE_USER WITH ROLLBACK IMMEDIATE

-- ���������� �������� service broker
ALTER DATABASE WideWorldImporters SET ENABLE_BROKER;	

-- ��������� ���������� �����������
ALTER DATABASE WideWorldImporters SET TRUSTWORTHY ON; 
-- ��������� �������� �� ����� ������
select DATABASEPROPERTYEX ('WideWorldImporters','UserAccess');
SELECT is_broker_enabled FROM sys.databases WHERE name = 'WideWorldImporters';

-- ������� ����������� ��� sa, ��� ������� � ������ ��������
ALTER AUTHORIZATION  
   ON DATABASE::WideWorldImporters TO [sa]; 

-- ������ ����� �� 
ALTER DATABASE WideWorldImporters SET MULTI_USER WITH ROLLBACK IMMEDIATE
GO
------------------------------------------------------------------------------------------------------------------------

--���������� Service Brocker

--�������� ���������
CREATE MESSAGE TYPE
[//WWI/SB/RequestMessage]
VALIDATION=WELL_FORMED_XML;

CREATE MESSAGE TYPE
[//WWI/SB/ReplyMessage]
VALIDATION=WELL_FORMED_XML; 

GO

--�������� ��������
CREATE CONTRACT [//WWI/SB/Contract]
      ([//WWI/SB/RequestMessage]
         SENT BY INITIATOR,
       [//WWI/SB/ReplyMessage]
         SENT BY TARGET
      );
GO

--�������� �������
CREATE QUEUE TargetQueueWWI;
CREATE QUEUE InitiatorQueueWWI;
GO

--�������� ������ ������������� �������
CREATE SERVICE [//WWI/SB/TargetService]
       ON QUEUE TargetQueueWWI
       ([//WWI/SB/Contract]);
GO

CREATE SERVICE [//WWI/SB/InitiatorService]
       ON QUEUE InitiatorQueueWWI
       ([//WWI/SB/Contract]);
GO

------------------------------------------------------------------------------------------------------------------------

--�������� ����� ������� ���� ����� ������ ������ 
CREATE TABLE Sales.ReportForCustomers
			(CustomerID		int not null,
			 CustomerName	nvarchar(100) not null,
			 QuantityOrders int not null,
			 DateStart		datetime2 not null,
			 DateEnd		datetime2 not null)

GO

------------------------------------------------------------------------------------------------------------------------

--�������� ��������� �������� �������

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE or ALTER PROCEDURE Sales.uspReportForCustomers_SendMessage
	@CustomerId INT,
	@DateStart datetime2,
	@DateEnd datetime2
AS
BEGIN
	SET NOCOUNT ON;

	--Sending a Request Message to the Target	
	DECLARE @InitDlgHandle UNIQUEIDENTIFIER; --open init dialog
	DECLARE @RequestMessage NVARCHAR(4000); --���������, ������� ����� ����������
	
	BEGIN TRAN --�������� ����������

	--Prepare the Message  !!!auto generate XML
	SELECT @RequestMessage = (SELECT CustomerID, @DateStart as DateStart, @DateEnd as DateEnd
							  FROM Sales.Customers AS Customers
							  WHERE CustomerID = @CustomerID
							  FOR XML AUTO, root('RequestMessage')); 

	--Determine the Initiator Service, Target Service and the Contract 
	BEGIN DIALOG @InitDlgHandle
	FROM SERVICE
	[//WWI/SB/InitiatorService]
	TO SERVICE
	'//WWI/SB/TargetService'
	ON CONTRACT
	[//WWI/SB/Contract]
	WITH ENCRYPTION=OFF; 

	--Send the Message
	SEND ON CONVERSATION @InitDlgHandle 
	MESSAGE TYPE
	[//WWI/SB/RequestMessage]
	(@RequestMessage);
	--SELECT @RequestMessage AS SentRequestMessage;--we can write data to log
	COMMIT TRAN 

END;

GO;

------------------------------------------------------------------------------------------------------------------------

--�������� ��������� ������� �������
CREATE or ALTER PROCEDURE Sales.uspReportForCustomers_GetMessage
AS
BEGIN

	DECLARE @TargetDlgHandle UNIQUEIDENTIFIER, --������������� �������
			@Message NVARCHAR(4000),--���������� ���������
			@MessageType Sysname,--��� ����������� ���������
			@ReplyMessage NVARCHAR(4000),--�������� ���������
			@xml XML; 

	DECLARE	@CustomerID INT,
			@DateStart datetime2,
			@DateEnd datetime2;
	
	BEGIN TRAN; 

	--Receive message from Initiator
	RECEIVE TOP(1)
		@TargetDlgHandle = Conversation_Handle,
		@Message = Message_Body,
		@MessageType = Message_Type_Name
	FROM dbo.TargetQueueWWI; 

	SELECT @Message; --������� � ������� ���������� �������

	SET @xml = CAST(@Message AS XML); -- �������� xml �� ��������

	SELECT @xml; 

	--�������� CustomerID �� xml
	SELECT @CustomerID	= Inf.cust.value('@CustomerID'	,'Int'),
	       @DateStart	= Inf.cust.value('@DateStart'	,'DateTime2'),
		   @DateEnd		= Inf.cust.value('@DateEnd'		,'DateTime2')
	FROM @xml.nodes('/RequestMessage/Customers') as Inf(cust);

	With custCTE as (SELECT	Invoices.CustomerID,
							Customers.CustomerName,
							Count(Invoices.OrderID) as NumberOfOrders
					FROM Sales.Invoices
					JOIN Sales.Customers on Customers.CustomerID = Invoices.CustomerID
					WHERE	Invoices.CustomerId = @CustomerID 
						and Invoices.InvoiceDate between @DateStart and @DateEnd
					GROUP BY Invoices.CustomerID, Customers.CustomerName)

	--������� ������ � ���� �������
	INSERT INTO Sales.ReportForCustomers
	(CustomerID,CustomerName,QuantityOrders,DateStart, DateEnd)
	SELECT CustomerID,CustomerName,NumberOfOrders,@DateStart,@DateEnd
	FROM custCTE;
	
	SELECT @Message AS ReceivedRequestMessage, @MessageType, @CustomerID, @DateStart, @DateEnd; --� ���
	
	-- Confirm and Send a reply
	IF @MessageType=N'//WWI/SB/RequestMessage'
	BEGIN
		SET @ReplyMessage =N'<ReplyMessage> Message received </ReplyMessage>'; 
	
		SEND ON CONVERSATION @TargetDlgHandle
		MESSAGE TYPE
		[//WWI/SB/ReplyMessage]
		(@ReplyMessage);
		END CONVERSATION @TargetDlgHandle;--������� ������ �� ������� �������
	END 
	
	SELECT @ReplyMessage AS SentReplyMessage; --� ���

	COMMIT TRAN;
END;



------------------------------------------------------------------------------------------------------------------------

--�������� ��������� ������������� �������
CREATE PROCEDURE Sales.uspReportForCustomers_ConfirmMessage
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
		FROM dbo.InitiatorQueueWWI; 
		
		END CONVERSATION @InitiatorReplyDlgHandle; --������� ������ �� ������� ����������
		--��� ��������� ������� ������ ��������� ���
		--https://docs.microsoft.com/ru-ru/sql/t-sql/statements/end-conversation-transact-sql?view=sql-server-ver15
		
		SELECT @ReplyReceivedMessage AS ReceivedRepliedMessage; --� �������

	COMMIT TRAN; 
END

------------------------------------------------------------------------------------------------------------------------

--��������!!!

SELECT DISTINCT top 1000  CustomerID, InvoiceDate
FROM Sales.Invoices

SELECT * FROM Sales.ReportForCustomers

--���������� ���������
EXEC Sales.uspReportForCustomers_SendMessage 
	@CustomerID = 77, @DateStart = '2013-01-01', @DateEnd = '2021-12-01';

--�������� �������
SELECT CAST(message_body AS XML),*
FROM dbo.TargetQueueWWI;

SELECT CAST(message_body AS XML),*
FROM dbo.InitiatorQueueWWI;

--�������� �������, ��� ��� ��������
--Target
EXEC Sales.uspReportForCustomers_GetMessage;

--Initiator
EXEC Sales.uspReportForCustomers_ConfirmMessage;

--������� Sales.ReportForCustomers �����������:
SELECT * FROM Sales.ReportForCustomers

--������ �� �������� �������� ��������
SELECT conversation_handle, is_initiator, s.name as 'local service', 
far_service, sc.name 'contract', ce.state_desc
FROM sys.conversation_endpoints ce
LEFT JOIN sys.services s
ON ce.service_id = s.service_id
LEFT JOIN sys.service_contracts sc
ON ce.service_contract_id = sc.service_contract_id
ORDER BY conversation_handle;


------------------------------------------------------------------------------------------------------------------------
--�������������� =)

ALTER QUEUE [dbo].[InitiatorQueueWWI] WITH STATUS = ON , RETENTION = OFF , POISON_MESSAGE_HANDLING (STATUS = OFF) 
	, ACTIVATION (   STATUS = ON ,
        PROCEDURE_NAME = Sales.uspReportForCustomers_ConfirmMessage, MAX_QUEUE_READERS = 1, EXECUTE AS OWNER) ; 

GO
ALTER QUEUE [dbo].[TargetQueueWWI] WITH STATUS = ON , RETENTION = OFF , POISON_MESSAGE_HANDLING (STATUS = OFF)
	, ACTIVATION (  STATUS = ON ,
        PROCEDURE_NAME = Sales.uspReportForCustomers_GetMessage, MAX_QUEUE_READERS = 1, EXECUTE AS OWNER) ; 

GO

--���������� ���������
EXEC Sales.uspReportForCustomers_SendMessage 
	@CustomerID = 832, @DateStart = '2013-01-01', @DateEnd = '2021-12-01';

SELECT * FROM Sales.ReportForCustomers
