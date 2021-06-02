--������� ��

CREATE DATABASE [Project_Sbyt]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = Sbyt, FILENAME = N'I:\��������\OTUS\Bases\Sbyt.mdf' , 
--( NAME = Sbyt, FILENAME = N'D:\Sbyt.mdf' , 
	SIZE = 8MB , 
	MAXSIZE = UNLIMITED, 
	FILEGROWTH = 30MB )
 LOG ON 
( NAME = Sbyt_log, FILENAME = N'I:\��������\OTUS\Bases\Sbyt_log.ldf' , 
--( NAME = Sbyt_log, FILENAME = N'd:\Sbyt_log.ldf' , 
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


--�������� ���� �����
Create schema Sbyt;
GO

--������� �������
CREATE TABLE Sbyt.[�������] (
	Row_ID int IDENTITY (1,1) NOT NULL,
	����� nvarchar(100) NOT NULL,
	���������� int NOT NULL,
	��������������� int NOT NULL,
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
	Row_ID int IDENTITY (1,1) NOT NULL,
	����_��������� int NOT NULL,
	���������_���� int,
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
	Row_ID int IDENTITY (1,1) NOT NULL,
	������� int NOT NULL,
	������� int NOT NULL,
	������ datetime2 NOT NULL,
	������ datetime2 NOT NULL DEFAULT '20451231',
  CONSTRAINT [PK_�������_��������] PRIMARY KEY CLUSTERED
  (
  [Row_id] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
CREATE TABLE Sbyt.[�������_�����] (
	Row_ID int IDENTITY (1,1) NOT NULL,
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
	Row_ID int IDENTITY (1,1) NOT NULL,
	������ datetime2 NOT NULL,
	������ datetime2 NOT NULL DEFAULT '20451231',
	������������_������� int NOT NULL,
	���������_����� nvarchar(100) NOT NULL,
	�����_������ nvarchar(100) NOT NULL,
	���������� int NOT NULL,
	�����������_������������� int NOT NULL,
	���_������� date NOT NULL,
	�������_���� int NOT NULL,
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
	Row_ID int IDENTITY (1,1) NOT NULL,
	������_��������� int NOT NULL,
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
	Row_ID int IDENTITY (1,1) NOT NULL,
	���� datetime2 NOT NULL,
	������_������������ int NOT NULL,
	�������� nvarchar(1000) NOT NULL,
	������_���� int,
	������_������� int,
  CONSTRAINT [PK_������_���������] PRIMARY KEY CLUSTERED
  (
  [Row_Id] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
CREATE TABLE Sbyt.[��������] (
	Row_ID int IDENTITY (1,1) NOT NULL,
	����� int,
	�����_Add tinyint NOT NULL,
	���_��������� int,
	����� int,
	���������� int,
	��������������� int,
	���������� decimal(19,4),
	����� decimal(19,4),
	��������� decimal(19,4),
	������������ nvarchar(500),
  CONSTRAINT [PK_��������] PRIMARY KEY CLUSTERED
  (
  [Row_id] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
CREATE TABLE Sbyt.[������_���������] (
	Row_ID int IDENTITY (1,1) NOT NULL,
	������_�������� int NOT NULL,
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
ALTER TABLE sbyt.[�������] WITH CHECK ADD CONSTRAINT [�������_fk0] FOREIGN KEY ([����������]) REFERENCES sbyt.[�����������]([Row_id])
ON UPDATE NO ACTION
ON DELETE NO ACTION
GO
ALTER TABLE sbyt.[�������] CHECK CONSTRAINT [�������_fk0]
GO
ALTER TABLE sbyt.[�������] WITH CHECK ADD CONSTRAINT [�������_fk1] FOREIGN KEY ([���������������]) REFERENCES sbyt.[�����������]([Row_id])
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


ALTER TABLE sbyt.[�������_��������] WITH CHECK ADD CONSTRAINT [�������_��������_fk0] FOREIGN KEY ([�������]) REFERENCES sbyt.[�������]([Row_ID])
ON UPDATE NO ACTION
ON DELETE NO ACTION
GO
ALTER TABLE sbyt.[�������_��������] CHECK CONSTRAINT [�������_��������_fk0]
GO
ALTER TABLE sbyt.[�������_��������] WITH CHECK ADD CONSTRAINT [�������_��������_fk1] FOREIGN KEY ([�������]) REFERENCES sbyt.[�������_�����]([Row_id])
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

ALTER TABLE sbyt.[������_���������] WITH CHECK ADD CONSTRAINT [������_���������_fk0] FOREIGN KEY ([������_������������]) REFERENCES sbyt.[������������]([Row_id])
ON UPDATE NO ACTION
ON DELETE NO ACTION
GO
ALTER TABLE sbyt.[������_���������] CHECK CONSTRAINT [������_���������_fk0]
GO
ALTER TABLE sbyt.[������_���������] WITH CHECK ADD CONSTRAINT [������_���������_fk1] FOREIGN KEY ([������_����]) REFERENCES sbyt.[�������_�����]([Row_id])
ON UPDATE NO ACTION
ON DELETE NO ACTION
GO
ALTER TABLE sbyt.[������_���������] CHECK CONSTRAINT [������_���������_fk1]
GO
ALTER TABLE sbyt.[������_���������] WITH CHECK ADD CONSTRAINT [������_���������_fk2] FOREIGN KEY ([������_�������]) REFERENCES sbyt.[�������]([Row_ID])
ON UPDATE NO ACTION
ON DELETE NO ACTION
GO
ALTER TABLE sbyt.[������_���������] CHECK CONSTRAINT [������_���������_fk2]
GO

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
ALTER TABLE sbyt.[��������] WITH CHECK ADD CONSTRAINT [��������_fk2] FOREIGN KEY ([����������]) REFERENCES sbyt.[�����������]([Row_id])
ON UPDATE NO ACTION
ON DELETE NO ACTION
GO
ALTER TABLE sbyt.[��������] CHECK CONSTRAINT [��������_fk2]
GO
ALTER TABLE sbyt.[��������] WITH CHECK ADD CONSTRAINT [��������_fk3] FOREIGN KEY ([���������������]) REFERENCES sbyt.[�����������]([Row_id])
ON UPDATE NO ACTION
ON DELETE NO ACTION
GO
ALTER TABLE sbyt.[��������] CHECK CONSTRAINT [��������_fk3]
GO

ALTER TABLE sbyt.[������_���������] WITH CHECK ADD CONSTRAINT [������_���������_fk0] FOREIGN KEY ([������_��������]) REFERENCES sbyt.[��������]([Row_id])
ON UPDATE NO ACTION
ON DELETE NO ACTION
GO
ALTER TABLE sbyt.[������_���������] CHECK CONSTRAINT [������_���������_fk0]
GO

--���������� �������� (������������������)
CREATE INDEX ind_�������_����������			ON sbyt.[�������] (����������);
CREATE INDEX ind_�������_���������������	ON sbyt.[�������] (���������������);
CREATE INDEX ind_�������_���				ON sbyt.[�������] (���_��������);
CREATE INDEX ind_�������_���������			ON sbyt.[�������] (���������_��);
CREATE INDEX ind_�������_�������			ON sbyt.[�������] (�������_��);
CREATE INDEX ind_�������_������				ON sbyt.[�������] (������_��);

CREATE INDEX ind_��������������_���		ON sbyt.�������������� (���);
CREATE INDEX ind_��������������_�����	ON sbyt.�������������� (�����);

CREATE INDEX ind_����_��������������_����� ON sbyt.[����_��������������] (�����);

CREATE INDEX ind_��������_�������������			ON sbyt.�������� (����_���������);
CREATE INDEX ind_��������_�������������			ON sbyt.�������� (���������_����);
CREATE INDEX ind_��������_����������������		ON sbyt.�������� (���������_�������);
CREATE INDEX ind_��������_��������������������	ON sbyt.�������� (���������_�����������);

CREATE INDEX ind_���������������_������� ON sbyt.�������_�������� (�������);
CREATE INDEX ind_���������������_������� ON sbyt.�������_�������� (�������);

CREATE INDEX ind_��������������_������������	ON sbyt.������_�������� (������������_�������);
CREATE INDEX ind_��������������_����			ON sbyt.������_�������� (�������_����);

CREATE INDEX ind_������������������_������	ON sbyt.���������_��������� (������_���������);
CREATE INDEX ind_������������������_���		ON sbyt.���������_��������� (���_�����);

CREATE INDEX ind_������_����			ON sbyt.������_��������� (������_����);
CREATE INDEX ind_������_�������			ON sbyt.������_��������� (������_�������);
CREATE INDEX ind_������_������������	ON sbyt.������_��������� (������_������������);

CREATE INDEX ind_��������_���				ON sbyt.�������� (���_���������);
CREATE INDEX ind_��������_����������		ON sbyt.�������� (����������);
CREATE INDEX ind_��������_���������������	ON sbyt.�������� (���������������);
CREATE INDEX ind_��������_�����				ON sbyt.�������� (�����);

CREATE INDEX ind_���������������_��������	ON sbyt.������_��������� (������_��������);
GO