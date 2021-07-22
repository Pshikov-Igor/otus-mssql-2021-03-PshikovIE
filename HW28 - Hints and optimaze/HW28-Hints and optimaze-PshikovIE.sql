Use WideWorldImporters
GO

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
Первоначальный комментарий:
1) Запрос плохо читаемый за счет наличия двух вложенных запросов в Where.
2) Большое количество строк для выполнений, можно подумать как избежать этого. 
3) Наличие Index Scan.
4) Hash Match соединение занимает 39% и 6% стоимости запроса
В результате: Как предложение, использовать CTE, попробуем применить временную таблицу, а так же попробуем разные варианты хинтов для объединений и использование индексов.
			  Попробуем несколько вариантов.
*/

------------
--Вариант 1-
------------

--Выбираем всех CustomerID у которых итоговая сумма покупок > 250000 дабы минимизаровать в дальнейшем количество строк при объединении таблиц.
--В данном CTE используются индексы, так что все быстро и красиво.
; With salesCTE as (
					SELECT ordTotal.CustomerID
					FROM Sales.OrderLines	AS Total 
					Join Sales.Orders		AS ordTotal On ordTotal.OrderID = Total.OrderID 
					GROUP BY ordTotal.CustomerID 
					HAVING SUM(Total.UnitPrice*Total.Quantity) > 250000 
					),
--Соберем данные по заказам клиентов
		OrdersCTE as (
						Select ord.OrderID, ord.CustomerID, ord.OrderDate 
						from Sales.Orders ord
						JOIN salesCTE ON salesCTE.CustomerID = ord.CustomerID 
					  ),
--Заполним основной CTE данными и навесим логики
		dataCTE as (
						Select OrdersCTE.OrderID, OrdersCTE.CustomerID, det.StockItemID, det.UnitPrice, det.Quantity 
						from OrdersCTE
						JOIN Sales.OrderLines		AS det		 ON det.OrderID = OrdersCTE.OrderID 										
						JOIN Sales.Invoices			AS Inv		 ON Inv.OrderID = OrdersCTE.OrderID 
						JOIN Warehouse.StockItems	AS It		 ON det.StockItemID = It.StockItemID
						Where DATEDIFF(dd, Inv.InvoiceDate, OrdersCTE.OrderDate) = 0 
							  and Inv.BillToCustomerID != OrdersCTE.CustomerID
							  and It.SupplierId = 12 
					)			  

--Произведем подсчет. Так же в Select добавим алиасы. Без них не красиво!
Select	dataCTE.CustomerID		as CustomerID, 
		dataCTE.StockItemID		as StockItemID, 
		SUM(dataCTE.UnitPrice)	as SumUnitPrice,
		SUM(dataCTE.Quantity)	as SumQuantity, 
		COUNT(dataCTE.OrderID)	as CountOrder
FROM dataCTE							
JOIN Warehouse.StockItemTransactions	AS ItemTrans ON ItemTrans.StockItemID = dataCTE.StockItemID		
GROUP BY dataCTE.CustomerID, dataCTE.StockItemID 
ORDER BY dataCTE.CustomerID, dataCTE.StockItemID
Option (recompile) -- Генерируем новый план запроса

/*
Комментарий:
Получили небольшой выигрыш.
По сравнению с Вариантом 2 более удачный по времени, однако избавится от большого числа логических операций чтения таблици Invoices хинтами не вышло. 
Cравнение затраченного времени 
---------------------------------------------------
-Исходный запрос:								  -
- Время работы SQL Server:						  -		
-	Время ЦП = 338 мс, затраченное время = 426 мс.-
---------------------------------------------------

Время синтаксического анализа и компиляции SQL Server: 
 время ЦП = 45 мс, истекшее время = 45 мс.

Скорректированный запрос:
 Время работы SQL Server:
   Время ЦП = 281 мс, затраченное время = 412 мс.

*/
------------
--Вариант 2-

DROP TABLE IF EXISTS #TempTable
Create table #TempTable
(  
	OrderID		int, 
	CustomerID	int, 
	StockItemID	int,  
	UnitPrice	decimal(18,2), 
	Quantity	int
)

CREATE INDEX ind_TT_StockItemID ON #TempTable (StockItemID ASC) --немножко поправил ситуацию при объединении таблиц
GO

; With salesCTE as (
					SELECT ordTotal.CustomerID
					FROM Sales.OrderLines	AS Total 
					Join Sales.Orders		AS ordTotal On ordTotal.OrderID = Total.OrderID 
					GROUP BY ordTotal.CustomerID 
					HAVING SUM(Total.UnitPrice*Total.Quantity) > 250000 
					)

insert into #TempTable(OrderID, CustomerID, StockItemID, UnitPrice, Quantity) --Заполняем временную таблицу большим объемом данных
Select ord.OrderID, ord.CustomerID, det.StockItemID, det.UnitPrice, det.Quantity 
from salesCTE
JOIN Sales.Orders		AS ord		 ON salesCTE.CustomerID = ord.CustomerID 	
JOIN Sales.OrderLines	AS det		 ON det.OrderID = ord.OrderID 										
JOIN Sales.Invoices		AS Inv		 ON Inv.OrderID = ord.OrderID 
Where DATEDIFF(dd, Inv.InvoiceDate, ord.OrderDate) = 0 
		and Inv.BillToCustomerID != ord.CustomerID
		and det.StockItemID in (
								Select It.StockItemID from Warehouse.StockItems AS It
								Where It.SupplierId = 12 and det.StockItemID = It.StockItemID
								) 
--Производим подсчет
Select	Tdata.CustomerID		as CustomerID, 
		Tdata.StockItemID		as StockItemID, 
		SUM(Tdata.UnitPrice)	as SumUnitPrice,
		SUM(Tdata.Quantity)		as SumQuantity, 
		COUNT(Tdata.OrderID)	as CountOrder
FROM #TempTable AS Tdata						
JOIN Warehouse.StockItemTransactions	AS ItemTrans ON ItemTrans.StockItemID = Tdata.StockItemID		
GROUP BY Tdata.CustomerID, Tdata.StockItemID 
ORDER BY Tdata.CustomerID, Tdata.StockItemID
Option (recompile) -- Генерируем новый план запроса

SET STATISTICS IO, TIME OFF

/*
Комментарий:
Включился параллелизм. Ушли от большого числа логических операций чтения таблици Invoices. 
По времени результаты практически идентичны
---------------------------------------------------
-Исходный запрос:								  -	
- Время работы SQL Server:						  -
-   Время ЦП = 329 мс, затраченное время = 417 мс.-
---------------------------------------------------
т.к. результат состоит из двух подзапросов, то суммируем время обоих

Время синтаксического анализа и компиляции SQL Server: 
 время ЦП = 35 мс, истекшее время = 33 мс.
Время синтаксического анализа и компиляции SQL Server: 
 время ЦП = 9 мс, истекшее время = 9 мс.

Скорректированный запрос:
 Время работы SQL Server:
   Время ЦП = 201 мс, затраченное время = 67 мс.
 Время работы SQL Server:
   Время ЦП = 234 мс, затраченное время = 263 мс.

ИГОТО без учета синтаксического анализа и компиляции SQL Server
Время работы SQL Server:
   Время ЦП = 435 мс, затраченное время = 330 мс.

*/