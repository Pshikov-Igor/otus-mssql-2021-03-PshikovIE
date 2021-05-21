/*
Домашнее задание по курсу MS SQL Server Developer в OTUS.

Занятие "12 - Хранимые процедуры, функции, триггеры, курсоры".

Задания выполняются с использованием базы данных WideWorldImporters.

Бэкап БД можно скачать отсюда:
https://github.com/Microsoft/sql-server-samples/releases/tag/wide-world-importers-v1.0
Нужен WideWorldImporters-Full.bak

Описание WideWorldImporters от Microsoft:
* https://docs.microsoft.com/ru-ru/sql/samples/wide-world-importers-what-is
* https://docs.microsoft.com/ru-ru/sql/samples/wide-world-importers-oltp-database-catalog
*/

USE WideWorldImporters

/*
Во всех заданиях написать хранимую процедуру / функцию и продемонстрировать ее использование.
*/

/*
1) Написать функцию возвращающую Клиента с наибольшей суммой покупки.
*/

----
--Хранимая процедура
----

CREATE PROCEDURE Sales.uspGetCustomerMaxInv
AS
BEGIN
	SET NOCOUNT ON;
    
	With InvoicesCTE as (
						SELECT top 1 inv.CustomerID, inv.InvoiceID, SUM(invLine.ExtendedPrice) as Price 
							from Sales.Invoices inv 
							join Sales.InvoiceLines invLine on inv.InvoiceID = invLine.InvoiceID
						Group by inv.CustomerID, inv.InvoiceID
						order by SUM(invLine.ExtendedPrice) DESC
					    )

	Select cust.CustomerName, InvoicesCTE.Price 
	from Sales.Customers cust
	join InvoicesCTE on InvoicesCTE.CustomerID = cust.CustomerID
	RETURN
END
GO

----
--Запрос
----
EXECUTE Sales.uspGetCustomerMaxInv

--DROP PROCEDURE Sales.uspGetCustomerMaxInv

/*
2) Написать хранимую процедуру с входящим параметром СustomerID, выводящую сумму покупки по этому клиенту.
Использовать таблицы :
Sales.Customers
Sales.Invoices
Sales.InvoiceLines
*/

----
--Хранимая процедура
----

CREATE PROCEDURE Sales.uspGetSumInvoiceForCustomers
				@СustomerID int 
AS
BEGIN
	SET NOCOUNT ON;

	SELECT SUM(invLine.ExtendedPrice) as SumInvoices 
		from Sales.Customers cust
		join Sales.Invoices inv on inv.CustomerID = cust.CustomerID
		join Sales.InvoiceLines invLine on inv.InvoiceID = invLine.InvoiceID
	Where cust.CustomerID = @СustomerID
	RETURN
END
GO

----
--Запрос
----
EXECUTE Sales.uspGetSumInvoiceForCustomers @СustomerID = 2

--DROP PROCEDURE Sales.uspGetSumInvoiceForCustomers

/*
3) Создать одинаковую функцию и хранимую процедуру, посмотреть в чем разница в производительности и почему.
*/

----
--Процедура
----

CREATE PROCEDURE Sales.uspGetCustomerInvoices
				@countRows int 
AS
BEGIN
	SET NOCOUNT ON;
    
	SELECT top( @countRows ) cust.CustomerName, inv.InvoiceID, inv.InvoiceDate, SUM(invLine.ExtendedPrice) as Price 
		from Sales.Customers cust
		join Sales.Invoices inv on inv.CustomerID = cust.CustomerID
		join Sales.InvoiceLines invLine on inv.InvoiceID = invLine.InvoiceID
	Group by cust.CustomerName, inv.InvoiceID, inv.InvoiceDate
	order by SUM(invLine.ExtendedPrice) DESC
	RETURN
END
GO

----
--Функция
----

CREATE FUNCTION Sales.funGetCustomerInvoices( @countRows int)
RETURNS TABLE  
AS
RETURN
(
	SELECT top (@countRows) cust.CustomerName, inv.InvoiceID, inv.InvoiceDate, SUM(invLine.ExtendedPrice) as Price 
		from Sales.Customers cust
		join Sales.Invoices inv on inv.CustomerID = cust.CustomerID
		join Sales.InvoiceLines invLine on inv.InvoiceID = invLine.InvoiceID
	Group by cust.CustomerName, inv.InvoiceID, inv.InvoiceDate
	order by SUM(invLine.ExtendedPrice) DESC
)
GO

SET STATISTICS IO,TIME ON;

EXECUTE Sales.uspGetCustomerInvoices 101

Select * from Sales.funGetCustomerInvoices(101)

SET STATISTICS IO,TIME OFF;

--DROP PROCEDURE Sales.uspGetCustomerInvoices
--DROP FUNCTION Sales.funGetCustomerInvoices

