/*
Домашнее задание по курсу MS SQL Server Developer в OTUS.

Занятие "10 - Операторы изменения данных".

Задания выполняются с использованием базы данных WideWorldImporters.

Бэкап БД можно скачать отсюда:
https://github.com/Microsoft/sql-server-samples/releases/tag/wide-world-importers-v1.0
Нужен WideWorldImporters-Full.bak

Описание WideWorldImporters от Microsoft:
* https://docs.microsoft.com/ru-ru/sql/samples/wide-world-importers-what-is
* https://docs.microsoft.com/ru-ru/sql/samples/wide-world-importers-oltp-database-catalog
*/

-- ---------------------------------------------------------------------------
-- Задание - написать выборки для получения указанных ниже данных.
-- ---------------------------------------------------------------------------

USE WideWorldImporters

/*
1. Довставлять в базу пять записей используя insert в таблицу Customers или Suppliers 
*/

--Вариант 1
Insert into Sales.Customers
		([CustomerID],[CustomerName],[BillToCustomerID],[CustomerCategoryID],[BuyingGroupID],[PrimaryContactPersonID],[AlternateContactPersonID],[DeliveryMethodID],[DeliveryCityID],[PostalCityID],[CreditLimit]
		,[AccountOpenedDate],[StandardDiscountPercentage],[IsStatementSent],[IsOnCreditHold],[PaymentDays],[PhoneNumber],[FaxNumber],[DeliveryRun],[RunPosition],[WebsiteURL],[DeliveryAddressLine1]
		,[DeliveryAddressLine2],[DeliveryPostalCode],[PostalAddressLine1],[PostalAddressLine2],[PostalPostalCode],[LastEditedBy])
	OUTPUT inserted.*
	VALUES
		(NEXT VALUE FOR [Sequences].[CustomerID],'IP Ivanov I.I.',1,3,1,1001,1002,3,19586,19586,100000
		,'20210501',0,0,0,7,'(8342)19-99-99','(8342)19-99-98','','','www.yandex1.ru','Adress 1'
		,'Adress 2',99999,'Adress 3','Adress 4',99999,1), 
		(NEXT VALUE FOR [Sequences].[CustomerID],'IP Petrov I.P.',1,3,1,1001,1002,3,19586,19586,100000
		,'20210501',0,0,0,7,'(8342)29-99-99','(8342)29-99-98','','','www.yandex2.ru','Adress 1'
		,'Adress 2',99999,'Adress 3','Adress 4',99999,1),
		(NEXT VALUE FOR [Sequences].[CustomerID],'IP Sidorov S.G.',1,3,1,1001,1002,3,19586,19586,100000
		,'20210501',0,0,0,7,'(8342)39-99-99','(8342)39-99-98','','','www.yandex3.ru','Adress 1'
		,'Adress 2',99999,'Adress 3','Adress 4',99999,1),
		(NEXT VALUE FOR [Sequences].[CustomerID],'IP Putin I.I.',1,3,1,1001,1002,3,19586,19586,100000
		,'20210501',0,0,0,7,'(8342)49-99-99','(8342)49-99-98','','','www.yandex4.ru','Adress 1'
		,'Adress 2',99999,'Adress 3','Adress 4',99999,1),
		(NEXT VALUE FOR [Sequences].[CustomerID],'IP Medvedev I.I.',1,3,1,1001,1002,3,19586,19586,100000
		,'20210501',0,0,0,7,'(8342)59-99-99','(8342)59-99-98','','','www.yandex5.ru','Adress 1'
		,'Adress 2',99999,'Adress 3','Adress 4',99999,1);

--Вариант 2
Insert into Sales.Customers
		([CustomerName],[BillToCustomerID],[CustomerCategoryID],[BuyingGroupID],[PrimaryContactPersonID],[AlternateContactPersonID],[DeliveryMethodID],[DeliveryCityID],[PostalCityID],[CreditLimit]
		,[AccountOpenedDate],[StandardDiscountPercentage],[IsStatementSent],[IsOnCreditHold],[PaymentDays],[PhoneNumber],[FaxNumber],[DeliveryRun],[RunPosition],[WebsiteURL],[DeliveryAddressLine1]
		,[DeliveryAddressLine2],[DeliveryPostalCode],[PostalAddressLine1],[PostalAddressLine2],[PostalPostalCode],[LastEditedBy])
