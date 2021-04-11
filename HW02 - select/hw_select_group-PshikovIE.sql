/*
Домашнее задание по курсу MS SQL Server Developer в OTUS.
Занятие "02 - Оператор SELECT и простые фильтры, GROUP BY, HAVING".

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
1. Все товары, в названии которых есть "urgent" или название начинается с "Animal".
Вывести: ИД товара (StockItemID), наименование товара (StockItemName).
Таблицы: Warehouse.StockItems.
*/

Select stItems.StockItemID		as ИДТовара, 
	   stItems.StockItemName	as НаименованиеТовара
from Warehouse.StockItems stItems
Where stItems.StockItemName like '%urgent%'
   or stItems.StockItemName like 'Animal%'

/*
2. Поставщиков (Suppliers), у которых не было сделано ни одного заказа (PurchaseOrders).
Сделать через JOIN, с подзапросом задание принято не будет.
Вывести: ИД поставщика (SupplierID), наименование поставщика (SupplierName).
Таблицы: Purchasing.Suppliers, Purchasing.PurchaseOrders.
По каким колонкам делать JOIN подумайте самостоятельно.
*/

Select	supp.SupplierID		as ИДПоставщика, 
		supp.SupplierName	as НаименованиеПоставщика 
	from Purchasing.Suppliers supp
	left join Purchasing.PurchaseOrders orders on supp.SupplierID = orders.SupplierID
Where orders.SupplierID is null

/*
3. Заказы (Orders) с ценой товара (UnitPrice) более 100$ 
либо количеством единиц (Quantity) товара более 20 штук
и присутствующей датой комплектации всего заказа (PickingCompletedWhen).
Вывести:
* OrderID
* дату заказа (OrderDate) в формате ДД.ММ.ГГГГ
* название месяца, в котором был сделан заказ
* номер квартала, в котором был сделан заказ
* треть года, к которой относится дата заказа (каждая треть по 4 месяца)
* имя заказчика (Customer)
Добавьте вариант этого запроса с постраничной выборкой,
пропустив первую 1000 и отобразив следующие 100 записей.

Сортировка должна быть по номеру квартала, трети года, дате заказа (везде по возрастанию).

Таблицы: Sales.Orders, Sales.OrderLines, Sales.Customers.
*/

Select ord.OrderID as OrderID,
	   Format(ord.OrderDate,'dd.MM.yyyy' ) as ДатаЗаказа,
	   DATENAME(month,ord.OrderDate) as НазваниеМесяца,
	   DATENAME(quarter,ord.OrderDate) as НомерКвартала,
	   case 
			When MONTH(ord.OrderDate) between 1 and 4 	then 1
			When MONTH(ord.OrderDate) between 5 and 8 	then 2
			When MONTH(ord.OrderDate) between 9 and 12	then 3
	   end as ТретьГода,
	   cust.CustomerName as ИмяЗаказчика
		from Sales.Orders ord
		join Sales.Customers cust on ord.CustomerID = cust.CustomerID
		join Sales.OrderLines ordLine on ord.OrderID = ordLine.OrderID
Where (ordLine.UnitPrice > 100 or ordLine.Quantity > 20)
	  and ord.PickingCompletedWhen is not null	
order by DATENAME(quarter,ord.OrderDate), MONTH(ord.OrderDate), ord.OrderDate
--Постраничная выборка
	  offset 1000 rows fetch first 100 rows only

/*
4. Заказы поставщикам (Purchasing.Suppliers),
которые должны быть исполнены (ExpectedDeliveryDate) в январе 2013 года
с доставкой "Air Freight" или "Refrigerated Air Freight" (DeliveryMethodName)
и которые исполнены (IsOrderFinalized).
Вывести:
* способ доставки (DeliveryMethodName)
* дата доставки (ExpectedDeliveryDate)
* имя поставщика
* имя контактного лица принимавшего заказ (ContactPerson)

Таблицы: Purchasing.Suppliers, Purchasing.PurchaseOrders, Application.DeliveryMethods, Application.People.
*/

Select del.DeliveryMethodName	as СпособДоставки,
	   ord.ExpectedDeliveryDate as ДатаДоставки,
	   supp.SupplierName		as ИмяПоставщика,
	   p.FullName				as ИмяКонтактноеЛицо
from Purchasing.Suppliers supp
join Purchasing.PurchaseOrders ord			on supp.SupplierID = ord.SupplierID
join Application.DeliveryMethods del		on del.DeliveryMethodID = ord.DeliveryMethodID
join Application.People p					on p.PersonID = ord.ContactPersonID
Where ord.ExpectedDeliveryDate between '20130101' and '20130131'
	  and  del.DeliveryMethodName in ('Air Freight', 'Refrigerated Air Freight')	
	  and  ord.IsOrderFinalized = 1

/*
5. Десять последних продаж (по дате продажи) с именем клиента и именем сотрудника,
который оформил заказ (SalespersonPerson).
Сделать без подзапросов.
*/

Select top 10 ord.OrderDate		as ДатаЗаказа, 
			 cust.CustomerName	as ИмяКлиента,
			 p.FullName			as ИмяСотрудникаОформившегоЗаказ
from sales.Customers cust
join sales.Orders ord on ord.CustomerID = cust.CustomerID
join Application.People p on p.PersonID = ord.SalespersonPersonID
order by ord.OrderDate DESC

/*
6. Все ид и имена клиентов и их контактные телефоны,
которые покупали товар "Chocolate frogs 250g".
Имя товара смотреть в таблице Warehouse.StockItems.
*/