/*
Сверим производительность:
В моем случае получается, что общее затраченное время на выполнение процедуры получилось больше, чем выполнение идентичной Функции.
Предположу, что в случае запуске процедуры дополнительно были затрачены ресурсы на компиляцию,чем в случае с функцией (посути это то же представление).
Хотя с точки зрения универсальности и возможности использования более широкого спектра запросов и действий процедура всетаки более универсальна для использования.


Время синтаксического анализа и компиляции SQL Server: 
 время ЦП = 37 мс, истекшее время = 37 мс.

 Время работы SQL Server:
   Время ЦП = 0 мс, затраченное время = 0 мс.
Таблица "Worktable". Число просмотров 0, логических чтений 0, физических чтений 0, упреждающих чтений 0, lob логических чтений 0, lob физических чтений 0, lob упреждающих чтений 0.
Таблица "Worktable". Число просмотров 0, логических чтений 0, физических чтений 0, упреждающих чтений 0, lob логических чтений 0, lob физических чтений 0, lob упреждающих чтений 0.
Таблица "Customers". Число просмотров 0, логических чтений 217, физических чтений 0, упреждающих чтений 0, lob логических чтений 0, lob физических чтений 0, lob упреждающих чтений 0.
Таблица "Invoices". Число просмотров 0, логических чтений 318, физических чтений 0, упреждающих чтений 0, lob логических чтений 0, lob физических чтений 0, lob упреждающих чтений 0.
Таблица "InvoiceLines". Число просмотров 1, логических чтений 5003, физических чтений 0, упреждающих чтений 0, lob логических чтений 0, lob физических чтений 0, lob упреждающих чтений 0.

 Время работы SQL Server:
   Время ЦП = 63 мс, затраченное время = 65 мс.

 Время работы SQL Server:
   Время ЦП = 0 мс, затраченное время = 0 мс.

 Время работы SQL Server:
   Время ЦП = 98 мс, затраченное время = 97 мс.

(затронуто строк: 101)
Таблица "Worktable". Число просмотров 0, логических чтений 0, физических чтений 0, упреждающих чтений 0, lob логических чтений 0, lob физических чтений 0, lob упреждающих чтений 0.
Таблица "Worktable". Число просмотров 0, логических чтений 0, физических чтений 0, упреждающих чтений 0, lob логических чтений 0, lob физических чтений 0, lob упреждающих чтений 0.
Таблица "Customers". Число просмотров 0, логических чтений 217, физических чтений 0, упреждающих чтений 0, lob логических чтений 0, lob физических чтений 0, lob упреждающих чтений 0.
Таблица "Invoices". Число просмотров 0, логических чтений 318, физических чтений 0, упреждающих чтений 0, lob логических чтений 0, lob физических чтений 0, lob упреждающих чтений 0.
Таблица "InvoiceLines". Число просмотров 1, логических чтений 5003, физических чтений 0, упреждающих чтений 0, lob логических чтений 0, lob физических чтений 0, lob упреждающих чтений 0.

 Время работы SQL Server:
   Время ЦП = 78 мс, затраченное время = 72 мс.

Время выполнения: 2021-05-21T11:03:05.5353662+03:00
*/

/*
4) Создайте табличную функцию покажите как ее можно вызвать для каждой строки result set'а без использования цикла. 
*/

CREATE FUNCTION Sales.funGetLastInvoicesForCustomersID( @CustomerID Int)
RETURNS TABLE  
AS
RETURN
(
	SELECT inv.CustomerID, Max(inv.InvoiceDate) as InvoiceLastDate, sum(invLine.ExtendedPrice) as SummaInvoices
		from Sales.Invoices inv 
		join Sales.InvoiceLines invLine on inv.InvoiceID = invLine.InvoiceID
    Where @CustomerID = inv.CustomerID
	Group by inv.CustomerID
)
GO

SET STATISTICS IO,TIME ON;

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

BEGIN TRANSACTION

	Select cust.CustomerID, cust.CustomerName, func.InvoiceLastDate, func.SummaInvoices
			from Sales.Customers cust
	 cross apply Sales.funGetLastInvoicesForCustomersID(cust.CustomerID) func
	Where cust.CustomerName like 'Tailspin Toys%'

COMMIT TRANSACTION; 

SET STATISTICS IO,TIME OFF;

--DROP FUNCTION Sales.funGetLastInvoicesForCustomersID

/*
5) Опционально. Во всех процедурах укажите какой уровень изоляции транзакций вы бы использовали и почему. 
*/
/*
Во всех процедурах используются таблицы которые постоянно используются в работе Приложения (оформления заказов), т.е. предположим, что обращений к ним будет много. 
Во всех процедурах и функциях используются один запрос типа Select, а так же используются объединения по ключам и индексированным данным. 
В данном случае затраты и ресурсы на данные запросы минимальны (проверил на STATISTICS IO,TIME). Запросы DML на изменение данных (Insert, Delete, Update) отсутствуют.
Поэтому предлагаю использовать следующие уровни изоляции транзакций чтобы исключить "грязное чтение":
1 Задание ) SET TRANSACTION ISOLATION LEVEL READ COMMITTED
2 Задание ) SET TRANSACTION ISOLATION LEVEL READ COMMITTED
3 Задание ) SET TRANSACTION ISOLATION LEVEL READ COMMITTED

В 4 задании хранимая функция вызывается столько раз, сколько строк в запросе, т.е. вызывается для каждой записи. 
В ближайшем будущем количество вызывов (строк) может увеличиться в разы. Дабы измежать блокировки таблиц предлагаю следующий вариант:

4 Задание ) SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
/*


