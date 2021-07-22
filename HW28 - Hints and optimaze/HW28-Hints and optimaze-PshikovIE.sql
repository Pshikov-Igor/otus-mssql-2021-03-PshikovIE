SET STATISTICS IO, TIME ON

Select ord.CustomerID, det.StockItemID, SUM(det.UnitPrice), SUM(det.Quantity), COUNT(ord.OrderID)
FROM Sales.Orders AS ord																		--Заказы
JOIN Sales.OrderLines AS det ON det.OrderID = ord.OrderID										--СтрокиЗаказов
JOIN Sales.Invoices AS Inv ON Inv.OrderID = ord.OrderID											--Счета
JOIN Sales.CustomerTransactions AS Trans ON Trans.InvoiceID = Inv.InvoiceID						--Клиентские операции
JOIN Warehouse.StockItemTransactions AS ItemTrans ON ItemTrans.StockItemID = det.StockItemID	--Транзакции 
WHERE Inv.BillToCustomerID != ord.CustomerID  -- счет для ид клиента 
	AND (
		Select SupplierId FROM Warehouse.StockItems AS It --Где идентификатор поставщика товаров = 12
		Where It.StockItemID = det.StockItemID
		) = 12 
	AND (
		SELECT SUM(Total.UnitPrice*Total.Quantity) --Итоговая сумма по клиенту > 250000 
		FROM Sales.OrderLines AS Total 
		Join Sales.Orders AS ordTotal On ordTotal.OrderID = Total.OrderID 
		WHERE ordTotal.CustomerID = Inv.CustomerID
		) > 250000 
	AND DATEDIFF(dd, Inv.InvoiceDate, ord.OrderDate) = 0 --Своевременная оплата
GROUP BY ord.CustomerID, det.StockItemID 
ORDER BY ord.CustomerID, det.StockItemID

/*
Комментарий:
1) Запрос плохо читаемый за счет наличия двух вложенных запросов в SELECT.
Как предложение, использовать CTE для наглядности.
2) Анализируя план запросов суть проблемы примера в том, что неэффективно используются индексы.
Стоимость операции Index SCAN 93%, где количество прочитанных строк 70510 (табл. Invoices)
*/

; With salesCTE as (
					SELECT ordTotal.CustomerID--, SUM(Total.UnitPrice*Total.Quantity) as TotalSUM 
					FROM Sales.OrderLines	AS Total 
					Join Sales.Orders		AS ordTotal On ordTotal.OrderID = Total.OrderID 
					GROUP BY ordTotal.CustomerID 
					HAVING SUM(Total.UnitPrice*Total.Quantity) > 250000 
					)


Select	ord.CustomerID		as CustomerID, 
		det.StockItemID		as StockItemID, 
		SUM(det.UnitPrice)	as SumUnitPrice, 
		SUM(det.Quantity)	as SumQuantity, 
		COUNT(ord.OrderID)	as CountOrder
FROM salesCTE							AS sCTE
JOIN Sales.Invoices						AS Inv ON sCTE.CustomerID = Inv.CustomerID
JOIN Sales.Orders						AS ord	ON Inv.OrderID = ord.OrderID																
JOIN Sales.OrderLines					AS det	ON det.OrderID = ord.OrderID										
JOIN Warehouse.StockItems				AS It	ON It.StockItemID = det.StockItemID
JOIN Sales.CustomerTransactions			AS Trans ON Trans.InvoiceID = Inv.InvoiceID					
JOIN Warehouse.StockItemTransactions	AS ItemTrans ON ItemTrans.StockItemID = det.StockItemID		
WHERE Inv.BillToCustomerID != ord.CustomerID  
	AND DATEDIFF(dd, Inv.InvoiceDate, ord.OrderDate) = 0 
    AND It.SupplierId = 12
GROUP BY ord.CustomerID, det.StockItemID 
ORDER BY ord.CustomerID, det.StockItemID

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