Select top (5) 'NewCustomers ' + [CustomerName],[BillToCustomerID],[CustomerCategoryID],[BuyingGroupID],[PrimaryContactPersonID],[AlternateContactPersonID],[DeliveryMethodID],[DeliveryCityID],[PostalCityID],[CreditLimit]
		,[AccountOpenedDate],[StandardDiscountPercentage],[IsStatementSent],[IsOnCreditHold],[PaymentDays],[PhoneNumber],[FaxNumber],[DeliveryRun],[RunPosition],[WebsiteURL],[DeliveryAddressLine1]
		,[DeliveryAddressLine2],[DeliveryPostalCode],[PostalAddressLine1],[PostalAddressLine2],[PostalPostalCode],[LastEditedBy]
from Sales.Customers
order by [CustomerID]

--Для проверки
--Select * from Sales.Customers Where Cast(ValidFrom as date) = Cast(GETDATE() as date)

/*
2. Удалите одну запись из Customers, которая была вами добавлена
*/

Delete top (1) 
from Sales.Customers 
Where Cast(ValidFrom as date) = Cast(GETDATE() as date)

--Для проверки
--Select * from Sales.Customers Where Cast(ValidFrom as date) = Cast(GETDATE() as date)

/*
3. Изменить одну запись, из добавленных через UPDATE
*/

update cust
set cust.PhoneNumber = '(9999)59-99-99',
    cust.FaxNumber	 = '(9999)59-99-98'
OUTPUT inserted.*,deleted.*
from Sales.Customers cust
Where cust.CustomerID = (
							Select min(c.CustomerID) from Sales.Customers c
							Where Cast(c.ValidFrom as date) = Cast(GETDATE() as date)
						)

--Для проверки
--Select * from Sales.Customers Where Cast(ValidFrom as date) = Cast(GETDATE() as date)

/*
4. Написать MERGE, который вставит вставит запись в клиенты, если ее там нет, и изменит если она уже есть
*/

