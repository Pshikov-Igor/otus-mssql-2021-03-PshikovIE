/*
Домашнее задание по курсу MS SQL Server Developer в OTUS.

Занятие "03 - Подзапросы, CTE, временные таблицы".

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
-- Для всех заданий, где возможно, сделайте два варианта запросов:
--  1) через вложенный запрос
--  2) через WITH (для производных таблиц)
-- ---------------------------------------------------------------------------

USE WideWorldImporters

/*
1. Выберите сотрудников (Application.People), которые являются продажниками (IsSalesPerson), 
и не сделали ни одной продажи 04 июля 2015 года. 
Вывести ИД сотрудника и его полное имя. 
Продажи смотреть в таблице Sales.Invoices.
*/

--Вариант 1
Select distinct ppl.PersonID as ИДСотрудника, 
				ppl.FullName as ИмяСотрудника
		from Application.People ppl
	  join (
			Select SalespersonPersonID from Sales.Invoices 
				Where InvoiceDate <> '20150704'
			) as inv on inv.SalespersonPersonID = ppl.PersonID
Where ppl.IsSalesPerson = 1 

--Вариант 2
; With invCTE as (
					Select inv.SalespersonPersonID from Sales.Invoices inv
					Where inv.InvoiceDate <> '20150704'
				 )

Select distinct ppl.PersonID as ИДСотрудника, 
				ppl.FullName as ИмяСотрудника
		from Application.People ppl
	  join invCTE on invCTE.SalespersonPersonID = ppl.PersonID
Where ppl.IsSalesPerson = 1 

/*
2. Выберите товары с минимальной ценой (подзапросом). Сделайте два варианта подзапроса. 
Вывести: ИД товара, наименование товара, цена.
*/

--Вариант 1
Select	stItem.StockItemID		as ИДТовара, 
		stItem.StockItemName	as ИмяТовара, 
		stItem.UnitPrice		as ЦенаТовара 
from Warehouse.StockItems stItem
join (
		Select min(UnitPrice) as UnitPrice
		from Warehouse.StockItems 
	 ) as unPrice on unPrice.UnitPrice = stItem.UnitPrice

--Вариант 2
Select	stItem.StockItemID		as ИДТовара, 
		stItem.StockItemName	as ИмяТовара, 
		stItem.UnitPrice		as ЦенаТовара 
from Warehouse.StockItems stItem
Where stItem.UnitPrice = ( 	Select min(UnitPrice) as UnitPrice from Warehouse.StockItems ) 

--Вариант 3
; With stItemCTE as (
					Select min(UnitPrice) as UnitPrice
					from Warehouse.StockItems 
					) 

Select	stItem.StockItemID		as ИДТовара, 
		stItem.StockItemName	as ИмяТовара, 
		stItem.UnitPrice		as ЦенаТовара 
from Warehouse.StockItems stItem
join stItemCTE on stItem.UnitPrice = stItemCTE.UnitPrice

/*
3. Выберите информацию по клиентам, которые перевели компании пять максимальных платежей 
из Sales.CustomerTransactions. 
Представьте несколько способов (в том числе с CTE). 
*/

--Вариант 1
Select cust.CustomerID		as ИДКлиента,
	   cust.CustomerName	as ИмяКлиента,
	   cust.PhoneNumber		as Телефон
from Sales.Customers cust
join (
	Select top 5 tr.CustomerID, Max(tr.TransactionAmount) as MaxTransaction
	from Sales.CustomerTransactions tr
	group by tr.CustomerID
	order by Max(tr.TransactionAmount) DESC
	) as custTr on  cust.CustomerID = custTr.CustomerID

--Вариант 2
; With custTr as (
				  Select top 5 tr.CustomerID, Max(tr.TransactionAmount) as MaxTransaction
				  from Sales.CustomerTransactions tr
				  group by tr.CustomerID
				  order by Max(tr.TransactionAmount) DESC
				 )

Select cust.CustomerID		as ИДКлиента,
	   cust.CustomerName	as ИмяКлиента,
	   cust.PhoneNumber		as Телефон
from Sales.Customers cust
join custTr on  cust.CustomerID = custTr.CustomerID

/*
4. Выберите города (ид и название), в которые были доставлены товары, 
входящие в тройку самых дорогих товаров, а также имя сотрудника, 
который осуществлял упаковку заказов (PackedByPersonID).
*/

--Вариант 1
SELECT Distinct city.CityID			as ИДГорода, 
				city.CityName		as НазваниеГорода, 
				ppl.FullName		as ИмяСотрудника
FROM Sales.Invoices	inv
JOIN Application.People	ppl			on ppl.PersonID = inv.PackedByPersonID 
JOIN Sales.InvoiceLines invLine		on inv.InvoiceID = invLine.InvoiceID
JOIN Sales.Customers cust			on cust.CustomerID = inv.CustomerID
JOIN Application.Cities	city		on city.CityID = cust.DeliveryCityID
JOIN (Select top 3 StockItemID
	  from Warehouse.StockItems 
	  order by UnitPrice DESC) as stItem on invLine.StockItemID = stItem.StockItemID 

