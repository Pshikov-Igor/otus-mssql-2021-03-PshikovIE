--Создаем БД
USE [master]
GO

CREATE DATABASE [Project_Sbyt]
 CONTAINMENT = NONE
 ON  PRIMARY 
--( NAME = Sbyt, FILENAME = N'I:\Обучение\OTUS\Bases\Sbyt.mdf' , 
( NAME = Sbyt, FILENAME = N'D:\Sbyt.mdf' , 
	SIZE = 8MB , 
	MAXSIZE = UNLIMITED, 
	FILEGROWTH = 30MB )
 LOG ON 
--( NAME = Sbyt_log, FILENAME = N'I:\Обучение\OTUS\Bases\Sbyt_log.ldf' , 
( NAME = Sbyt_log, FILENAME = N'd:\Sbyt_log.ldf' , 
	SIZE = 8MB , 
	MAXSIZE = UNLIMITED , 
	FILEGROWTH = 30MB )
GO

USE [Project_Sbyt]
GO

--Добавим отдельную файловую группу для Журнала операции
ALTER DATABASE [Project_Sbyt] ADD FILEGROUP [Sbyt_Journal]
GO

ALTER DATABASE [Project_Sbyt] ADD FILE 
--( NAME = N'Sbyt_Journal', FILENAME = N'I:\Обучение\OTUS\Bases\Sbyt_Journal.ndf' , 
( NAME = N'Sbyt_Journal', FILENAME = N'D:\Sbyt_Journal.ndf' , 
SIZE = 8MB , FILEGROWTH = 100MB ) TO FILEGROUP [Sbyt_Journal]
GO

--Сделаем нашу таблицу Журнала изменений секционной
CREATE PARTITION FUNCTION [fnJournalOperationsPartition](datetime2) AS RANGE RIGHT FOR VALUES
('20200101','20210101','20220101','20230101','20240101', '20250101',
 '20260101', '20270101', '20280101', '20290101', '20300101', '20310101');																																																									
GO

CREATE PARTITION SCHEME [schmJournalOperationsPartition] AS PARTITION [fnJournalOperationsPartition] 
ALL TO ([Sbyt_Journal])
GO

/*
USE master; 
GO 
IF DB_ID (N'Project_Sbyt') IS NOT NULL 
	DROP DATABASE Project_Sbyt; 
GO 
*/

--Создадим свою схему
Create schema Sbyt;
GO

--Создаем таблицы
CREATE TABLE Sbyt.[Договор] (
	Row_ID int IDENTITY (1,1) NOT NULL,
	Номер nvarchar(100) NOT NULL,
	Плательщик_ИД int NOT NULL,
	Грузополучатель_ИД int NOT NULL,
	Начало_договора date NOT NULL,
	Окончание_договора date NOT NULL DEFAULT '20451231',
	Тип_договора int NOT NULL,
	Категория_ИД int,
	Отрасль_ИД int,
	Бюджет_ИД int,
	Примечание nvarchar(1000),
  CONSTRAINT [PK_ДОГОВОР] PRIMARY KEY CLUSTERED
  (
  [Row_ID] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
CREATE TABLE Sbyt.[Классификаторы] (
	Row_ID int IDENTITY (1,1) NOT NULL,
	Тип int,
	Папки int,
	Папки_Add tinyint NOT NULL,
	Код int,
	Название nvarchar(1000),
	Примечание nvarchar(1000),
  CONSTRAINT [PK_КЛАССИФИКАТОРЫ] PRIMARY KEY CLUSTERED
  (
  [Row_ID] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
CREATE TABLE Sbyt.[Типы_классификатора] (
	Row_ID int IDENTITY (1,1) NOT NULL,
	Папки int,
	Папки_Add tinyint NOT NULL,
	Название nvarchar(500) NOT NULL,
  CONSTRAINT [PK_ТИПЫ_КЛАССИФИКАТОРА] PRIMARY KEY CLUSTERED
  (
  [Row_ID] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
CREATE TABLE Sbyt.[Свойства] (
	Row_ID bigint IDENTITY (1,1) NOT NULL,
	Виды_Параметры int NOT NULL,
	Параметры_Счет bigint,
	Параметры_Договор int,
	Параметры_Организация int,
	ДатНач datetime2 NOT NULL,
	ДатКнц datetime2 NOT NULL DEFAULT '20451231',
	Значение int NOT NULL,
	Примечание nvarchar(1000) NOT NULL,
  CONSTRAINT [PK_СВОЙСТВА] PRIMARY KEY CLUSTERED
  (
  [Row_id] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
CREATE TABLE Sbyt.[Организации] (
	Row_ID int IDENTITY (1,1) NOT NULL,
	ИНН nvarchar(24) NOT NULL,
	КПП nvarchar(20),
	ОГРН nvarchar(30),
	Название nvarchar(500) NOT NULL,
	Наименование nvarchar(1000) NOT NULL,
	Вид_организации tinyint NOT NULL,
	Юридический_адрес nvarchar(1000) NOT NULL,
	Фактический_адрес nvarchar(1000) NOT NULL,
	Телефоны nvarchar(100),
	Емайл nvarchar(250),
	Примечание nvarchar(1000),
  CONSTRAINT [PK_ОРГАНИЗАЦИИ] PRIMARY KEY CLUSTERED
  (
  [Row_id] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
CREATE TABLE Sbyt.[Лицевые_договора] (
	Row_ID bigint IDENTITY (1,1) NOT NULL,
	Договор_ИД int NOT NULL,
	Лицевой_ИД bigint NOT NULL,
	ДатНач datetime2 NOT NULL,
	ДатКнц datetime2 NOT NULL DEFAULT '20451231',
  CONSTRAINT [PK_ЛИЦЕВЫЕ_ДОГОВОРА] PRIMARY KEY CLUSTERED
  (
  [Row_id] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
CREATE TABLE Sbyt.[Лицевые_счета] (
	Row_ID bigint IDENTITY (1,1) NOT NULL,
	Номер int NOT NULL,
	Адрес nvarchar(1000) NOT NULL,
	Примечание nvarchar(1000),
  CONSTRAINT [PK_ЛИЦЕВЫЕ_СЧЕТА] PRIMARY KEY CLUSTERED
  (
  [Row_id] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
CREATE TABLE Sbyt.[Список_объектов] (
	Row_ID bigint IDENTITY (1,1) NOT NULL,
	ДатНач datetime2 NOT NULL,
	ДатКнц datetime2 NOT NULL DEFAULT '20451231',
	Номенклатура_Объекты int NOT NULL,
	Заводской_номер nvarchar(100) NOT NULL,
	Номер_пломбы nvarchar(100) NOT NULL,
	Тарифность int NOT NULL,
	Коэффициент_трансформации int NOT NULL,
	Год_выпуска date NOT NULL,
	Объекты_Счет bigint NOT NULL,
  CONSTRAINT [PK_СПИСОК_ОБЪЕКТОВ] PRIMARY KEY CLUSTERED
  (
  [Row_id] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
CREATE TABLE Sbyt.[Номенклатура] (
	Row_ID int IDENTITY (1,1) NOT NULL,
	Наименование nvarchar(500) NOT NULL,
	Номинальная_мощность decimal(10,2) NOT NULL,
	Разрядность int NOT NULL,
	Дробная_разрядность tinyint NOT NULL,
	Завод_изготовитель nvarchar(500),
  CONSTRAINT [PK_НОМЕНКЛАТУРА] PRIMARY KEY CLUSTERED
  (
  [Row_id] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
CREATE TABLE Sbyt.[Показания_счетчиков] (
	Row_ID bigint IDENTITY (1,1) NOT NULL,
	Объект_Показание bigint NOT NULL,
	Тип_ввода int NOT NULL,
	Дата datetime2 NOT NULL,
	Расчетный_месяц date NOT NULL,
	Показание decimal(19,4) NOT NULL,
	Расход decimal(19,4) NOT NULL,
	Дополнительный_расход decimal(19,4) NOT NULL,
	Итоговый_расход decimal(19,4) NOT NULL,
	Тип tinyint NOT NULL,
  CONSTRAINT [PK_ПОКАЗАНИЯ_СЧЕТЧИКОВ] PRIMARY KEY CLUSTERED
  (
  [Row_id] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
CREATE TABLE Sbyt.[Журнал_изменений] (
	Row_ID bigint IDENTITY (1,1) NOT NULL,
	Дата datetime2 NOT NULL,
	Журнал_Пользователь int,
	Действие nvarchar(2000),
	Журнал_Счет bigint,
	Журнал_Договор int,
	Таблица nvarchar(100),
	Операция nvarchar(100),
	ИмяКомпьютера nvarchar(256)
) ON [schmJournalOperationsPartition](Дата)---в схеме [schmJournalOperationsPartition] по ключу [Дата]
GO

--добавим кластерный индекс
ALTER TABLE Sbyt.[Журнал_изменений] ADD CONSTRAINT PK_ЖУРНАЛ_ИЗМЕНЕНИЙ
PRIMARY KEY CLUSTERED  (Дата, Row_ID)
 ON [schmJournalOperationsPartition](Дата);
 
 GO
CREATE TABLE Sbyt.[Документ] (
	Row_ID bigint IDENTITY (1,1) NOT NULL,
	Папки bigint,
	Папки_Add tinyint NOT NULL,
	Тип_документа int,
	Номер int,
	Плательщик_ИД int,
	Грузополучатель_ИД int,
	Количество decimal(19,4),
	Сумма decimal(19,4),
	СуммаСНДС decimal(19,4),
	Наименование nvarchar(500),
	Документ_Договор int NULL
  CONSTRAINT [PK_ДОКУМЕНТ] PRIMARY KEY CLUSTERED
  (
  [Row_id] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
CREATE TABLE Sbyt.[Строки_документа] (
	Row_ID bigint IDENTITY (1,1) NOT NULL,
	Строки_Документ bigint NOT NULL,
	Услуга nvarchar(500) NOT NULL,
	Количество decimal(19,4) NOT NULL,
	Тариф decimal(19,4) NOT NULL,
	Сумма decimal(19,4) NOT NULL,
	СуммаСНДС decimal(19,4) NOT NULL,
	За_месяц date NOT NULL,
  CONSTRAINT [PK_СТРОКИ_ДОКУМЕНТА] PRIMARY KEY CLUSTERED
  (
  [Row_id] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
CREATE TABLE Sbyt.[Пользователи] (
	Row_ID int IDENTITY (1,1) NOT NULL,
	Логин nvarchar(250) NOT NULL,
	Пароль image,
	Фамилия nvarchar(250) NOT NULL,
	Имя nvarchar(250) NOT NULL,
	Отчество nvarchar(250),
	Отдел nvarchar(500),
  CONSTRAINT [PK_ПОЛЬЗОВАТЕЛИ] PRIMARY KEY CLUSTERED
  (
  [Row_id] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO

--Добавление внешних ключей и ограничений 
ALTER TABLE sbyt.[Договор] WITH CHECK ADD CONSTRAINT [Договор_fk0] FOREIGN KEY ([Плательщик_ИД]) REFERENCES sbyt.[Организации]([Row_id])
ON UPDATE NO ACTION
ON DELETE NO ACTION
GO
ALTER TABLE sbyt.[Договор] CHECK CONSTRAINT [Договор_fk0]
GO
ALTER TABLE sbyt.[Договор] WITH CHECK ADD CONSTRAINT [Договор_fk1] FOREIGN KEY ([Грузополучатель_ИД]) REFERENCES sbyt.[Организации]([Row_id])
ON UPDATE NO ACTION
ON DELETE NO ACTION
GO
ALTER TABLE sbyt.[Договор] CHECK CONSTRAINT [Договор_fk1]
GO
ALTER TABLE sbyt.[Договор] WITH CHECK ADD CONSTRAINT [Договор_fk2] FOREIGN KEY ([Тип_договора]) REFERENCES sbyt.[Классификаторы]([Row_ID])
ON UPDATE NO ACTION
ON DELETE NO ACTION
GO
ALTER TABLE sbyt.[Договор] CHECK CONSTRAINT [Договор_fk2]
GO
ALTER TABLE sbyt.[Договор] WITH CHECK ADD CONSTRAINT [Договор_fk3] FOREIGN KEY ([Категория_ИД]) REFERENCES sbyt.[Классификаторы]([Row_ID])
ON UPDATE NO ACTION
ON DELETE NO ACTION
GO
ALTER TABLE sbyt.[Договор] CHECK CONSTRAINT [Договор_fk3]
GO
ALTER TABLE sbyt.[Договор] WITH CHECK ADD CONSTRAINT [Договор_fk4] FOREIGN KEY ([Отрасль_ИД]) REFERENCES sbyt.[Классификаторы]([Row_ID])
ON UPDATE NO ACTION
ON DELETE NO ACTION
GO
ALTER TABLE sbyt.[Договор] CHECK CONSTRAINT [Договор_fk4]
GO
ALTER TABLE sbyt.[Договор] WITH CHECK ADD CONSTRAINT [Договор_fk5] FOREIGN KEY ([Бюджет_ИД]) REFERENCES sbyt.[Классификаторы]([Row_ID])
ON UPDATE NO ACTION
ON DELETE NO ACTION
GO
ALTER TABLE sbyt.[Договор] CHECK CONSTRAINT [Договор_fk5]
GO

ALTER TABLE sbyt.[Классификаторы] WITH CHECK ADD CONSTRAINT [Классификаторы_fk0] FOREIGN KEY ([Тип]) REFERENCES sbyt.[Типы_классификатора]([Row_ID])
ON UPDATE NO ACTION
ON DELETE NO ACTION
GO
ALTER TABLE sbyt.[Классификаторы] CHECK CONSTRAINT [Классификаторы_fk0]
GO
ALTER TABLE sbyt.[Классификаторы] WITH CHECK ADD CONSTRAINT [Классификаторы_fk1] FOREIGN KEY ([Папки]) REFERENCES sbyt.[Классификаторы]([Row_ID])
ON UPDATE NO ACTION
ON DELETE NO ACTION
GO
ALTER TABLE sbyt.[Классификаторы] CHECK CONSTRAINT [Классификаторы_fk1]
GO

ALTER TABLE sbyt.[Типы_классификатора] WITH CHECK ADD CONSTRAINT [Типы_классификатора_fk0] FOREIGN KEY ([Папки]) REFERENCES sbyt.[Типы_классификатора]([Row_ID])
ON UPDATE NO ACTION
ON DELETE NO ACTION
GO
ALTER TABLE sbyt.[Типы_классификатора] CHECK CONSTRAINT [Типы_классификатора_fk0]
GO

ALTER TABLE sbyt.[Свойства] WITH CHECK ADD CONSTRAINT [Свойства_fk0] FOREIGN KEY ([Виды_Параметры]) REFERENCES sbyt.[Классификаторы]([Row_ID])
ON UPDATE NO ACTION
ON DELETE NO ACTION
GO
ALTER TABLE sbyt.[Свойства] CHECK CONSTRAINT [Свойства_fk0]
GO
ALTER TABLE sbyt.[Свойства] WITH CHECK ADD CONSTRAINT [Свойства_fk1] FOREIGN KEY ([Параметры_Счет]) REFERENCES sbyt.[Лицевые_счета]([Row_id])
ON UPDATE NO ACTION
ON DELETE NO ACTION
GO
ALTER TABLE sbyt.[Свойства] CHECK CONSTRAINT [Свойства_fk1]
GO
ALTER TABLE sbyt.[Свойства] WITH CHECK ADD CONSTRAINT [Свойства_fk2] FOREIGN KEY ([Параметры_Договор]) REFERENCES sbyt.[Договор]([Row_ID])
ON UPDATE NO ACTION
ON DELETE NO ACTION
GO
ALTER TABLE sbyt.[Свойства] CHECK CONSTRAINT [Свойства_fk2]
GO
ALTER TABLE sbyt.[Свойства] WITH CHECK ADD CONSTRAINT [Свойства_fk3] FOREIGN KEY ([Параметры_Организация]) REFERENCES sbyt.[Организации]([Row_id])
ON UPDATE NO ACTION
ON DELETE NO ACTION
GO
ALTER TABLE sbyt.[Свойства] CHECK CONSTRAINT [Свойства_fk3]
GO


ALTER TABLE sbyt.[Лицевые_договора] WITH CHECK ADD CONSTRAINT [Лицевые_договора_fk0] FOREIGN KEY ([Договор_ИД]) REFERENCES sbyt.[Договор]([Row_ID])
ON UPDATE NO ACTION
ON DELETE NO ACTION
GO
ALTER TABLE sbyt.[Лицевые_договора] CHECK CONSTRAINT [Лицевые_договора_fk0]
GO
ALTER TABLE sbyt.[Лицевые_договора] WITH CHECK ADD CONSTRAINT [Лицевые_договора_fk1] FOREIGN KEY ([Лицевой_ИД]) REFERENCES sbyt.[Лицевые_счета]([Row_id])
ON UPDATE NO ACTION
ON DELETE NO ACTION
GO
ALTER TABLE sbyt.[Лицевые_договора] CHECK CONSTRAINT [Лицевые_договора_fk1]
GO


ALTER TABLE sbyt.[Список_объектов] WITH CHECK ADD CONSTRAINT [Список_объектов_fk0] FOREIGN KEY ([Номенклатура_Объекты]) REFERENCES sbyt.[Номенклатура]([Row_id])
ON UPDATE NO ACTION
ON DELETE NO ACTION
GO
ALTER TABLE sbyt.[Список_объектов] CHECK CONSTRAINT [Список_объектов_fk0]
GO
ALTER TABLE sbyt.[Список_объектов] WITH CHECK ADD CONSTRAINT [Список_объектов_fk1] FOREIGN KEY ([Объекты_Счет]) REFERENCES sbyt.[Лицевые_счета]([Row_id])
ON UPDATE NO ACTION
ON DELETE NO ACTION
GO
ALTER TABLE sbyt.[Список_объектов] CHECK CONSTRAINT [Список_объектов_fk1]
GO


ALTER TABLE sbyt.[Показания_счетчиков] WITH CHECK ADD CONSTRAINT [Показания_счетчиков_fk0] FOREIGN KEY ([Объект_Показание]) REFERENCES sbyt.[Список_объектов]([Row_id])
ON UPDATE NO ACTION
ON DELETE NO ACTION
GO
ALTER TABLE sbyt.[Показания_счетчиков] CHECK CONSTRAINT [Показания_счетчиков_fk0]
GO
ALTER TABLE sbyt.[Показания_счетчиков] WITH CHECK ADD CONSTRAINT [Показания_счетчиков_fk1] FOREIGN KEY ([Тип_ввода]) REFERENCES sbyt.[Классификаторы]([Row_ID])
ON UPDATE NO ACTION
ON DELETE NO ACTION
GO
ALTER TABLE sbyt.[Показания_счетчиков] CHECK CONSTRAINT [Показания_счетчиков_fk1]
GO

/*
ALTER TABLE sbyt.[Журнал_изменений] WITH CHECK ADD CONSTRAINT [Журнал_изменений_fk0] FOREIGN KEY ([Журнал_Счет]) REFERENCES sbyt.[Лицевые_счета]([Row_id])
ON UPDATE NO ACTION
ON DELETE NO ACTION
GO
ALTER TABLE sbyt.[Журнал_изменений] CHECK CONSTRAINT [Журнал_изменений_fk0]
GO

ALTER TABLE sbyt.[Журнал_изменений] WITH CHECK ADD CONSTRAINT [Журнал_изменений_fk1] FOREIGN KEY ([Журнал_Договор]) REFERENCES sbyt.[Договор]([Row_ID])
ON UPDATE NO ACTION
ON DELETE NO ACTION
GO
ALTER TABLE sbyt.[Журнал_изменений] CHECK CONSTRAINT [Журнал_изменений_fk1]
GO

ALTER TABLE sbyt.[Журнал_изменений] WITH CHECK ADD CONSTRAINT [Журнал_изменений_fk2] FOREIGN KEY ([Журнал_Пользователь]) REFERENCES sbyt.[Пользователи]([Row_id])
ON UPDATE NO ACTION
ON DELETE NO ACTION
GO
ALTER TABLE sbyt.[Журнал_изменений] CHECK CONSTRAINT [Журнал_изменений_fk2]
GO
*/

ALTER TABLE sbyt.[Документ] WITH CHECK ADD CONSTRAINT [Документ_fk0] FOREIGN KEY ([Папки]) REFERENCES sbyt.[Документ]([Row_id])
ON UPDATE NO ACTION
ON DELETE NO ACTION
GO
ALTER TABLE sbyt.[Документ] CHECK CONSTRAINT [Документ_fk0]
GO
ALTER TABLE sbyt.[Документ] WITH CHECK ADD CONSTRAINT [Документ_fk1] FOREIGN KEY ([Тип_документа]) REFERENCES sbyt.[Классификаторы]([Row_ID])
ON UPDATE NO ACTION
ON DELETE NO ACTION
GO
ALTER TABLE sbyt.[Документ] CHECK CONSTRAINT [Документ_fk1]
GO
ALTER TABLE sbyt.[Документ] WITH CHECK ADD CONSTRAINT [Документ_fk2] FOREIGN KEY ([Плательщик_ИД]) REFERENCES sbyt.[Организации]([Row_id])
ON UPDATE NO ACTION
ON DELETE NO ACTION
GO
ALTER TABLE sbyt.[Документ] CHECK CONSTRAINT [Документ_fk2]
GO
ALTER TABLE sbyt.[Документ] WITH CHECK ADD CONSTRAINT [Документ_fk3] FOREIGN KEY ([Грузополучатель_ИД]) REFERENCES sbyt.[Организации]([Row_id])
ON UPDATE NO ACTION
ON DELETE NO ACTION
GO
ALTER TABLE sbyt.[Документ] CHECK CONSTRAINT [Документ_fk3]
GO
ALTER TABLE sbyt.[Документ] WITH CHECK ADD CONSTRAINT [Документ_fk4] FOREIGN KEY ([Документ_Договор]) REFERENCES sbyt.[Договор]([Row_ID])
ON UPDATE CASCADE
ON DELETE NO ACTION
GO
ALTER TABLE sbyt.[Документ] CHECK CONSTRAINT [Документ_fk4]
GO

ALTER TABLE sbyt.[Строки_документа] WITH CHECK ADD CONSTRAINT [Строки_документа_fk0] FOREIGN KEY ([Строки_Документ]) REFERENCES sbyt.[Документ]([Row_id])
ON UPDATE NO ACTION
ON DELETE NO ACTION
GO
ALTER TABLE sbyt.[Строки_документа] CHECK CONSTRAINT [Строки_документа_fk0]
GO

--Добавление индексов 
--1. Добавление индексов (некластеризованных) на FK (FOREIGN KEY)
CREATE NONCLUSTERED INDEX ind_Договор_Плательщик			ON sbyt.[Договор] (Плательщик_ИД);
CREATE NONCLUSTERED INDEX ind_Договор_Грузополучатель		ON sbyt.[Договор] (Грузополучатель_ИД);
CREATE NONCLUSTERED INDEX ind_Договор_Тип					ON sbyt.[Договор] (Тип_договора);
CREATE NONCLUSTERED INDEX ind_Договор_Категория				ON sbyt.[Договор] (Категория_ИД);
CREATE NONCLUSTERED INDEX ind_Договор_Отрасль				ON sbyt.[Договор] (Отрасль_ИД);
CREATE NONCLUSTERED INDEX ind_Договор_Бюджет				ON sbyt.[Договор] (Бюджет_ИД);

CREATE NONCLUSTERED INDEX ind_Классификаторы_Тип			ON sbyt.Классификаторы (Тип);

CREATE NONCLUSTERED INDEX ind_Свойства_ВидыПараметры		ON sbyt.Свойства (Виды_Параметры);
CREATE NONCLUSTERED INDEX ind_Свойства_ПараметрыСчет		ON sbyt.Свойства (Параметры_Счет);
CREATE NONCLUSTERED INDEX ind_Свойства_ПараметрыДоговор		ON sbyt.Свойства (Параметры_Договор);
CREATE NONCLUSTERED INDEX ind_Свойства_ПараметрыОрганизация	ON sbyt.Свойства (Параметры_Организация);

CREATE NONCLUSTERED INDEX ind_ЛицевыеДоговора_Договор 		ON sbyt.Лицевые_договора (Договор_ИД);
CREATE NONCLUSTERED INDEX ind_ЛицевыеДоговора_Лицевой 		ON sbyt.Лицевые_договора (Лицевой_ИД);

CREATE NONCLUSTERED INDEX ind_СписокОбъектов_Номенклатура	ON sbyt.Список_объектов (Номенклатура_Объекты);
CREATE NONCLUSTERED INDEX ind_СписокОбъектов_Счет			ON sbyt.Список_объектов (Объекты_Счет);

CREATE NONCLUSTERED INDEX ind_ПоказанияСчетчиков_Объект		ON sbyt.Показания_счетчиков (Объект_Показание);
CREATE NONCLUSTERED INDEX ind_ПоказанияСчетчиков_Тип		ON sbyt.Показания_счетчиков (Тип_ввода);

CREATE NONCLUSTERED INDEX ind_Журнал_Счет					ON sbyt.Журнал_изменений (Журнал_Счет);
CREATE NONCLUSTERED INDEX ind_Журнал_Договор				ON sbyt.Журнал_изменений (Журнал_Договор);
CREATE NONCLUSTERED INDEX ind_Журнал_Пользователь			ON sbyt.Журнал_изменений (Журнал_Пользователь);

CREATE NONCLUSTERED INDEX ind_Документ_Тип					ON sbyt.Документ (Тип_документа);
CREATE NONCLUSTERED INDEX ind_Документ_Плательщик			ON sbyt.Документ (Плательщик_ИД);
CREATE NONCLUSTERED INDEX ind_Документ_Грузополучатель		ON sbyt.Документ (Грузополучатель_ИД);
CREATE NONCLUSTERED INDEX ind_Документ_Договор				ON sbyt.Документ (Документ_Договор);

CREATE NONCLUSTERED INDEX ind_СтрокиДокумента_Документ	ON sbyt.Строки_документа (Строки_Документ);
GO

--2. Добавление индексов на поле ПАПКИ таблиц, для объединения таблиц самих с собой при отображении древовидной структуры на форме приложения.

CREATE NONCLUSTERED INDEX ind_Классификаторы_Папки			ON sbyt.Классификаторы (Папки);
CREATE NONCLUSTERED INDEX ind_Типы_классификатора_Папки 	ON sbyt.[Типы_классификатора] (Папки);
CREATE NONCLUSTERED INDEX ind_Документ_Папки				ON sbyt.Документ (Папки);
GO

--3. Добавление индексов на таблицу Sbyt.[Организации] для быстрого поиска организации по ИНН или ОГРН

CREATE NONCLUSTERED INDEX ind_Организации_ИНН ON Sbyt.[Организации] (ИНН);
CREATE NONCLUSTERED INDEX ind_Организации_ОГРН ON Sbyt.[Организации] (ОГРН);
GO

--4. Добавление индекса на таблицу Sbyt.Договор для быстрого поиска номеру договора
CREATE NONCLUSTERED INDEX ind_Договор_Номер ON Sbyt.Договор (Номер);
GO

--5. Добавление индекса на таблицу Sbyt.Лицевые_счета для быстрого поиска лицевого счета по его номеру
CREATE NONCLUSTERED INDEX ind_Лицевые_счета_Номер ON Sbyt.Лицевые_счета (Номер);
GO

--6. Добавление индекса на таблицу Sbyt.Список_объектов для быстрого поиска прибора учета по его заводскому номеру
CREATE NONCLUSTERED INDEX ind_Список_объектов_ЗаводскойНомер ON Sbyt.Список_объектов (Заводской_Номер);
GO

--7. Добавление индекса на таблицу Sbyt.Документ для быстрого поиска документа по его номеру (думаю пригодится для бухгалтерии)
CREATE NONCLUSTERED INDEX ind_Документ_Номер ON Sbyt.Документ (Номер);
GO

--8. Так же добавим составные индексы для выборки данных в зависимости от периода

CREATE INDEX ind_Свойства_ДатНачДатКнц			ON Sbyt.Свойства(ДатНач, ДатКнц);
CREATE INDEX ind_Список_объектов_ДатНачДатКнц	ON Sbyt.Список_объектов(ДатНач, ДатКнц);
CREATE INDEX ind_Лицевые_договора_ДатНачДатКнц	ON Sbyt.Лицевые_договора(ДатНач, ДатКнц);
GO

