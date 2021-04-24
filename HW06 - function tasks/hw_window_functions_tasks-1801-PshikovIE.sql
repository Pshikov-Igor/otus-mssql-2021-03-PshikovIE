/*
Домашнее задание по курсу MS SQL Server Developer в OTUS.

Занятие "06 - Оконные функции".

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
1. Сделать расчет суммы продаж нарастающим итогом по месяцам с 2015 года 
(в рамках одного месяца он будет одинаковый, нарастать будет в течение времени выборки).
Выведите: id продажи, название клиента, дату продажи, сумму продажи, сумму нарастающим итогом

Пример:
-------------+----------------------------
Дата продажи | Нарастающий итог по месяцу
-------------+----------------------------
 2015-01-29   | 4801725.31
 2015-01-30	 | 4801725.31
 2015-01-31	 | 4801725.31
 2015-02-01	 | 9626342.98
 2015-02-02	 | 9626342.98
 2015-02-03	 | 9626342.98
Продажи можно взять из таблицы Invoices.
Нарастающий итог должен быть без оконной функции.
*/

set statistics time, io on

; With TableData as (
						Select	tablInv.ИДПродажи,  
								tablInv.НазваниеКлиента,
								tablInv.ДатаПродажи,
								tablInv.СуммаПродажи
								from (
										Select inv.InvoiceID				as ИДПродажи,
											  cust.CustomerName				as НазваниеКлиента,
											   inv.InvoiceDate				as ДатаПродажи,
											   sum(invLine.ExtendedPrice)	as СуммаПродажи
										from Sales.Invoices inv
												 join Sales.Customers cust on inv.CustomerID = cust.CustomerID
												 join Sales.InvoiceLines invLine on inv.InvoiceID = invLine.InvoiceID
										Where Year(inv.InvoiceDate) >= 2015
										group by inv.InvoiceID, cust.CustomerName, inv.InvoiceDate
									 ) as tablInv
					)

Select td1.ИДПродажи, td1.НазваниеКлиента, td1.ДатаПродажи, td1.СуммаПродажи,
	   (
	   Select Sum(td2.СуммаПродажи)
	   From TableData td2
	   Where	month(td2.ДатаПродажи) <= month(td1.ДатаПродажи)
		    and year(td2.ДатаПродажи)  <= year(td1.ДатаПродажи)
	   ) as НарастающийИтогПоМесяцу
	from TableData td1
group by td1.ИДПродажи, td1.НазваниеКлиента, td1.ДатаПродажи, td1.СуммаПродажи
order by td1.ДатаПродажи, td1.ИДПродажи

/*
2. Сделайте расчет суммы нарастающим итогом в предыдущем запросе с помощью оконной функции.
   Сравните производительность запросов 1 и 2 с помощью set statistics time, io on
*/
Select	tablInv.ИДПродажи,  
		tablInv.НазваниеКлиента,
		tablInv.ДатаПродажи,
		tablInv.СуммаПродажи,
		sum(tablInv.СуммаПродажи) OVER ( order by year(tablInv.ДатаПродажи), month(tablInv.ДатаПродажи) ) as НарастающийИтогПоМесяцу	
		from (
				Select inv.InvoiceID				as ИДПродажи,
					  cust.CustomerName				as НазваниеКлиента,
					   inv.InvoiceDate				as ДатаПродажи,
					   sum(invLine.ExtendedPrice)	as СуммаПродажи
				from Sales.Invoices inv
						 join Sales.Customers cust on inv.CustomerID = cust.CustomerID
						 join Sales.InvoiceLines invLine on inv.InvoiceID = invLine.InvoiceID
				Where Year(inv.InvoiceDate) >= 2015
				group by inv.InvoiceID, cust.CustomerName, inv.InvoiceDate
			 ) as tablInv
order by tablInv.ДатаПродажи, tablInv.ИДПродажи

set statistics time, io off

