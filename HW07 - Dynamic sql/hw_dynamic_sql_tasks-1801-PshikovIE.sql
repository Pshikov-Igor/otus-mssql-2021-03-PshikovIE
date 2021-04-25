/*
Домашнее задание по курсу MS SQL Server Developer в OTUS.

Занятие "07 - Динамический SQL".

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

Это задание из занятия "Операторы CROSS APPLY, PIVOT, UNPIVOT."
Нужно для него написать динамический PIVOT, отображающий результаты по всем клиентам.
Имя клиента указывать полностью из поля CustomerName.

Требуется написать запрос, который в результате своего выполнения 
формирует сводку по количеству покупок в разрезе клиентов и месяцев.
В строках должны быть месяцы (дата начала месяца), в столбцах - клиенты.

Дата должна иметь формат dd.mm.yyyy, например, 25.12.2019.

Пример, как должны выглядеть результаты:
-------------+--------------------+--------------------+----------------+----------------------
InvoiceMonth | Aakriti Byrraju    | Abel Spirlea       | Abel Tatarescu | ... (другие клиенты)
-------------+--------------------+--------------------+----------------+----------------------
01.01.2013   |      3             |        1           |      4         | ...
01.02.2013   |      7             |        3           |      4         | ...
-------------+--------------------+--------------------+----------------+----------------------
*/

Declare @query			nvarchar(max);
Declare @spisCust		nvarchar(max);
Declare @spisCustColumn	nvarchar(max);

SELECT @spisCust = ISNULL(@spisCust + ',','') + QUOTENAME(CustName.CustomerName),
	   @spisCustColumn = ISNULL(@spisCustColumn,'')  +' '+ 'isnull(' + QUOTENAME(CustName.CustomerName) + ',0) as ' + QUOTENAME(CustName.CustomerName) 
FROM (
		Select distinct	top 500 cust.CustomerName as CustomerName
		from Sales.Customers cust	
	  ) AS CustName
order by CustName.CustomerName

SELECT @spisCustColumn = REPLACE( @spisCustColumn ,  '] isnull('  , '], isnull(' ) 

-- Для проверки
--SELECT @spisCust 
--SELECT @spisCustColumn

--Соберем наш запрос
SET @query = N'
				; With CustInvCTE as (
										Select	cust.CustomerName as CustomerName,
												count(inv.InvoiceID)																as CountInv, 
												format(DATEFROMPARTS(Year(inv.InvoiceDate),month(inv.InvoiceDate),1), ''dd.MM.yyyy'') as InvoiceMonth
											from Sales.Customers cust
											join Sales.Invoices inv on inv.CustomerID = cust.CustomerID
										group by cust.CustomerName, DATEFROMPARTS(Year(inv.InvoiceDate),month(inv.InvoiceDate),1)
									 )
				Select PVT.InvoiceMonth, ' + @spisCustColumn + ' from CustInvCTE
				pivot (sum(CustInvCTE.CountInv) 
				for CustInvCTE.CustomerName IN ( '+ @spisCust +' )) as PVT
				order by year(pvt.InvoiceMonth),month(pvt.InvoiceMonth)'

EXEC sp_executesql @query

