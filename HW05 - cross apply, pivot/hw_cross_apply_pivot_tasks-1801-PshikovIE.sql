/*
Домашнее задание по курсу MS SQL Server Developer в OTUS.

Занятие "05 - Операторы CROSS APPLY, PIVOT, UNPIVOT".

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
1. Требуется написать запрос, который в результате своего выполнения 
формирует сводку по количеству покупок в разрезе клиентов и месяцев.
В строках должны быть месяцы (дата начала месяца), в столбцах - клиенты.

Клиентов взять с ID 2-6, это все подразделение Tailspin Toys.
Имя клиента нужно поменять так чтобы осталось только уточнение.
Например, исходное значение "Tailspin Toys (Gasport, NY)" - вы выводите только "Gasport, NY".
Дата должна иметь формат dd.mm.yyyy, например, 25.12.2019.

Пример, как должны выглядеть результаты:
-------------+--------------------+--------------------+-------------+--------------+------------
InvoiceMonth | Peeples Valley, AZ | Medicine Lodge, KS | Gasport, NY | Sylvanite, MT | Jessie, ND
-------------+--------------------+--------------------+-------------+--------------+------------
01.01.2013   |      3             |        1           |      4      |      2        |     2
01.02.2013   |      7             |        3           |      4      |      2        |     1
-------------+--------------------+--------------------+-------------+--------------+------------
*/

--Вариант 1
; With CustInvCTE as (
						Select	substring(cust.CustomerName, charindex('(', cust.CustomerName) + 1,  len(cust.CustomerName)-len('Tailspin Toys (') - 1  ) as CustomerName,
								count(inv.InvoiceID)																as CountInv, 
								format(DATEFROMPARTS(Year(inv.InvoiceDate),month(inv.InvoiceDate),1), 'dd.MM.yyyy') as InvoiceMonth
							from Sales.Customers cust
							join Sales.Invoices inv on inv.CustomerID = cust.CustomerID
						Where cust.CustomerName like ('Tailspin Toys%')
							  and cust.CustomerID between 2 and 6
						group by cust.CustomerName, DATEFROMPARTS(Year(inv.InvoiceDate),month(inv.InvoiceDate),1)
					 )

Select	PVT.InvoiceMonth					as InvoiceMonth, 
		isnull(PVT.[Peeples Valley, AZ],0)	as [Peeples Valley, AZ], 
		isnull(PVT.[Medicine Lodge, KS],0)	as [Medicine Lodge, KS], 
		isnull(PVT.[Gasport, NY],0)			as [Gasport, NY], 
		isnull(PVT.[Sylvanite, MT],0)		as [Sylvanite, MT], 
		isnull(PVT.[Jessie, ND],0)			as [Jessie, ND] 
		from CustInvCTE
pivot (sum(CustInvCTE.CountInv) 
	  for CustInvCTE.CustomerName IN ([Peeples Valley, AZ],[Medicine Lodge, KS],[Gasport, NY],[Sylvanite, MT],[Jessie, ND])) as PVT
order by year(pvt.InvoiceMonth),month(pvt.InvoiceMonth)
						
--Вариант 2 (без CTE)
			Select	PVT.InvoiceMonth					as InvoiceMonth, 
					isnull(PVT.[Peeples Valley, AZ],0)	as [Peeples Valley, AZ], 
					isnull(PVT.[Medicine Lodge, KS],0)	as [Medicine Lodge, KS], 
					isnull(PVT.[Gasport, NY],0)			as [Gasport, NY], 
					isnull(PVT.[Sylvanite, MT],0)		as [Sylvanite, MT], 
					isnull(PVT.[Jessie, ND],0)			as [Jessie, ND] 
			from 
			(
			Select	substring(cust.CustomerName, charindex('(', cust.CustomerName) + 1,  len(cust.CustomerName)-len('Tailspin Toys (') - 1  ) as CustomerName,
					count(inv.InvoiceID)																as CountInv, 
					format(DATEFROMPARTS(Year(inv.InvoiceDate),month(inv.InvoiceDate),1), 'dd.MM.yyyy') as InvoiceMonth
				from Sales.Customers cust
				join Sales.Invoices inv on inv.CustomerID = cust.CustomerID
			Where cust.CustomerName like ('Tailspin Toys%')
				  and cust.CustomerID between 2 and 6
			group by cust.CustomerName, DATEFROMPARTS(Year(inv.InvoiceDate),month(inv.InvoiceDate),1)
			) as CustInv
pivot (sum(CustInv.CountInv) for CustInv.CustomerName IN ([Peeples Valley, AZ],[Medicine Lodge, KS],[Gasport, NY],[Sylvanite, MT],[Jessie, ND])) as PVT
order by year(pvt.InvoiceMonth),month(pvt.InvoiceMonth)