/*

(затронуто строк: 31440)
Таблица "Worktable". Число просмотров 0, логических чтений 0, физических чтений 0, упреждающих чтений 0, lob логических чтений 0, lob физических чтений 0, lob упреждающих чтений 0.
Таблица "Workfile". Число просмотров 886, логических чтений 35440, физических чтений 1772, упреждающих чтений 33668, lob логических чтений 0, lob физических чтений 0, lob упреждающих чтений 0.
Таблица "Invoices". Число просмотров 444, логических чтений 5061600, физических чтений 3, упреждающих чтений 27249, lob логических чтений 0, lob физических чтений 0, lob упреждающих чтений 0.
Таблица "InvoiceLines". Число просмотров 444, логических чтений 2221332, физических чтений 6, упреждающих чтений 7943, lob логических чтений 0, lob физических чтений 0, lob упреждающих чтений 0.
Таблица "Worktable". Число просмотров 0, логических чтений 0, физических чтений 0, упреждающих чтений 0, lob логических чтений 0, lob физических чтений 0, lob упреждающих чтений 0.
Таблица "Customers". Число просмотров 444, логических чтений 17760, физических чтений 2, упреждающих чтений 69, lob логических чтений 0, lob физических чтений 0, lob упреждающих чтений 0.

 Время работы SQL Server:
   Время ЦП = 49687 мс, затраченное время = 68271 мс.

(затронуто строк: 31440)
Таблица "Worktable". Число просмотров 0, логических чтений 0, физических чтений 0, упреждающих чтений 0, lob логических чтений 0, lob физических чтений 0, lob упреждающих чтений 0.
Таблица "Invoices". Число просмотров 1, логических чтений 11400, физических чтений 0, упреждающих чтений 0, lob логических чтений 0, lob физических чтений 0, lob упреждающих чтений 0.
Таблица "Worktable". Число просмотров 0, логических чтений 0, физических чтений 0, упреждающих чтений 0, lob логических чтений 0, lob физических чтений 0, lob упреждающих чтений 0.
Таблица "Customers". Число просмотров 1, логических чтений 40, физических чтений 0, упреждающих чтений 0, lob логических чтений 0, lob физических чтений 0, lob упреждающих чтений 0.
Таблица "InvoiceLines". Число просмотров 1, логических чтений 5003, физических чтений 0, упреждающих чтений 0, lob логических чтений 0, lob физических чтений 0, lob упреждающих чтений 0.

 Время работы SQL Server:
   Время ЦП = 63 мс, затраченное время = 333 мс.

Время выполнения: 2021-04-23T15:36:52.0404370+03:00
*/

/*
3. Вывести список 2х самых популярных продуктов (по количеству проданных) 
в каждом месяце за 2016 год (по 2 самых популярных продукта в каждом месяце).
*/

set statistics time, io on
--Вариант 1
; With itemsCTE as (
					Select	distinct invLine.StockItemID as ИДТовара, 
									 invLine.Description as Товар, 
									 month(inv.InvoiceDate) as МесяцПродажи,
									 count(invLine.StockItemID) OVER ( partition by invLine.StockItemID , month(inv.InvoiceDate) ) as КоличествоПроданныхТоваров
					from Sales.Invoices inv
					join Sales.InvoiceLines invLine on inv.InvoiceID = invLine.InvoiceID
					Where Year(inv.InvoiceDate) = 2016
				   ),

		itemsForMonthCTE as (
								Select
										itemsCTE.ИДТовара,
										itemsCTE.Товар,
										itemsCTE.МесяцПродажи,
										itemsCTE.КоличествоПроданныхТоваров,
										ROW_NUMBER() OVER (PARTITION BY itemsCTE.МесяцПродажи ORDER BY itemsCTE.КоличествоПроданныхТоваров DESC) AS Счетчик
								from itemsCTE
							)			
					
Select  iCTE.МесяцПродажи,
		iCTE.ИДТовара,
		iCTE.Товар,
		iCTE.КоличествоПроданныхТоваров
from itemsForMonthCTE iCTE
Where iCTE.Счетчик <= 2
order by iCTE.МесяцПродажи, iCTE.КоличествоПроданныхТоваров DESC

--Вариант 2
; With itemsCTE as (
					Select	distinct	  invLine.StockItemID as ИДТовара, 
										  invLine.Description as Товар, 
										  month(inv.InvoiceDate) as МесяцПродажи,
										  count(invLine.StockItemID) OVER ( partition by invLine.StockItemID , month(inv.InvoiceDate) ) as КоличествоПроданныхТоваров
									from Sales.Invoices inv
										 join Sales.InvoiceLines invLine on inv.InvoiceID = invLine.InvoiceID
									Where Year(inv.InvoiceDate) = 2016
					)	
					
Select  distinct item.МесяцПродажи,
				 tabletop2.Товар,
				 tabletop2.КоличествоПроданныхТоваров
from itemsCTE item
	cross apply (	
					Select top 2 itemsCTE.МесяцПродажи,
								 itemsCTE.Товар,
								 itemsCTE.КоличествоПроданныхТоваров
					from itemsCTE 
					Where item.МесяцПродажи = itemsCTE.МесяцПродажи
					Order by itemsCTE.МесяцПродажи,itemsCTE.КоличествоПроданныхТоваров DESC
				) as tabletop2
order by item.МесяцПродажи

set statistics time, io off

