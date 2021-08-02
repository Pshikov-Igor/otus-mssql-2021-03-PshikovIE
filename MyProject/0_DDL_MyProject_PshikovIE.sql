--������� ��
USE [master]
GO

CREATE DATABASE [Project_Sbyt]
 CONTAINMENT = NONE
 ON  PRIMARY 
--( NAME = Sbyt, FILENAME = N'I:\��������\OTUS\Bases\Sbyt.mdf' , 
( NAME = Sbyt, FILENAME = N'D:\Sbyt.mdf' , 
	SIZE = 8MB , 
	MAXSIZE = UNLIMITED, 
	FILEGROWTH = 30MB )
 LOG ON 
--( NAME = Sbyt_log, FILENAME = N'I:\��������\OTUS\Bases\Sbyt_log.ldf' , 
( NAME = Sbyt_log, FILENAME = N'd:\Sbyt_log.ldf' , 
	SIZE = 8MB , 
	MAXSIZE = UNLIMITED , 
	FILEGROWTH = 30MB )
GO

USE [Project_Sbyt]
GO

--������� ��������� �������� ������ ��� ������� ��������
ALTER DATABASE [Project_Sbyt] ADD FILEGROUP [Sbyt_Journal]
GO

ALTER DATABASE [Project_Sbyt] ADD FILE 
--( NAME = N'Sbyt_Journal', FILENAME = N'I:\��������\OTUS\Bases\Sbyt_Journal.ndf' , 
( NAME = N'Sbyt_Journal', FILENAME = N'D:\Sbyt_Journal.ndf' , 
SIZE = 8MB , FILEGROWTH = 100MB ) TO FILEGROUP [Sbyt_Journal]
GO

--������� ���� ������� ������� ��������� ����������
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

--�������� ���� �����
Create schema Sbyt;
GO

--������� �������
CREATE TABLE Sbyt.[�������] (
	Row_ID int IDENTITY (1,1) NOT NULL,
	����� nvarchar(100) NOT NULL,
	����������_�� int NOT NULL,
	���������������_�� int NOT NULL,
	������_�������� date NOT NULL,
	���������_�������� date NOT NULL DEFAULT '20451231',
	���_�������� int NOT NULL,
	���������_�� int,
	�������_�� int,
	������_�� int,
	���������� nvarchar(1000),
  CONSTRAINT [PK_�������] PRIMARY KEY CLUSTERED
  (
  [Row_ID] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
CREATE TABLE Sbyt.[��������������] (
	Row_ID int IDENTITY (1,1) NOT NULL,
	��� int,
	����� int,
	�����_Add tinyint NOT NULL,
	��� int,
	�������� nvarchar(1000),
	���������� nvarchar(1000),
  CONSTRAINT [PK_��������������] PRIMARY KEY CLUSTERED
  (
  [Row_ID] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
CREATE TABLE Sbyt.[����_��������������] (
	Row_ID int IDENTITY (1,1) NOT NULL,
	����� int,
	�����_Add tinyint NOT NULL,
	�������� nvarchar(500) NOT NULL,
  CONSTRAINT [PK_����_��������������] PRIMARY KEY CLUSTERED
  (
  [Row_ID] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
CREATE TABLE Sbyt.[��������] (
	Row_ID bigint IDENTITY (1,1) NOT NULL,
	����_��������� int NOT NULL,
	���������_���� bigint,
	���������_������� int,
	���������_����������� int,
	������ datetime2 NOT NULL,
	������ datetime2 NOT NULL DEFAULT '20451231',
	�������� int NOT NULL,
	���������� nvarchar(1000) NOT NULL,
  CONSTRAINT [PK_��������] PRIMARY KEY CLUSTERED
  (
  [Row_id] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
CREATE TABLE Sbyt.[�����������] (
	Row_ID int IDENTITY (1,1) NOT NULL,
	��� nvarchar(24) NOT NULL,
	��� nvarchar(20),
	���� nvarchar(30),
	�������� nvarchar(500) NOT NULL,
	������������ nvarchar(1000) NOT NULL,
	���_����������� tinyint NOT NULL,
	�����������_����� nvarchar(1000) NOT NULL,
	�����������_����� nvarchar(1000) NOT NULL,
	�������� nvarchar(100),
	����� nvarchar(250),
	���������� nvarchar(1000),
  CONSTRAINT [PK_�����������] PRIMARY KEY CLUSTERED
  (
  [Row_id] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
CREATE TABLE Sbyt.[�������_��������] (
	Row_ID bigint IDENTITY (1,1) NOT NULL,
	�������_�� int NOT NULL,
	�������_�� bigint NOT NULL,
	������ datetime2 NOT NULL,
	������ datetime2 NOT NULL DEFAULT '20451231',
  CONSTRAINT [PK_�������_��������] PRIMARY KEY CLUSTERED
  (
  [Row_id] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
CREATE TABLE Sbyt.[�������_�����] (
	Row_ID bigint IDENTITY (1,1) NOT NULL,
	����� int NOT NULL,
	����� nvarchar(1000) NOT NULL,
	���������� nvarchar(1000),
  CONSTRAINT [PK_�������_�����] PRIMARY KEY CLUSTERED
  (
  [Row_id] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
CREATE TABLE Sbyt.[������_��������] (
	Row_ID bigint IDENTITY (1,1) NOT NULL,
	������ datetime2 NOT NULL,
	������ datetime2 NOT NULL DEFAULT '20451231',
	������������_������� int NOT NULL,
	���������_����� nvarchar(100) NOT NULL,
	�����_������ nvarchar(100) NOT NULL,
	���������� int NOT NULL,
	�����������_������������� int NOT NULL,
	���_������� date NOT NULL,
	�������_���� bigint NOT NULL,
  CONSTRAINT [PK_������_��������] PRIMARY KEY CLUSTERED
  (
  [Row_id] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
CREATE TABLE Sbyt.[������������] (
	Row_ID int IDENTITY (1,1) NOT NULL,
	������������ nvarchar(500) NOT NULL,
	�����������_�������� decimal(10,2) NOT NULL,
	����������� int NOT NULL,
	�������_����������� tinyint NOT NULL,
	�����_������������ nvarchar(500),
  CONSTRAINT [PK_������������] PRIMARY KEY CLUSTERED
  (
  [Row_id] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
CREATE TABLE Sbyt.[���������_���������] (
	Row_ID bigint IDENTITY (1,1) NOT NULL,
	������_��������� bigint NOT NULL,
	���_����� int NOT NULL,
	���� datetime2 NOT NULL,
	���������_����� date NOT NULL,
	��������� decimal(19,4) NOT NULL,
	������ decimal(19,4) NOT NULL,
	��������������_������ decimal(19,4) NOT NULL,
	��������_������ decimal(19,4) NOT NULL,
	��� tinyint NOT NULL,
  CONSTRAINT [PK_���������_���������] PRIMARY KEY CLUSTERED
  (
  [Row_id] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
CREATE TABLE Sbyt.[������_���������] (
	Row_ID bigint IDENTITY (1,1) NOT NULL,
	���� datetime2 NOT NULL,
	������_������������ int,
	�������� nvarchar(2000),
	������_���� bigint,
	������_������� int,
	������� nvarchar(100),
	�������� nvarchar(100),
	������������� nvarchar(256)
) ON [schmJournalOperationsPartition](����)---� ����� [schmJournalOperationsPartition] �� ����� [����]
GO

--������� ���������� ������
ALTER TABLE Sbyt.[������_���������] ADD CONSTRAINT PK_������_���������
PRIMARY KEY CLUSTERED  (����, Row_ID)
 ON [schmJournalOperationsPartition](����);
 
 GO
CREATE TABLE Sbyt.[��������] (
	Row_ID bigint IDENTITY (1,1) NOT NULL,
	����� bigint,
	�����_Add tinyint NOT NULL,
	���_��������� int,
	����� int,
	����������_�� int,
	���������������_�� int,
	���������� decimal(19,4),
	����� decimal(19,4),
	��������� decimal(19,4),
	������������ nvarchar(500),
	��������_������� int NULL
  CONSTRAINT [PK_��������] PRIMARY KEY CLUSTERED
  (
  [Row_id] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
CREATE TABLE Sbyt.[������_���������] (
	Row_ID bigint IDENTITY (1,1) NOT NULL,
	������_�������� bigint NOT NULL,
	������ nvarchar(500) NOT NULL,
	���������� decimal(19,4) NOT NULL,
	����� decimal(19,4) NOT NULL,
	����� decimal(19,4) NOT NULL,
	��������� decimal(19,4) NOT NULL,
	��_����� date NOT NULL,
  CONSTRAINT [PK_������_���������] PRIMARY KEY CLUSTERED
  (
  [Row_id] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
CREATE TABLE Sbyt.[������������] (
	Row_ID int IDENTITY (1,1) NOT NULL,
	����� nvarchar(250) NOT NULL,
	������ image,
	������� nvarchar(250) NOT NULL,
	��� nvarchar(250) NOT NULL,
	�������� nvarchar(250),
	����� nvarchar(500),
  CONSTRAINT [PK_������������] PRIMARY KEY CLUSTERED
  (
  [Row_id] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO

--���������� ������� ������ � ����������� 
ALTER TABLE sbyt.[�������] WITH CHECK ADD CONSTRAINT [�������_fk0] FOREIGN KEY ([����������_��]) REFERENCES sbyt.[�����������]([Row_id])
ON UPDATE NO ACTION
ON DELETE NO ACTION
GO
ALTER TABLE sbyt.[�������] CHECK CONSTRAINT [�������_fk0]
GO
ALTER TABLE sbyt.[�������] WITH CHECK ADD CONSTRAINT [�������_fk1] FOREIGN KEY ([���������������_��]) REFERENCES sbyt.[�����������]([Row_id])
ON UPDATE NO ACTION
ON DELETE NO ACTION
GO
ALTER TABLE sbyt.[�������] CHECK CONSTRAINT [�������_fk1]
GO
ALTER TABLE sbyt.[�������] WITH CHECK ADD CONSTRAINT [�������_fk2] FOREIGN KEY ([���_��������]) REFERENCES sbyt.[��������������]([Row_ID])
ON UPDATE NO ACTION
ON DELETE NO ACTION
GO
ALTER TABLE sbyt.[�������] CHECK CONSTRAINT [�������_fk2]
GO
ALTER TABLE sbyt.[�������] WITH CHECK ADD CONSTRAINT [�������_fk3] FOREIGN KEY ([���������_��]) REFERENCES sbyt.[��������������]([Row_ID])
ON UPDATE NO ACTION
ON DELETE NO ACTION
GO
ALTER TABLE sbyt.[�������] CHECK CONSTRAINT [�������_fk3]
GO
ALTER TABLE sbyt.[�������] WITH CHECK ADD CONSTRAINT [�������_fk4] FOREIGN KEY ([�������_��]) REFERENCES sbyt.[��������������]([Row_ID])
ON UPDATE NO ACTION
ON DELETE NO ACTION
GO
ALTER TABLE sbyt.[�������] CHECK CONSTRAINT [�������_fk4]
GO
ALTER TABLE sbyt.[�������] WITH CHECK ADD CONSTRAINT [�������_fk5] FOREIGN KEY ([������_��]) REFERENCES sbyt.[��������������]([Row_ID])
ON UPDATE NO ACTION
ON DELETE NO ACTION
GO
ALTER TABLE sbyt.[�������] CHECK CONSTRAINT [�������_fk5]
GO

ALTER TABLE sbyt.[��������������] WITH CHECK ADD CONSTRAINT [��������������_fk0] FOREIGN KEY ([���]) REFERENCES sbyt.[����_��������������]([Row_ID])
ON UPDATE NO ACTION
ON DELETE NO ACTION
GO
ALTER TABLE sbyt.[��������������] CHECK CONSTRAINT [��������������_fk0]
GO
ALTER TABLE sbyt.[��������������] WITH CHECK ADD CONSTRAINT [��������������_fk1] FOREIGN KEY ([�����]) REFERENCES sbyt.[��������������]([Row_ID])
ON UPDATE NO ACTION
ON DELETE NO ACTION
GO
ALTER TABLE sbyt.[��������������] CHECK CONSTRAINT [��������������_fk1]
GO

ALTER TABLE sbyt.[����_��������������] WITH CHECK ADD CONSTRAINT [����_��������������_fk0] FOREIGN KEY ([�����]) REFERENCES sbyt.[����_��������������]([Row_ID])
ON UPDATE NO ACTION
ON DELETE NO ACTION
GO
ALTER TABLE sbyt.[����_��������������] CHECK CONSTRAINT [����_��������������_fk0]
GO

ALTER TABLE sbyt.[��������] WITH CHECK ADD CONSTRAINT [��������_fk0] FOREIGN KEY ([����_���������]) REFERENCES sbyt.[��������������]([Row_ID])
ON UPDATE NO ACTION
ON DELETE NO ACTION
GO
ALTER TABLE sbyt.[��������] CHECK CONSTRAINT [��������_fk0]
GO
ALTER TABLE sbyt.[��������] WITH CHECK ADD CONSTRAINT [��������_fk1] FOREIGN KEY ([���������_����]) REFERENCES sbyt.[�������_�����]([Row_id])
ON UPDATE NO ACTION
ON DELETE NO ACTION
GO
ALTER TABLE sbyt.[��������] CHECK CONSTRAINT [��������_fk1]
GO
ALTER TABLE sbyt.[��������] WITH CHECK ADD CONSTRAINT [��������_fk2] FOREIGN KEY ([���������_�������]) REFERENCES sbyt.[�������]([Row_ID])
ON UPDATE NO ACTION
ON DELETE NO ACTION
GO
ALTER TABLE sbyt.[��������] CHECK CONSTRAINT [��������_fk2]
GO
ALTER TABLE sbyt.[��������] WITH CHECK ADD CONSTRAINT [��������_fk3] FOREIGN KEY ([���������_�����������]) REFERENCES sbyt.[�����������]([Row_id])
ON UPDATE NO ACTION
ON DELETE NO ACTION
GO
ALTER TABLE sbyt.[��������] CHECK CONSTRAINT [��������_fk3]
GO


ALTER TABLE sbyt.[�������_��������] WITH CHECK ADD CONSTRAINT [�������_��������_fk0] FOREIGN KEY ([�������_��]) REFERENCES sbyt.[�������]([Row_ID])
ON UPDATE NO ACTION
ON DELETE NO ACTION
GO
ALTER TABLE sbyt.[�������_��������] CHECK CONSTRAINT [�������_��������_fk0]
GO
ALTER TABLE sbyt.[�������_��������] WITH CHECK ADD CONSTRAINT [�������_��������_fk1] FOREIGN KEY ([�������_��]) REFERENCES sbyt.[�������_�����]([Row_id])
ON UPDATE NO ACTION
ON DELETE NO ACTION
GO
ALTER TABLE sbyt.[�������_��������] CHECK CONSTRAINT [�������_��������_fk1]
GO


ALTER TABLE sbyt.[������_��������] WITH CHECK ADD CONSTRAINT [������_��������_fk0] FOREIGN KEY ([������������_�������]) REFERENCES sbyt.[������������]([Row_id])
ON UPDATE NO ACTION
ON DELETE NO ACTION
GO
ALTER TABLE sbyt.[������_��������] CHECK CONSTRAINT [������_��������_fk0]
GO
ALTER TABLE sbyt.[������_��������] WITH CHECK ADD CONSTRAINT [������_��������_fk1] FOREIGN KEY ([�������_����]) REFERENCES sbyt.[�������_�����]([Row_id])
ON UPDATE NO ACTION
ON DELETE NO ACTION
GO
ALTER TABLE sbyt.[������_��������] CHECK CONSTRAINT [������_��������_fk1]
GO


ALTER TABLE sbyt.[���������_���������] WITH CHECK ADD CONSTRAINT [���������_���������_fk0] FOREIGN KEY ([������_���������]) REFERENCES sbyt.[������_��������]([Row_id])
ON UPDATE NO ACTION
ON DELETE NO ACTION
GO
ALTER TABLE sbyt.[���������_���������] CHECK CONSTRAINT [���������_���������_fk0]
GO
ALTER TABLE sbyt.[���������_���������] WITH CHECK ADD CONSTRAINT [���������_���������_fk1] FOREIGN KEY ([���_�����]) REFERENCES sbyt.[��������������]([Row_ID])
ON UPDATE NO ACTION
ON DELETE NO ACTION
GO
ALTER TABLE sbyt.[���������_���������] CHECK CONSTRAINT [���������_���������_fk1]
GO

/*
ALTER TABLE sbyt.[������_���������] WITH CHECK ADD CONSTRAINT [������_���������_fk0] FOREIGN KEY ([������_����]) REFERENCES sbyt.[�������_�����]([Row_id])
ON UPDATE NO ACTION
ON DELETE NO ACTION
GO
ALTER TABLE sbyt.[������_���������] CHECK CONSTRAINT [������_���������_fk0]
GO

ALTER TABLE sbyt.[������_���������] WITH CHECK ADD CONSTRAINT [������_���������_fk1] FOREIGN KEY ([������_�������]) REFERENCES sbyt.[�������]([Row_ID])
ON UPDATE NO ACTION
ON DELETE NO ACTION
GO
ALTER TABLE sbyt.[������_���������] CHECK CONSTRAINT [������_���������_fk1]
GO

ALTER TABLE sbyt.[������_���������] WITH CHECK ADD CONSTRAINT [������_���������_fk2] FOREIGN KEY ([������_������������]) REFERENCES sbyt.[������������]([Row_id])
ON UPDATE NO ACTION
ON DELETE NO ACTION
GO
ALTER TABLE sbyt.[������_���������] CHECK CONSTRAINT [������_���������_fk2]
GO
*/

ALTER TABLE sbyt.[��������] WITH CHECK ADD CONSTRAINT [��������_fk0] FOREIGN KEY ([�����]) REFERENCES sbyt.[��������]([Row_id])
ON UPDATE NO ACTION
ON DELETE NO ACTION
GO
ALTER TABLE sbyt.[��������] CHECK CONSTRAINT [��������_fk0]
GO
ALTER TABLE sbyt.[��������] WITH CHECK ADD CONSTRAINT [��������_fk1] FOREIGN KEY ([���_���������]) REFERENCES sbyt.[��������������]([Row_ID])
ON UPDATE NO ACTION
ON DELETE NO ACTION
GO
ALTER TABLE sbyt.[��������] CHECK CONSTRAINT [��������_fk1]
GO
ALTER TABLE sbyt.[��������] WITH CHECK ADD CONSTRAINT [��������_fk2] FOREIGN KEY ([����������_��]) REFERENCES sbyt.[�����������]([Row_id])
ON UPDATE NO ACTION
ON DELETE NO ACTION
GO
ALTER TABLE sbyt.[��������] CHECK CONSTRAINT [��������_fk2]
GO
ALTER TABLE sbyt.[��������] WITH CHECK ADD CONSTRAINT [��������_fk3] FOREIGN KEY ([���������������_��]) REFERENCES sbyt.[�����������]([Row_id])
ON UPDATE NO ACTION
ON DELETE NO ACTION
GO
ALTER TABLE sbyt.[��������] CHECK CONSTRAINT [��������_fk3]
GO
ALTER TABLE sbyt.[��������] WITH CHECK ADD CONSTRAINT [��������_fk4] FOREIGN KEY ([��������_�������]) REFERENCES sbyt.[�������]([Row_ID])
ON UPDATE CASCADE
ON DELETE NO ACTION
GO
ALTER TABLE sbyt.[��������] CHECK CONSTRAINT [��������_fk4]
GO

ALTER TABLE sbyt.[������_���������] WITH CHECK ADD CONSTRAINT [������_���������_fk0] FOREIGN KEY ([������_��������]) REFERENCES sbyt.[��������]([Row_id])
ON UPDATE NO ACTION
ON DELETE NO ACTION
GO
ALTER TABLE sbyt.[������_���������] CHECK CONSTRAINT [������_���������_fk0]
GO

--���������� �������� 
--1. ���������� �������� (������������������) �� FK (FOREIGN KEY)
CREATE NONCLUSTERED INDEX ind_�������_����������			ON sbyt.[�������] (����������_��);
CREATE NONCLUSTERED INDEX ind_�������_���������������		ON sbyt.[�������] (���������������_��);
CREATE NONCLUSTERED INDEX ind_�������_���					ON sbyt.[�������] (���_��������);
CREATE NONCLUSTERED INDEX ind_�������_���������				ON sbyt.[�������] (���������_��);
CREATE NONCLUSTERED INDEX ind_�������_�������				ON sbyt.[�������] (�������_��);
CREATE NONCLUSTERED INDEX ind_�������_������				ON sbyt.[�������] (������_��);

CREATE NONCLUSTERED INDEX ind_��������������_���			ON sbyt.�������������� (���);

CREATE NONCLUSTERED INDEX ind_��������_�������������		ON sbyt.�������� (����_���������);
CREATE NONCLUSTERED INDEX ind_��������_�������������		ON sbyt.�������� (���������_����);
CREATE NONCLUSTERED INDEX ind_��������_����������������		ON sbyt.�������� (���������_�������);
CREATE NONCLUSTERED INDEX ind_��������_��������������������	ON sbyt.�������� (���������_�����������);

CREATE NONCLUSTERED INDEX ind_���������������_������� 		ON sbyt.�������_�������� (�������_��);
CREATE NONCLUSTERED INDEX ind_���������������_������� 		ON sbyt.�������_�������� (�������_��);

CREATE NONCLUSTERED INDEX ind_��������������_������������	ON sbyt.������_�������� (������������_�������);
CREATE NONCLUSTERED INDEX ind_��������������_����			ON sbyt.������_�������� (�������_����);

CREATE NONCLUSTERED INDEX ind_������������������_������		ON sbyt.���������_��������� (������_���������);
CREATE NONCLUSTERED INDEX ind_������������������_���		ON sbyt.���������_��������� (���_�����);

CREATE NONCLUSTERED INDEX ind_������_����					ON sbyt.������_��������� (������_����);
CREATE NONCLUSTERED INDEX ind_������_�������				ON sbyt.������_��������� (������_�������);
CREATE NONCLUSTERED INDEX ind_������_������������			ON sbyt.������_��������� (������_������������);

CREATE NONCLUSTERED INDEX ind_��������_���					ON sbyt.�������� (���_���������);
CREATE NONCLUSTERED INDEX ind_��������_����������			ON sbyt.�������� (����������_��);
CREATE NONCLUSTERED INDEX ind_��������_���������������		ON sbyt.�������� (���������������_��);
CREATE NONCLUSTERED INDEX ind_��������_�������				ON sbyt.�������� (��������_�������);

CREATE NONCLUSTERED INDEX ind_���������������_��������	ON sbyt.������_��������� (������_��������);
GO

--2. ���������� �������� �� ���� ����� ������, ��� ����������� ������ ����� � ����� ��� ����������� ����������� ��������� �� ����� ����������.

CREATE NONCLUSTERED INDEX ind_��������������_�����			ON sbyt.�������������� (�����);
CREATE NONCLUSTERED INDEX ind_����_��������������_����� 	ON sbyt.[����_��������������] (�����);
CREATE NONCLUSTERED INDEX ind_��������_�����				ON sbyt.�������� (�����);
GO

--3. ���������� �������� �� ������� Sbyt.[�����������] ��� �������� ������ ����������� �� ��� ��� ����

CREATE NONCLUSTERED INDEX ind_�����������_��� ON Sbyt.[�����������] (���);
CREATE NONCLUSTERED INDEX ind_�����������_���� ON Sbyt.[�����������] (����);
GO

--4. ���������� ������� �� ������� Sbyt.������� ��� �������� ������ ������ ��������
CREATE NONCLUSTERED INDEX ind_�������_����� ON Sbyt.������� (�����);
GO

--5. ���������� ������� �� ������� Sbyt.�������_����� ��� �������� ������ �������� ����� �� ��� ������
CREATE NONCLUSTERED INDEX ind_�������_�����_����� ON Sbyt.�������_����� (�����);
GO

--6. ���������� ������� �� ������� Sbyt.������_�������� ��� �������� ������ ������� ����� �� ��� ���������� ������
CREATE NONCLUSTERED INDEX ind_������_��������_�������������� ON Sbyt.������_�������� (���������_�����);
GO

--7. ���������� ������� �� ������� Sbyt.�������� ��� �������� ������ ��������� �� ��� ������ (����� ���������� ��� �����������)
CREATE NONCLUSTERED INDEX ind_��������_����� ON Sbyt.�������� (�����);
GO

--8. ��� �� ������� ��������� ������� ��� ������� ������ � ����������� �� �������

CREATE INDEX ind_��������_������������			ON Sbyt.��������(������, ������);
CREATE INDEX ind_������_��������_������������	ON Sbyt.������_��������(������, ������);
CREATE INDEX ind_�������_��������_������������	ON Sbyt.�������_��������(������, ������);
GO