--Вариант 2
; With stItemCTE as (
						Select top 3 stItem.StockItemID, stItem.UnitPrice 
						from Warehouse.StockItems stItem
						order by stItem.UnitPrice DESC
					)

SELECT Distinct city.CityID			as ИДГорода, 
				city.CityName		as НазваниеГорода, 
				(SELECT People.FullName
				 FROM Application.People 
				 WHERE People.PersonID = inv.PackedByPersonID) as ИмяСотрудника
FROM stItemCTE
JOIN Sales.InvoiceLines invLine		on invLine.StockItemID = stItemCTE.StockItemID 
JOIN Sales.Invoices	inv				on inv.InvoiceID = invLine.InvoiceID
JOIN Sales.Customers cust			on cust.CustomerID = inv.CustomerID
JOIN Application.Cities	city		on city.CityID = cust.DeliveryCityID

-- ---------------------------------------------------------------------------
-- Опциональное задание
-- ---------------------------------------------------------------------------
-- Можно двигаться как в сторону улучшения читабельности запроса, 
-- так и в сторону упрощения плана\ускорения. 
-- Сравнить производительность запросов можно через SET STATISTICS IO, TIME ON. 
-- Если знакомы с планами запросов, то используйте их (тогда к решению также приложите планы). 
-- Напишите ваши рассуждения по поводу оптимизации. 

-- 5. Объясните, что делает и оптимизируйте запрос
SET STATISTICS IO, TIME ON

SELECT 
	Invoices.InvoiceID, 
	Invoices.InvoiceDate,
	(SELECT People.FullName
		FROM Application.People
		WHERE People.PersonID = Invoices.SalespersonPersonID
	) AS SalesPersonName,
	SalesTotals.TotalSumm AS TotalSummByInvoice, 
	(SELECT SUM(OrderLines.PickedQuantity*OrderLines.UnitPrice)
		FROM Sales.OrderLines
		WHERE OrderLines.OrderId = (SELECT Orders.OrderId 
			FROM Sales.Orders
			WHERE Orders.PickingCompletedWhen IS NOT NULL	
				AND Orders.OrderId = Invoices.OrderId)	
	) AS TotalSummForPickedItems
FROM Sales.Invoices 
	JOIN
	(SELECT InvoiceId, SUM(Quantity*UnitPrice) AS TotalSumm
	FROM Sales.InvoiceLines
	GROUP BY InvoiceId
	HAVING SUM(Quantity*UnitPrice) > 27000) AS SalesTotals
		ON Invoices.InvoiceID = SalesTotals.InvoiceID
ORDER BY TotalSumm DESC

-- ---
/*
Комментарий:
1) Запрос плохо читаемый за счет наличия двух вложенных запросов в SELECT.
Как предложение, использовать CTE для наглядности.
2) Анализируя план запросов суть проблемы примера в том, что неэффективно используются индексы.
Стоимость операции Index SCAN 93%, где количество прочитанных строк 70510 (табл. Invoices)
*/
-- ---

--Отработанные заказы (т.е. которые были собраны (отгружены))
; WITH PickedItemsCTE as (
							SELECT Orders.OrderId, 
								SUM(OrderLines.PickedQuantity*OrderLines.UnitPrice) as Summa
							FROM Sales.OrderLines
							JOIN Sales.Orders ON OrderLines.OrderId = Orders.OrderId
							WHERE Orders.PickingCompletedWhen IS NOT NULL
							GROUP BY Orders.OrderId
						 ),
--СчетаФактуры сумма которых больше 27000

	   SalesCTE as (
					SELECT InvoiceLines.InvoiceID, SUM(Quantity*UnitPrice) AS TotalSumm
					FROM Sales.InvoiceLines 
					GROUP BY InvoiceLines.InvoiceID
					HAVING SUM(Quantity*UnitPrice) > 27000
				   ),

	   SalesTotalsCTE as (
							SELECT Invoices.InvoiceID, Invoices.OrderId, Invoices.SalespersonPersonID, Invoices.InvoiceDate, SalesCTE.TotalSumm
							FROM Sales.Invoices 
							JOIN SalesCTE ON Invoices.InvoiceID = SalesCTE.InvoiceID
						 )

Select	SalesTotalsCTE.InvoiceID	as ИДСчета,
		SalesTotalsCTE.InvoiceDate  as ДатаСчета ,
		People.FullName				as ИмяСотрудника,
		SalesTotalsCTE.TotalSumm	as ИтоговаяСуммаСчетФактуры,
		PickedItemsCTE.Summa		as ИтоговаяСуммаЗаказа
FROM Application.People 
JOIN SalesTotalsCTE on People.PersonID = SalesTotalsCTE.SalespersonPersonID
JOIN PickedItemsCTE on SalesTotalsCTE.OrderId = PickedItemsCTE.OrderId
ORDER BY SalesTotalsCTE.TotalSumm DESC;

SET STATISTICS IO, TIME OFF

/*

Cравнение затраченного времени 

Исходный запрос:
 Время работы SQL Server:
   Время ЦП = 164 мс, затраченное время = 2543 мс.

Скорректированный запрос:
 Время работы SQL Server:
   Время ЦП = 62 мс, затраченное время = 183 мс.

*/