Select	distinct 
		cust.CustomerID		as ИДКлиента, 
		cust.CustomerName	as ИмяКлиента,
		cust.PhoneNumber	as КонтактныйТелефонКлиента 
from Sales.Customers cust
join Sales.Orders ord			on cust.CustomerID = ord.CustomerID
join Sales.OrderLines ordLin	on ordLin.OrderID = ord.OrderID
join Warehouse.StockItems item	on item.StockItemID = ordLin.StockItemID
Where item.StockItemName = 'Chocolate frogs 250g'

/*
7. Посчитать среднюю цену товара, общую сумму продажи по месяцам
Вывести:
* Год продажи (например, 2015)
* Месяц продажи (например, 4)
* Средняя цена за месяц по всем товарам
* Общая сумма продаж за месяц

Продажи смотреть в таблице Sales.Invoices и связанных таблицах.
*/

Select YEAR(inv.InvoiceDate)				as ГодПродажи,
	   MONTH(inv.InvoiceDate)				as МесяцПродажи,
	   ROUND(AVG(invLine.ExtendedPrice),2)	as СредняяЦенаЗаМесяц,
	   SUM(invLine.ExtendedPrice)			as ОбщаяСуммаЗаМесяц
	from Sales.Invoices inv
	join Sales.InvoiceLines invLine on invLine.InvoiceID = inv.InvoiceID
GROUP BY YEAR(inv.InvoiceDate), MONTH(inv.InvoiceDate)
ORDER BY YEAR(inv.InvoiceDate), MONTH(inv.InvoiceDate)

/*
8. Отобразить все месяцы, где общая сумма продаж превысила 10 000

Вывести:
* Год продажи (например, 2015)
* Месяц продажи (например, 4)
* Общая сумма продаж

Продажи смотреть в таблице Sales.Invoices и связанных таблицах.
*/

Select YEAR(inv.InvoiceDate)		as ГодПродажи,
	   MONTH(inv.InvoiceDate)		as МесяцПродажи,
	   SUM(invLine.ExtendedPrice)	as ОбщаяСуммаЗаМесяц
	from Sales.Invoices inv
	join Sales.InvoiceLines invLine on invLine.InvoiceID = inv.InvoiceID
GROUP BY YEAR(inv.InvoiceDate), MONTH(inv.InvoiceDate)
HAVING SUM(invLine.ExtendedPrice) > 10000
ORDER BY YEAR(inv.InvoiceDate), MONTH(inv.InvoiceDate)

/*
9. Вывести сумму продаж, дату первой продажи
и количество проданного по месяцам, по товарам,
продажи которых менее 50 ед в месяц.
Группировка должна быть по году,  месяцу, товару.

Вывести:
* Год продажи
* Месяц продажи
* Наименование товара
* Сумма продаж
* Дата первой продажи
* Количество проданного

Продажи смотреть в таблице Sales.Invoices и связанных таблицах.
*/

Select YEAR(inv.InvoiceDate)		as ГодПродажи,
	   MONTH(inv.InvoiceDate)		as МесяцПродажи,
	   invLine.Description			as НаименованиеТовара,
	   SUM(invLine.ExtendedPrice)	as СуммаПродажЗаМесяц,
	   MIN(inv.InvoiceDate)			as ДатаПервойПродажи,
	   SUM(invLine.Quantity)		as КоличествоПроданного
	from Sales.Invoices inv
	join Sales.InvoiceLines invLine on invLine.InvoiceID = inv.InvoiceID
GROUP BY YEAR(inv.InvoiceDate), MONTH(inv.InvoiceDate), invLine.Description
ORDER BY YEAR(inv.InvoiceDate), MONTH(inv.InvoiceDate), invLine.Description

-- ---------------------------------------------------------------------------
-- Опционально
-- ---------------------------------------------------------------------------
/*
Написать запросы 8-9 так, чтобы если в каком-то месяце не было продаж,
то этот месяц также отображался бы в результатах, но там были нули.
*/

Select YEAR(inv.InvoiceDate)				as ГодПродажи,
	   MONTH(inv.InvoiceDate)				as МесяцПродажи,
	   isnull(SUM(invLine.ExtendedPrice),0)	as ОбщаяСуммаЗаМесяц
	from Sales.Invoices inv
	left outer join Sales.InvoiceLines invLine on invLine.InvoiceID = inv.InvoiceID
GROUP BY YEAR(inv.InvoiceDate), MONTH(inv.InvoiceDate)
HAVING SUM(invLine.ExtendedPrice) > 10000
ORDER BY YEAR(inv.InvoiceDate), MONTH(inv.InvoiceDate)

Select YEAR(inv.InvoiceDate)					as ГодПродажи,
	   MONTH(inv.InvoiceDate)					as МесяцПродажи,
	   invLine.Description						as НаименованиеТовара,
	   isnull(SUM(invLine.ExtendedPrice),0)		as СуммаПродажЗаМесяц,
	   isnull(MIN(inv.InvoiceDate),'20450101')	as ДатаПервойПродажи, --Если продаж не было, то дата первой продажи 01.01.2045
	   isnull(SUM(invLine.Quantity),0)			as КоличествоПроданного
	from Sales.Invoices inv
	left outer join Sales.InvoiceLines invLine on invLine.InvoiceID = inv.InvoiceID
GROUP BY YEAR(inv.InvoiceDate), MONTH(inv.InvoiceDate), invLine.Description
ORDER BY YEAR(inv.InvoiceDate), MONTH(inv.InvoiceDate), invLine.Description