/*

(затронуто строк: 10)
Таблица "Worktable". Сканирований 0, логических операций чтения 0, физических операций чтения 0, операций чтения страничного сервера 0, операций чтения, выполненных с упреждением 0, операций чтения страничного сервера, выполненных с упреждением 0, логических операций чтения LOB 0, физических операций чтения LOB 0, операций чтения LOB страничного сервера 0, операций чтения LOB, выполненных с упреждением 0, операций чтения LOB страничного сервера, выполненных с упреждением 0.
Таблица "InvoiceLines". Сканирований 9, логических операций чтения 5256, физических операций чтения 0, операций чтения страничного сервера 0, операций чтения, выполненных с упреждением 0, операций чтения страничного сервера, выполненных с упреждением 0, логических операций чтения LOB 0, физических операций чтения LOB 0, операций чтения LOB страничного сервера 0, операций чтения LOB, выполненных с упреждением 0, операций чтения LOB страничного сервера, выполненных с упреждением 0.
Таблица "Invoices". Сканирований 9, логических операций чтения 11994, физических операций чтения 0, операций чтения страничного сервера 0, операций чтения, выполненных с упреждением 0, операций чтения страничного сервера, выполненных с упреждением 0, логических операций чтения LOB 0, физических операций чтения LOB 0, операций чтения LOB страничного сервера 0, операций чтения LOB, выполненных с упреждением 0, операций чтения LOB страничного сервера, выполненных с упреждением 0.

 Время работы SQL Server:
   Время ЦП = 125 мс, затраченное время = 17 мс.

(затронуто строк: 10)
Таблица "Worktable". Сканирований 18, логических операций чтения 319572, физических операций чтения 0, операций чтения страничного сервера 0, операций чтения, выполненных с упреждением 1925, операций чтения страничного сервера, выполненных с упреждением 0, логических операций чтения LOB 0, физических операций чтения LOB 0, операций чтения LOB страничного сервера 0, операций чтения LOB, выполненных с упреждением 0, операций чтения LOB страничного сервера, выполненных с упреждением 0.
Таблица "InvoiceLines". Сканирований 14, логических операций чтения 30271, физических операций чтения 0, операций чтения страничного сервера 0, операций чтения, выполненных с упреждением 0, операций чтения страничного сервера, выполненных с упреждением 0, логических операций чтения LOB 0, физических операций чтения LOB 0, операций чтения LOB страничного сервера 0, операций чтения LOB, выполненных с упреждением 0, операций чтения LOB страничного сервера, выполненных с упреждением 0.
Таблица "Invoices". Сканирований 14, логических операций чтения 68994, физических операций чтения 0, операций чтения страничного сервера 0, операций чтения, выполненных с упреждением 0, операций чтения страничного сервера, выполненных с упреждением 0, логических операций чтения LOB 0, физических операций чтения LOB 0, операций чтения LOB страничного сервера 0, операций чтения LOB, выполненных с упреждением 0, операций чтения LOB страничного сервера, выполненных с упреждением 0.
Таблица "Workfile". Сканирований 0, логических операций чтения 0, физических операций чтения 0, операций чтения страничного сервера 0, операций чтения, выполненных с упреждением 0, операций чтения страничного сервера, выполненных с упреждением 0, логических операций чтения LOB 0, физических операций чтения LOB 0, операций чтения LOB страничного сервера 0, операций чтения LOB, выполненных с упреждением 0, операций чтения LOB страничного сервера, выполненных с упреждением 0.
Таблица "Workfile". Сканирований 0, логических операций чтения 0, физических операций чтения 0, операций чтения страничного сервера 0, операций чтения, выполненных с упреждением 0, операций чтения страничного сервера, выполненных с упреждением 0, логических операций чтения LOB 0, физических операций чтения LOB 0, операций чтения LOB страничного сервера 0, операций чтения LOB, выполненных с упреждением 0, операций чтения LOB страничного сервера, выполненных с упреждением 0.
Таблица "Worktable". Сканирований 0, логических операций чтения 0, физических операций чтения 0, операций чтения страничного сервера 0, операций чтения, выполненных с упреждением 0, операций чтения страничного сервера, выполненных с упреждением 0, логических операций чтения LOB 0, физических операций чтения LOB 0, операций чтения LOB страничного сервера 0, операций чтения LOB, выполненных с упреждением 0, операций чтения LOB страничного сервера, выполненных с упреждением 0.

 Время работы SQL Server:
   Время ЦП = 579 мс, затраченное время = 385 мс.

Время выполнения: 2021-04-24T13:44:54.4339598+03:00
*/