MERGE Sales.Customers AS target 
	USING ( 
			Select 'IP Ivanov P.P.'			as [CustomerName],
								1			as [BillToCustomerID],
								3			as [CustomerCategoryID],
								1			as [BuyingGroupID],
								1001		as [PrimaryContactPersonID],
								1002		as [AlternateContactPersonID],
								3			as [DeliveryMethodID],
								19586		as [DeliveryCityID],
								19586		as [PostalCityID],
								100000		as [CreditLimit],
								GETDATE()	as [AccountOpenedDate],
								0			as [StandardDiscountPercentage],
								0			as [IsStatementSent],
								0			as [IsOnCreditHold],
								7			as [PaymentDays],
								'(8342)19-99-99' as [PhoneNumber],
								'(8342)19-99-98' as [FaxNumber],
								''			as [DeliveryRun],
								''			as [RunPosition],
								'www.yandex1.ru' as [WebsiteURL],
								'Adress 1'	as [DeliveryAddressLine1],
								'Adress 2'	as [DeliveryAddressLine2],
								99999		as [DeliveryPostalCode],
								'Adress 3'	as [PostalAddressLine1],
								'Adress 4'	as [PostalAddressLine2],
								99999		as [PostalPostalCode],
								1			as [LastEditedBy]
		  ) 
		AS source (
					[CustomerName],[BillToCustomerID],[CustomerCategoryID],[BuyingGroupID],[PrimaryContactPersonID],[AlternateContactPersonID],[DeliveryMethodID],[DeliveryCityID]
					,[PostalCityID],[CreditLimit],[AccountOpenedDate],[StandardDiscountPercentage],[IsStatementSent],[IsOnCreditHold],[PaymentDays],[PhoneNumber],[FaxNumber],[DeliveryRun]
					,[RunPosition],[WebsiteURL],[DeliveryAddressLine1],[DeliveryAddressLine2],[DeliveryPostalCode],[PostalAddressLine1],[PostalAddressLine2],[PostalPostalCode],[LastEditedBy]
				  ) 
		ON
	 (target.CustomerName = source.CustomerName) 
	WHEN MATCHED 
		THEN UPDATE SET [CustomerName] = source.[CustomerName],
						[BillToCustomerID] = source.[BillToCustomerID],
						[CustomerCategoryID] = source.[CustomerCategoryID],
						[BuyingGroupID] = source.[BuyingGroupID],
						[PrimaryContactPersonID] = source.[PrimaryContactPersonID],
						[AlternateContactPersonID] = source.[AlternateContactPersonID],
						[DeliveryMethodID] = source.[DeliveryMethodID],
						[DeliveryCityID] = source.[DeliveryCityID],
						[PostalCityID] = source.[PostalCityID],
						[CreditLimit] = source.[CreditLimit],
						[AccountOpenedDate] = source.[AccountOpenedDate],
						[StandardDiscountPercentage] = source.[StandardDiscountPercentage],
						[IsStatementSent] = source.[IsStatementSent],
						[IsOnCreditHold] = source.[IsOnCreditHold],
						[PaymentDays] = source.[PaymentDays],
						[PhoneNumber] = source.[PhoneNumber],
						[FaxNumber] = source.[FaxNumber],
						[DeliveryRun] = source.[DeliveryRun],
						[RunPosition] = source.[RunPosition],
						[WebsiteURL] = source.[WebsiteURL],
						[DeliveryAddressLine1] = source.[DeliveryAddressLine1],
						[DeliveryAddressLine2] = source.[DeliveryAddressLine2],
						[DeliveryPostalCode] = source.[DeliveryPostalCode],
						[PostalAddressLine1] = source.[PostalAddressLine1],
						[PostalAddressLine2] = source.[PostalAddressLine2],
						[PostalPostalCode] = source.[PostalPostalCode],
						[LastEditedBy] = source.[LastEditedBy]
	WHEN NOT MATCHED 
		THEN INSERT ([CustomerName],[BillToCustomerID],[CustomerCategoryID],[BuyingGroupID],[PrimaryContactPersonID],[AlternateContactPersonID],[DeliveryMethodID],[DeliveryCityID]
					,[PostalCityID],[CreditLimit],[AccountOpenedDate],[StandardDiscountPercentage],[IsStatementSent],[IsOnCreditHold],[PaymentDays],[PhoneNumber],[FaxNumber],[DeliveryRun]
					,[RunPosition],[WebsiteURL],[DeliveryAddressLine1],[DeliveryAddressLine2],[DeliveryPostalCode],[PostalAddressLine1],[PostalAddressLine2],[PostalPostalCode],[LastEditedBy]) 
			VALUES (source.[CustomerName],source.[BillToCustomerID],source.[CustomerCategoryID],source.[BuyingGroupID],source.[PrimaryContactPersonID],source.[AlternateContactPersonID],
					source.[DeliveryMethodID],source.[DeliveryCityID],source.[PostalCityID],source.[CreditLimit],source.[AccountOpenedDate],source.[StandardDiscountPercentage],
					source.[IsStatementSent],source.[IsOnCreditHold],source.[PaymentDays],source.[PhoneNumber],source.[FaxNumber],source.[DeliveryRun],source.[RunPosition],
					source.[WebsiteURL],source.[DeliveryAddressLine1],source.[DeliveryAddressLine2],source.[DeliveryPostalCode],source.[PostalAddressLine1],source.[PostalAddressLine2],
					source.[PostalPostalCode],source.[LastEditedBy]) 
	OUTPUT deleted.*, $action, inserted.*;

/*
5. Напишите запрос, который выгрузит данные через bcp out и загрузить через bulk insert
*/

-- Предворительные настройки
EXEC sp_configure 'show advanced options', 1;  
GO  
RECONFIGURE;  
GO  
EXEC sp_configure 'xp_cmdshell', 1;  
GO  
RECONFIGURE;  
GO  

Declare @server as nvarchar(max) =  @@SERVERNAME
SELECT  @server 

--выгрузка
exec master..xp_cmdshell 'bcp "[WideWorldImporters].Sales.Customers" out  "D:\WWI_Customers.csv" -T -w -t "~" -S WS91\SQL_SERVER_IGOR' 

--Загрузка
--Добавим новую таблицу, чтобы не портить имеющуюся
select * into Sales.Customers_Copy
from Sales.Customers
 where 1 = 2;

BULK INSERT [WideWorldImporters].Sales.Customers_Copy
FROM "D:\WWI_Customers.csv"
WITH 
	(
	BATCHSIZE = 1000, 
	DATAFILETYPE = 'widechar',
	FIELDTERMINATOR = '~',
	ROWTERMINATOR ='\n',
	KEEPNULLS,
	TABLOCK        
	);

--Для проверки
Select * from Sales.Customers_Copy

--Удалим за ненадобностью
--drop table if exists Sales.Customers_Copy