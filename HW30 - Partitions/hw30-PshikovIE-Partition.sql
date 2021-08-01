use WideWorldImporters;

--создаем наши секционированные таблицы и поместим их в отдельную файловую группу
DROP TABLE IF EXISTS Sales.OrdersArchive;
DROP TABLE IF EXISTS Sales.OrderLinesArchive;
DROP PARTITION SCHEME [schmOrdersYearPartition];
DROP PARTITION FUNCTION [fnOrdersYearPartition];

ALTER DATABASE [WideWorldImporters] ADD FILEGROUP [OrdersYearData]
GO

ALTER DATABASE [WideWorldImporters] ADD FILE 
( NAME = N'OrdersYearData', FILENAME = N'D:\OrdersYearData.ndf' , 
SIZE = 65536KB , FILEGROWTH = 65536KB ) TO FILEGROUP [OrdersYearData]
GO

CREATE PARTITION FUNCTION [fnOrdersYearPartition](DATE) AS RANGE RIGHT FOR VALUES
('20120101','20130101','20140101','20150101','20160101', '20170101',
 '20180101', '20190101', '20200101', '20210101', '20220101', '20230101');																																																									
GO

CREATE PARTITION SCHEME [schmOrdersYearPartition] AS PARTITION [fnOrdersYearPartition] 
ALL TO ([OrdersYearData])
GO

--Первая таблица
CREATE TABLE [Sales].[OrdersArchive](
	[OrderID] [int] NOT NULL,
	[CustomerID] [int] NOT NULL,
	[SalespersonPersonID] [int] NOT NULL,
	[PickedByPersonID] [int] NULL,
	[ContactPersonID] [int] NOT NULL,
	[BackorderOrderID] [int] NULL,
	[OrderDate] [date] NOT NULL,
	[ExpectedDeliveryDate] [date] NOT NULL,
	[CustomerPurchaseOrderNumber] [nvarchar](20) NULL,
	[IsUndersupplyBackordered] [bit] NOT NULL,
	[Comments] [nvarchar](max) NULL,
	[DeliveryInstructions] [nvarchar](max) NULL,
	[InternalComments] [nvarchar](max) NULL,
	[PickingCompletedWhen] [datetime2](7) NULL,
	[LastEditedBy] [int] NOT NULL,
	[LastEditedWhen] [datetime2](7) NOT NULL,
) ON [schmOrdersYearPartition]([OrderDate])---в схеме [schmOrdersYearPartition] по ключу [OrderDate]
GO

--добавим кластерный индекс
ALTER TABLE [Sales].[OrdersArchive] ADD CONSTRAINT PK_Sales_OrdersArchive
PRIMARY KEY CLUSTERED  (OrderDate, OrderID)
 ON [schmOrdersYearPartition]([OrderDate]);

--Вторая таблица
CREATE TABLE Sales.OrderLinesArchive(
	[OrderLineID] [int] NOT NULL,
	[OrderID] [int] NOT NULL,
	[OrderDate] [date] NOT NULL,
	[StockItemID] [int] NOT NULL,
	[Description] [nvarchar](100) NOT NULL,
	[PackageTypeID] [int] NOT NULL,
	[Quantity] [int] NOT NULL,
	[UnitPrice] [decimal](18, 2) NULL,
	[TaxRate] [decimal](18, 3) NOT NULL,
	[PickedQuantity] [int] NOT NULL,
	[PickingCompletedWhen] [datetime2](7) NULL,
	[LastEditedBy] [int] NOT NULL,
	[LastEditedWhen] [datetime2](7) NOT NULL,
) ON [schmOrdersYearPartition]([OrderDate])---в схеме [schmOrdersYearPartition] по ключу [OrderDate]
GO

--добавим кластерный индекс
ALTER TABLE [Sales].OrderLinesArchive ADD CONSTRAINT PK_Sales_OrdersLinesArchive
PRIMARY KEY CLUSTERED  (OrderDate, OrderLineID)
 ON [schmOrdersYearPartition]([OrderDate]);


 --Таблицы созданы
 --смотрим какие таблицы у нас партиционированы
select distinct t.name
from sys.partitions p
inner join sys.tables t
	on p.object_id = t.object_id
where p.partition_number <> 1

--------------------------------------
--Занесем информацию в наши таблицы --
--------------------------------------
INSERT INTO Sales.OrdersArchive
SELECT * FROM Sales.Orders;

INSERT INTO Sales.OrderLinesArchive 
SELECT L.OrderLineID,L.OrderID,O.OrderDate,L.StockItemID,L.[Description],L.PackageTypeID,L.Quantity,L.UnitPrice,L.TaxRate,L.PickedQuantity,L.PickingCompletedWhen,L.LastEditedBy,L.LastEditedWhen	
FROM [WideWorldImporters].Sales.Orders AS O	
JOIN [WideWorldImporters].Sales.OrderLines AS L ON O.OrderID = L.OrderID;

-- Вспомнили bcp =)
--exec master..xp_cmdshell 'bcp "[WideWorldImporters].Sales.Orders" out "d:\Orders.txt" -T -w -t "@eu&$" -S DESKTOP-LKQJQDV'
--exec master..xp_cmdshell 'bcp "SELECT L.OrderLineID,L.OrderID,O.OrderDate,L.StockItemID,L.[Description],L.PackageTypeID,L.Quantity,L.UnitPrice,L.TaxRate,L.PickedQuantity,L.PickingCompletedWhen,L.LastEditedBy,L.LastEditedWhen	FROM [WideWorldImporters].Sales.Orders AS O	JOIN [WideWorldImporters].Sales.OrderLines AS L ON O.OrderID = L.OrderID" queryout "d:\OrderLines.txt" -T -w -t "@eu&$" -S DESKTOP-LKQJQDV'
--


--Аналитика
SELECT $PARTITION.fnOrdersYearPartition(OrderDate) AS Partition, COUNT(*) AS [COUNT], MIN(OrderDate) as MinDate ,MAX(OrderDate) as MaxDate
FROM Sales.OrdersArchive
GROUP BY $PARTITION.fnOrdersYearPartition(OrderDate) 
ORDER BY Partition;  

--Посмотрим что у нас по планам
SET STATISTICS IO, TIME ON
SELECT *
FROM Sales.OrderLinesArchive L
JOIN Sales.OrdersArchive O on O.OrderID = L.OrderID 
							  and O.OrderDate = L.OrderDate
WHERE O.OrderDate between '20160101' and '20161231'

SELECT *
FROM Sales.OrderLines L
INNER JOIN Sales.Orders O
           on O.OrderID = L.OrderID  
WHERE O.OrderDate between '20160101' and '20161231'
SET STATISTICS IO, TIME OFF

/*
   Результаты практически идентичны, но всеравно в моем случае секционирование немного выигрывает, на больших объемах разница должна увеличится
   Время ЦП = 94 мс, затраченное время = 499 мс.
   Время ЦП = 109 мс, затраченное время = 503 мс.
*/