/*
4. Функции одним запросом
Посчитайте по таблице товаров (в вывод также должен попасть ид товара, название, брэнд и цена):
* пронумеруйте записи по названию товара, так чтобы при изменении буквы алфавита нумерация начиналась заново
* посчитайте общее количество товаров и выведете полем в этом же запросе
* посчитайте общее количество товаров в зависимости от первой буквы названия товара
* отобразите следующий id товара исходя из того, что порядок отображения товаров по имени 
* предыдущий ид товара с тем же порядком отображения (по имени)
* названия товара 2 строки назад, в случае если предыдущей строки нет нужно вывести "No items"
* сформируйте 30 групп товаров по полю вес товара на 1 шт

Для этой задачи НЕ нужно писать аналог без аналитических функций.
*/

Select items.StockItemID as ИДТовара,
	   items.StockItemName as НазваниеТовара,
	   isnull(items.Brand,'') as Брэнд,
	   items.RecommendedRetailPrice as Price,
	   ROW_NUMBER() OVER (PARTITION BY LEFT(items.StockItemName, 1) ORDER BY items.StockItemName) AS НомерЗаписиТовараПоПервойБукве,
	   count(items.RecommendedRetailPrice) OVER () as ВсегоТоваров,
	   count(items.RecommendedRetailPrice) OVER (PARTITION BY LEFT(items.StockItemName, 1) order by LEFT(items.StockItemName, 1)) as ВсегоТоваровОтПервойБуквы,
	   LEAD(items.StockItemID) OVER (ORDER BY items.StockItemID) AS ИДСледующегоТовара,
	   LAG(items.StockItemID) OVER (ORDER BY items.StockItemID) AS ИДПредыдущегоТовара,
	   LAG(items.StockItemName, 2, 'No items') OVER(ORDER BY items.StockItemName) as НазваниетоТовараДвеСтрокиНазад,
	   NTILE(30) OVER ( ORDER BY items.TypicalWeightPerUnit ) as НТайл
from Warehouse.StockItems items
order by items.StockItemName

/*
5. По каждому сотруднику выведите последнего клиента, которому сотрудник что-то продал.
   В результатах должны быть ид и фамилия сотрудника, ид и название клиента, дата продажи, сумму сделки.
*/

; With invCTE as (
					Select inv.InvoiceID,
						   inv.InvoiceDate,
						   inv.SalespersonPersonID,
						   ppl.FullName,
						   cust.CustomerID,
						   cust.CustomerName,
						   sum(invLine.extendedPrice) as SumInvoice
					from Sales.Invoices inv
						join Application.People ppl		on inv.SalespersonPersonID = ppl.PersonID
						join Sales.InvoiceLines invLine on inv.InvoiceID = invLine.InvoiceID
						join Sales.Customers cust		on cust.CustomerID = inv.CustomerID
					group by inv.InvoiceID, inv.InvoiceDate, inv.SalespersonPersonID, ppl.FullName, cust.CustomerID, cust.CustomerName
				 ),
		maxInvCTE as (
					Select distinct 
						  LAST_VALUE(inv.InvoiceID) OVER (PARTITION BY inv.SalespersonPersonID order by inv.SalespersonPersonID  ) as LastDoc
					from Sales.Invoices inv
				  ) 	

Select	invCTE.InvoiceID,
		invCTE.InvoiceDate,
		invCTE.SalespersonPersonID,
		invCTE.FullName,
		invCTE.CustomerID,
		invCTE.CustomerName,
		invCTE.SumInvoice
from invCTE 
	join maxInvCTE on invCTE.InvoiceID = maxInvCTE.LastDoc

/*
6. Выберите по каждому клиенту два самых дорогих товара, которые он покупал.
В результатах должно быть ид клиета, его название, ид товара, цена, дата покупки.
*/
; With DataCTE as (
					Select cust.CustomerID,
						   cust.CustomerName,
						   inv.InvoiceDate,
						   invLine.StockItemID,
						   invLine.Description,
						   invLine.UnitPrice,
						   ROW_NUMBER() OVER (PARTITION BY cust.CustomerID ORDER BY invLine.UnitPrice DESC) AS CustRowNumb
					from Sales.Customers cust
					join Sales.Invoices inv			on inv.CustomerID = cust.CustomerID
					join Sales.InvoiceLines invLine on inv.InvoiceID = invLine.InvoiceID 
				  )
Select	DataCTE.CustomerID		as ИДКлиента,
		DataCTE.CustomerName	as НазваниеКлиента,
		DataCTE.StockItemID		as ИДТовара,
		DataCTE.Description		as ИмяТовара,
		DataCTE.UnitPrice		as ЦенаТовара,
		DataCTE.InvoiceDate		as ДатаПокупки 
from DataCTE
Where DataCTE.CustRowNumb <=2

--Опционально можете для каждого запроса без оконных функций сделать вариант запросов с оконными функциями и сравнить их производительность. 