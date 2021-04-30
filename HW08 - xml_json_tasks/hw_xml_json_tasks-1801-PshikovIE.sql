/*
Домашнее задание по курсу MS SQL Server Developer в OTUS.

Занятие "08 - Выборки из XML и JSON полей".

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
Примечания к заданиям 1, 2:
* Если с выгрузкой в файл будут проблемы, то можно сделать просто SELECT c результатом в виде XML. 
* Если у вас в проекте предусмотрен экспорт/импорт в XML, то можете взять свой XML и свои таблицы.
* Если с этим XML вам будет скучно, то можете взять любые открытые данные и импортировать их в таблицы (например, с https://data.gov.ru).
* Пример экспорта/импорта в файл https://docs.microsoft.com/en-us/sql/relational-databases/import-export/examples-of-bulk-import-and-export-of-xml-documents-sql-server
*/


/*
1. В личном кабинете есть файл StockItems.xml.
Это данные из таблицы Warehouse.StockItems.
Преобразовать эти данные в плоскую таблицу с полями, аналогичными Warehouse.StockItems.
Поля: StockItemName, SupplierID, UnitPackageID, OuterPackageID, QuantityPerOuter, TypicalWeightPerUnit, LeadTimeDays, IsChillerStock, TaxRate, UnitPrice 

Опционально - если вы знакомы с insert, update, merge, то загрузить эти данные в таблицу Warehouse.StockItems.
Существующие записи в таблице обновить, отсутствующие добавить (сопоставлять записи по полю StockItemName). 
*/

DECLARE @xmlDoc  xml

SELECT @xmlDoc = BulkColumn
FROM OPENROWSET (BULK 'D:\StockItems.xml', SINGLE_CLOB) as data 

if Object_Id('tempdb..#StockItemsTemp') is not null drop table #StockItemsTemp	

CREATE TABLE #StockItemsTemp(
								StockItemName nvarchar(100),
								SupplierID int,
								UnitPackageID int,
								OuterPackageID nvarchar(100),
								QuantityPerOuter int,
								TypicalWeightPerUnit decimal(18,3),
								LeadTimeDays int,
								IsChillerStock bit,
								TaxRate decimal(18,3),
								UnitPrice decimal(18,2)
							)

DECLARE @Handle int
EXEC sp_xml_preparedocument @Handle OUTPUT, @xmlDoc

INSERT INTO #StockItemsTemp
SELECT *
FROM OPENXML(@Handle, N'/StockItems/Item')
WITH ( 
	[StockItemName] nvarchar(100)		 '@Name',
	[SupplierID] int					 'SupplierID',
	[UnitPackageID]	int					 'Package/UnitPackageID',
	[OuterPackageID] nvarchar(100)		 'Package/OuterPackageID',	
	[QuantityPerOuter] int				 'Package/QuantityPerOuter',
	[TypicalWeightPerUnit] decimal(18,3) 'Package/TypicalWeightPerUnit',	
	[LeadTimeDays] int					 'LeadTimeDays',
	[IsChillerStock] bit				 'IsChillerStock',
	[TaxRate] decimal(18,3)				 'TaxRate',
	[UnitPrice] decimal(18,2)			 'UnitPrice')	

--Выведем результат
Select * from #StockItemsTemp

-- Смержим данные =)
MERGE INTO Warehouse.StockItems AS Target  
USING (
	   Select [StockItemName], [SupplierID], [UnitPackageID], [OuterPackageID], [QuantityPerOuter], [TypicalWeightPerUnit], [LeadTimeDays], [IsChillerStock], [TaxRate], [UnitPrice] 
	   from #StockItemsTemp 
	  ) AS Source
	  on Target.StockItemName = Source.StockItemName COLLATE Cyrillic_General_CI_AS
WHEN MATCHED THEN  
UPDATE SET Target.[SupplierID]				= Source.[SupplierID] ,
			Target.[UnitPackageID]			= Source.[UnitPackageID] ,
			Target.[OuterPackageID]			= Source.[OuterPackageID] ,
			Target.[QuantityPerOuter]		= Source.[QuantityPerOuter] ,
			Target.[TypicalWeightPerUnit]	= Source.[TypicalWeightPerUnit] ,
			Target.[LeadTimeDays]			= Source.[LeadTimeDays] ,
			Target.[IsChillerStock]			= Source.[IsChillerStock] ,
			Target.[TaxRate]				= Source.[TaxRate] ,
			Target.[UnitPrice]				= Source.[UnitPrice] 
WHEN NOT MATCHED BY TARGET THEN  
INSERT ([StockItemName], [SupplierID], [UnitPackageID], [OuterPackageID], [QuantityPerOuter], [TypicalWeightPerUnit], [LeadTimeDays], [IsChillerStock], [TaxRate], [UnitPrice], [LastEditedBy]) 
VALUES ([StockItemName], [SupplierID], [UnitPackageID], [OuterPackageID], [QuantityPerOuter], [TypicalWeightPerUnit], [LeadTimeDays], [IsChillerStock], [TaxRate], [UnitPrice], 1); 

EXEC sp_xml_removedocument @Handle

/*
2. Выгрузить данные из таблицы StockItems в такой же xml-файл, как StockItems.xml
*/

SELECT 
    [StockItemName]			AS [@Name],
    [SupplierID]			AS [SupplierID],
    [UnitPackageID]			AS [Package/UnitPackageID],
    [OuterPackageID]		AS [Package/OuterPackageID],
    [QuantityPerOuter]		AS [Package/QuantityPerOuter],
    [TypicalWeightPerUnit]	AS [Package/TypicalWeightPerUnit],
    [LeadTimeDays]			AS [LeadTimeDays],
	[IsChillerStock]		AS [IsChillerStock],
	[TaxRate]				AS [TaxRate],
	[UnitPrice]				AS [UnitPrice]
FROM Warehouse.StockItems
FOR XML PATH('Item'), ROOT('StockItems')

/*
3. В таблице Warehouse.StockItems в колонке CustomFields есть данные в JSON.
Написать SELECT для вывода:
- StockItemID
- StockItemName
- CountryOfManufacture (из CustomFields)
- FirstTag (из поля CustomFields, первое значение из массива Tags)
*/

SELECT
    StockItemID,
	StockItemName,
    JSON_VALUE(CustomFields, '$.CountryOfManufacture') AS CountryOfManufacture,
	isnull(JSON_VALUE(CustomFields, '$.Tags[0]'),'')   AS FirstTag
FROM Warehouse.StockItems

/*
4. Найти в StockItems строки, где есть тэг "Vintage".
Вывести: 
- StockItemID
- StockItemName
- (опционально) все теги (из CustomFields) через запятую в одном поле

Тэги искать в поле CustomFields, а не в Tags.
Запрос написать через функции работы с JSON.
Для поиска использовать равенство, использовать LIKE запрещено.

Должно быть в таком виде:
... where ... = 'Vintage'

Так принято не будет:
... where ... Tags like '%Vintage%'
... where ... CustomFields like '%Vintage%' 
*/

SELECT
    StockItemID,
	StockItemName,
    JSON_QUERY(CustomFields, '$.Tags') AS Tags,
	custF.[key],
	custF.value as FindTags
FROM Warehouse.StockItems
CROSS APPLY OPENJSON(CustomFields, '$.Tags') custF
WHERE custF.value = 'Vintage'