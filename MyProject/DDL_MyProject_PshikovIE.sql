--Создаем БД

CREATE DATABASE [Project_Sbyt]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = Sbyt, FILENAME = N'I:\Обучение\OTUS\Bases\Sbyt.mdf' , 
	SIZE = 8MB , 
	MAXSIZE = UNLIMITED, 
	FILEGROWTH = 30MB )
 LOG ON 
( NAME = Sbyt_log, FILENAME = N'I:\Обучение\OTUS\Bases\Sbyt_log.ldf' , 
	SIZE = 8MB , 
	MAXSIZE = UNLIMITED , 
	FILEGROWTH = 30MB )
GO

/*
USE master; 
GO 
IF DB_ID (N'Project_Sbyt') IS NOT NULL 
	DROP DATABASE Project_Sbyt; 
GO 
*/

use Project_Sbyt;
GO


--Создадим свою схему
Create schema Sbyt;
GO

--Создаем таблицы
CREATE TABLE Sbyt.[Договор] (
	Row_ID int IDENTITY (1,1) NOT NULL,
	Номер varchar(100) NOT NULL,
	Плательщик int NOT NULL,
	Грузополучатель int NOT NULL,
	Начало_договора datetime2 NOT NULL,
	Окончание_договора datetime2 NOT NULL DEFAULT '20451231',
	Тип_договора int NOT NULL,
	Категория int,
	Отрасль int,
	Бюджет int,
	Примечение varchar(255),
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
	Название varchar(255),
	Примечание varchar(255),
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
	Название varchar(255) NOT NULL,
  CONSTRAINT [PK_ТИПЫ_КЛАССИФИКАТОРА] PRIMARY KEY CLUSTERED
  (
  [Row_ID] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
CREATE TABLE Sbyt.[Свойства] (
	Row_ID int IDENTITY (1,1) NOT NULL,
	Виды_Параметры int NOT NULL,
	Параметры_Счет int,
	Параметры_Договор int,
	Параметры_Организация int,
	ДатНач datetime2 NOT NULL,
	ДатКнц datetime2 NOT NULL DEFAULT '20451231',
	Значение int NOT NULL,
	Примечание varchar(255) NOT NULL,
  CONSTRAINT [PK_СВОЙСТВА] PRIMARY KEY CLUSTERED
  (
  [Row_id] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
CREATE TABLE Sbyt.[Организации] (
	Row_ID int IDENTITY (1,1) NOT NULL,
	ИНН varchar(12) NOT NULL,
	КПП varchar(10),
	ОРГН varchar(100),
	Название varchar(255) NOT NULL,
	Наименование varchar(255) NOT NULL,
	Вид_организации tinyint NOT NULL,
	Юридический_адрес varchar(255) NOT NULL,
	Фактический_адрес varchar(255) NOT NULL,
	Телефоны varchar(100),
	Емайл varchar(100),
	Примечание varchar(255),
  CONSTRAINT [PK_ОРГАНИЗАЦИИ] PRIMARY KEY CLUSTERED
  (
  [Row_id] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
CREATE TABLE Sbyt.[Лицевые_договора] (
	Row_ID int IDENTITY (1,1) NOT NULL,
	Договор int NOT NULL,
	Лицевой int NOT NULL,
	ДатНач datetime2 NOT NULL,
	ДатКнц datetime2 NOT NULL DEFAULT '20451231',
  CONSTRAINT [PK_ЛИЦЕВЫЕ_ДОГОВОРА] PRIMARY KEY CLUSTERED
  (
  [Row_id] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
CREATE TABLE Sbyt.[Лицевые_счета] (
	Row_ID int IDENTITY (1,1) NOT NULL,
	Номер int NOT NULL,
	Адрес varchar(255) NOT NULL,
	Примечание varchar(255),
  CONSTRAINT [PK_ЛИЦЕВЫЕ_СЧЕТА] PRIMARY KEY CLUSTERED
  (
  [Row_id] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
CREATE TABLE Sbyt.[Список_объектов] (
	Row_ID int IDENTITY (1,1) NOT NULL,
	ДатНач datetime2 NOT NULL,
	ДатКнц datetime2 NOT NULL DEFAULT '20451231',
	Номенклатура_Объекты int NOT NULL,
	Заводской_номер varchar(100) NOT NULL,
	Номер_пломбы varchar(100) NOT NULL,
	Тарифность int NOT NULL,
	Коэффициент_трансформации int NOT NULL,
	Год_выпуска datetime2 NOT NULL,
	Объекты_Счет int NOT NULL,
  CONSTRAINT [PK_СПИСОК_ОБЪЕКТОВ] PRIMARY KEY CLUSTERED
  (
  [Row_id] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
CREATE TABLE Sbyt.[Номенклатура] (
	Row_ID int IDENTITY (1,1) NOT NULL,
	Наименование varchar(255) NOT NULL,
	Номинальная_мощность float NOT NULL,
	Разрядность int NOT NULL,
	Дробная_разрядность tinyint NOT NULL,
	Завод_изготовитель varchar(255),
  CONSTRAINT [PK_НОМЕНКЛАТУРА] PRIMARY KEY CLUSTERED
  (
  [Row_id] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
CREATE TABLE Sbyt.[Показания_счетчиков] (
	Row_ID int IDENTITY (1,1) NOT NULL,
	Объект_Показание int NOT NULL,
	Тип_ввода int NOT NULL,
	Дата datetime2 NOT NULL,
	Расчетный_месяц datetime2 NOT NULL,
	Показание float NOT NULL,
	Расход float NOT NULL,
	Дополнительный_расход float NOT NULL,
	Итоговый_расход float NOT NULL,
	Тип tinyint NOT NULL,
  CONSTRAINT [PK_ПОКАЗАНИЯ_СЧЕТЧИКОВ] PRIMARY KEY CLUSTERED
  (
  [Row_id] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
CREATE TABLE Sbyt.[Журнал_изменений] (
	Row_ID int IDENTITY (1,1) NOT NULL,
	Дата datetime2 NOT NULL,
	Журнал_Пользователь int NOT NULL,
	Действие varchar(255) NOT NULL,
	Журнал_Счет int,
	Журнал_Договор int,
  CONSTRAINT [PK_ЖУРНАЛ_ИЗМЕНЕНИЙ] PRIMARY KEY CLUSTERED
  (
  [Row_Id] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
CREATE TABLE Sbyt.[Документ] (
	Row_ID int IDENTITY (1,1) NOT NULL,
	Папки int,
	Папки_Add tinyint NOT NULL DEFAULT '-1',
	Тип_документа int,
	Номер int,
	Плательщик int,
	Грузополучатель int,
	Количество float,
	Сумма float,
	СуммаСНДС float,
	Наименование varchar(255),
  CONSTRAINT [PK_ДОКУМЕНТ] PRIMARY KEY CLUSTERED
  (
  [Row_id] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
CREATE TABLE Sbyt.[Строки_документа] (
	Row_ID int IDENTITY (1,1) NOT NULL,
	Строки_Документ int NOT NULL,
	Услуга varchar(255) NOT NULL,
	Количество float NOT NULL,
	Тариф float NOT NULL,
	Сумма float NOT NULL,
	СуммаСНДС float NOT NULL,
	За_месяц datetime2 NOT NULL,
  CONSTRAINT [PK_СТРОКИ_ДОКУМЕНТА] PRIMARY KEY CLUSTERED
  (
  [Row_id] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
CREATE TABLE Sbyt.[Пользователи] (
	Row_ID int IDENTITY (1,1) NOT NULL,
	Логин varchar(100) NOT NULL,
	Пароль image,
	Фамилия varchar(100) NOT NULL,
	Имя varchar(100) NOT NULL,
	Отчество varchar(100),
	Отдел varchar(100),
  CONSTRAINT [PK_ПОЛЬЗОВАТЕЛИ] PRIMARY KEY CLUSTERED
  (
  [Row_id] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO


--Добавление внешних ключей и ограничений 
ALTER TABLE sbyt.[Договор] WITH CHECK ADD CONSTRAINT [Договор_fk0] FOREIGN KEY ([Плательщик]) REFERENCES sbyt.[Организации]([Row_id])
ON UPDATE NO ACTION
ON DELETE NO ACTION
GO
ALTER TABLE sbyt.[Договор] CHECK CONSTRAINT [Договор_fk0]
GO
ALTER TABLE sbyt.[Договор] WITH CHECK ADD CONSTRAINT [Договор_fk1] FOREIGN KEY ([Грузополучатель]) REFERENCES sbyt.[Организации]([Row_id])
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
ALTER TABLE sbyt.[Договор] WITH CHECK ADD CONSTRAINT [Договор_fk3] FOREIGN KEY ([Категория]) REFERENCES sbyt.[Классификаторы]([Row_ID])
ON UPDATE NO ACTION
ON DELETE NO ACTION
GO
ALTER TABLE sbyt.[Договор] CHECK CONSTRAINT [Договор_fk3]
GO
ALTER TABLE sbyt.[Договор] WITH CHECK ADD CONSTRAINT [Договор_fk4] FOREIGN KEY ([Отрасль]) REFERENCES sbyt.[Классификаторы]([Row_ID])
ON UPDATE NO ACTION
ON DELETE NO ACTION
GO
ALTER TABLE sbyt.[Договор] CHECK CONSTRAINT [Договор_fk4]
GO
ALTER TABLE sbyt.[Договор] WITH CHECK ADD CONSTRAINT [Договор_fk5] FOREIGN KEY ([Бюджет]) REFERENCES sbyt.[Классификаторы]([Row_ID])
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


ALTER TABLE sbyt.[Лицевые_договора] WITH CHECK ADD CONSTRAINT [Лицевые_договора_fk0] FOREIGN KEY ([Договор]) REFERENCES sbyt.[Договор]([Row_ID])
ON UPDATE NO ACTION
ON DELETE NO ACTION
GO
ALTER TABLE sbyt.[Лицевые_договора] CHECK CONSTRAINT [Лицевые_договора_fk0]
GO
ALTER TABLE sbyt.[Лицевые_договора] WITH CHECK ADD CONSTRAINT [Лицевые_договора_fk1] FOREIGN KEY ([Лицевой]) REFERENCES sbyt.[Лицевые_счета]([Row_id])
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

ALTER TABLE sbyt.[Журнал_изменений] WITH CHECK ADD CONSTRAINT [Журнал_изменений_fk0] FOREIGN KEY ([Журнал_Пользователь]) REFERENCES sbyt.[Пользователи]([Row_id])
ON UPDATE NO ACTION
ON DELETE NO ACTION
GO
ALTER TABLE sbyt.[Журнал_изменений] CHECK CONSTRAINT [Журнал_изменений_fk0]
GO
ALTER TABLE sbyt.[Журнал_изменений] WITH CHECK ADD CONSTRAINT [Журнал_изменений_fk1] FOREIGN KEY ([Журнал_Счет]) REFERENCES sbyt.[Лицевые_счета]([Row_id])
ON UPDATE NO ACTION
ON DELETE NO ACTION
GO
ALTER TABLE sbyt.[Журнал_изменений] CHECK CONSTRAINT [Журнал_изменений_fk1]
GO
ALTER TABLE sbyt.[Журнал_изменений] WITH CHECK ADD CONSTRAINT [Журнал_изменений_fk2] FOREIGN KEY ([Журнал_Договор]) REFERENCES sbyt.[Договор]([Row_ID])
ON UPDATE NO ACTION
ON DELETE NO ACTION
GO
ALTER TABLE sbyt.[Журнал_изменений] CHECK CONSTRAINT [Журнал_изменений_fk2]
GO

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
ALTER TABLE sbyt.[Документ] WITH CHECK ADD CONSTRAINT [Документ_fk2] FOREIGN KEY ([Плательщик]) REFERENCES sbyt.[Организации]([Row_id])
ON UPDATE NO ACTION
ON DELETE NO ACTION
GO
ALTER TABLE sbyt.[Документ] CHECK CONSTRAINT [Документ_fk2]
GO
ALTER TABLE sbyt.[Документ] WITH CHECK ADD CONSTRAINT [Документ_fk3] FOREIGN KEY ([Грузополучатель]) REFERENCES sbyt.[Организации]([Row_id])
ON UPDATE NO ACTION
ON DELETE NO ACTION
GO
ALTER TABLE sbyt.[Документ] CHECK CONSTRAINT [Документ_fk3]
GO

ALTER TABLE sbyt.[Строки_документа] WITH CHECK ADD CONSTRAINT [Строки_документа_fk0] FOREIGN KEY ([Строки_Документ]) REFERENCES sbyt.[Документ]([Row_id])
ON UPDATE NO ACTION
ON DELETE NO ACTION
GO
ALTER TABLE sbyt.[Строки_документа] CHECK CONSTRAINT [Строки_документа_fk0]
GO

--Добавление индексов (некластеризованных)
CREATE INDEX ind_Договор_Плательщик			ON sbyt.[Договор] (Плательщик);
CREATE INDEX ind_Договор_Грузополучатель	ON sbyt.[Договор] (Грузополучатель);
CREATE INDEX ind_Договор_Тип				ON sbyt.[Договор] (Тип_договора);
CREATE INDEX ind_Договор_Категория			ON sbyt.[Договор] (Категория);
CREATE INDEX ind_Договор_Отрасль			ON sbyt.[Договор] (Отрасль);
CREATE INDEX ind_Договор_Бюджет				ON sbyt.[Договор] (Бюджет);

CREATE INDEX ind_Классификаторы_Тип		ON sbyt.Классификаторы (Тип);
CREATE INDEX ind_Классификаторы_Папки	ON sbyt.Классификаторы (Папки);

CREATE INDEX ind_Типы_классификатора_Папки ON sbyt.[Типы_классификатора] (Папки);

CREATE INDEX ind_Свойства_ВидыПараметры			ON sbyt.Свойства (Виды_Параметры);
CREATE INDEX ind_Свойства_ПараметрыСчет			ON sbyt.Свойства (Параметры_Счет);
CREATE INDEX ind_Свойства_ПараметрыДоговор		ON sbyt.Свойства (Параметры_Договор);
CREATE INDEX ind_Свойства_ПараметрыОрганизация	ON sbyt.Свойства (Параметры_Организация);

CREATE INDEX ind_ЛицевыеДоговора_Договор ON sbyt.Лицевые_договора (Договор);
CREATE INDEX ind_ЛицевыеДоговора_Лицевой ON sbyt.Лицевые_договора (Лицевой);

CREATE INDEX ind_СписокОбъектов_Номенклатура	ON sbyt.Список_объектов (Номенклатура_Объекты);
CREATE INDEX ind_СписокОбъектов_Счет			ON sbyt.Список_объектов (Объекты_Счет);

CREATE INDEX ind_ПоказанияСчетчиков_Объект	ON sbyt.Показания_счетчиков (Объект_Показание);
CREATE INDEX ind_ПоказанияСчетчиков_Тип		ON sbyt.Показания_счетчиков (Тип_ввода);

CREATE INDEX ind_Журнал_Счет			ON sbyt.Журнал_изменений (Журнал_Счет);
CREATE INDEX ind_Журнал_Договор			ON sbyt.Журнал_изменений (Журнал_Договор);
CREATE INDEX ind_Журнал_Пользователь	ON sbyt.Журнал_изменений (Журнал_Пользователь);

CREATE INDEX ind_Документ_Тип				ON sbyt.Документ (Тип_документа);
CREATE INDEX ind_Документ_Плательщик		ON sbyt.Документ (Плательщик);
CREATE INDEX ind_Документ_Грузополучатель	ON sbyt.Документ (Грузополучатель);
CREATE INDEX ind_Документ_Папки				ON sbyt.Документ (Папки);

CREATE INDEX ind_СтрокиДокумента_Документ	ON sbyt.Строки_документа (Строки_Документ);
GO