/*
2. Для всех клиентов с именем, в котором есть "Tailspin Toys"
вывести все адреса, которые есть в таблице, в одной колонке.

Пример результата:
----------------------------+--------------------
CustomerName                | AddressLine
----------------------------+--------------------
Tailspin Toys (Head Office) | Shop 38
Tailspin Toys (Head Office) | 1877 Mittal Road
Tailspin Toys (Head Office) | PO Box 8975
Tailspin Toys (Head Office) | Ribeiroville
----------------------------+--------------------
*/

--Вариант 1 
Select UnPVT.CustomerName,
	   UnPVT.AddressLine
	   --,UnPVT.colname
		from (
				Select	cust.CustomerName as CustomerName,
						cust.DeliveryAddressLine1,
						cust.DeliveryAddressLine2,
						cust.PostalAddressLine1,
						cust.PostalAddressLine2
					from Sales.Customers cust
				   Where cust.CustomerName like ('%Tailspin Toys%')
			  ) custAddr
UNPIVOT ( AddressLine for СolName in (DeliveryAddressLine1,DeliveryAddressLine2,PostalAddressLine1,PostalAddressLine2) )  as UnPVT

--Вариант 2 
Select UnPVT.CustomerName,
	   UnPVT.AddressLine
	   --,UnPVT.colname
	from Sales.Customers cust
UNPIVOT ( AddressLine for СolName in (DeliveryAddressLine1,DeliveryAddressLine2,PostalAddressLine1,PostalAddressLine2) )  as UnPVT
Where UnPVT.CustomerName like ('%Tailspin Toys%')

/*
3. В таблице стран (Application.Countries) есть поля с цифровым кодом страны и с буквенным.
Сделайте выборку ИД страны, названия и ее кода так, 
чтобы в поле с кодом был либо цифровой либо буквенный код.

Пример результата:
--------------------------------
CountryId | CountryName | Code
----------+-------------+-------
1         | Afghanistan | AFG
1         | Afghanistan | 4
3         | Albania     | ALB
3         | Albania     | 8
----------+-------------+-------
*/
; With cntrCTE as (
						Select	cntr.CountryId							as CountryId,
								cntr.CountryName						as CountryName,
								cast(cntr.IsoAlpha3Code as nvarchar)	as IsoAlpha3Code, 
								cast(cntr.IsoNumericCode as nvarchar)	as IsoNumericCode 
						from Application.Countries cntr
				  ) 
Select	UnPVT.CountryId, 
		UnPVT.CountryName,
		UnPVT.Code
from cntrCTE
unpivot (Code for colName IN (IsoAlpha3Code, IsoNumericCode) )as UnPVT

/*
4. Выберите по каждому клиенту два самых дорогих товара, которые он покупал.
В результатах должно быть ид клиета, его название, ид товара, цена, дата покупки.
*/

--Вариант 1 с использованием Cross apply
Select	cust.CustomerID, 
		cust.CustomerName, 
		tablProduct.StockItemID,
		tablProduct.Price,
		tablOrd.OrderDate
from Sales.Customers cust
Cross apply	(
				Select distinct top 2 
						ord.OrderID			     as OrderID,
						ordLine.StockItemID		 as StockItemID,	
						ordLine.Description		 as Description,	
						ordLine.UnitPrice		 as Price
				from  Sales.Orders ord
				 join Sales.OrderLines ordLine on ordLine.OrderID = ord.OrderID
				Where ord.CustomerID = cust.CustomerID
				order by ordLine.UnitPrice DESC
			) tablProduct
Cross apply	(
				Select ord.OrderDate	as OrderDate
				from  Sales.Orders ord
				Where ord.OrderID = tablProduct.OrderID 
			) tablOrd
order by cust.CustomerName, tablProduct.Price DESC, tablOrd.OrderDate

--Вариант 2 
Select	cust.CustomerID, 
		cust.CustomerName, 
		tablProduct.StockItemID,
		tablProduct.Price,
		ord.OrderDate as OrderDate
from Sales.Customers cust
Cross apply	(
				Select distinct top 2 
						ordLine.StockItemID		 as StockItemID,	
						ordLine.UnitPrice		 as Price,
						ord.OrderID				 as OrderID
				from  Sales.Orders ord
				 join Sales.OrderLines ordLine on ordLine.OrderID = ord.OrderID
				Where ord.CustomerID = cust.CustomerID
				order by ordLine.UnitPrice DESC
			) tablProduct
join Sales.Orders ord		  on tablProduct.OrderID = ord.OrderID 
order by cust.CustomerName, tablProduct.Price DESC, ord.OrderDate 