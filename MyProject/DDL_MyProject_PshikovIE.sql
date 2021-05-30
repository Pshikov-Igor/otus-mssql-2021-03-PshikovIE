--������� ��

CREATE DATABASE [Project_Sbyt]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = Sbyt, FILENAME = N'I:\��������\OTUS\Bases\Sbyt.mdf' , 
	SIZE = 8MB , 
	MAXSIZE = UNLIMITED, 
	FILEGROWTH = 30MB )
 LOG ON 
( NAME = Sbyt_log, FILENAME = N'I:\��������\OTUS\Bases\Sbyt_log.ldf' , 
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
	����� varchar(100) NOT NULL,
	���������� int NOT NULL,
	��������������� int NOT NULL,
	������_�������� datetime2 NOT NULL,
	���������_�������� datetime2 NOT NULL DEFAULT '20451231',
	���_�������� int NOT NULL,
	��������� int,
	������� int,
	������ int,
	���������� varchar(255),
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
	�������� varchar(255),
	���������� varchar(255),
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
	�������� varchar(255) NOT NULL,
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
	���������� varchar(255) NOT NULL,
  CONSTRAINT [PK_��������] PRIMARY KEY CLUSTERED
  (
  [Row_id] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
CREATE TABLE Sbyt.[�����������] (
	Row_ID int IDENTITY (1,1) NOT NULL,
	��� varchar(12) NOT NULL,
	��� varchar(10),
	���� varchar(100),
	�������� varchar(255) NOT NULL,
	������������ varchar(255) NOT NULL,
	���_����������� tinyint NOT NULL,
	�����������_����� varchar(255) NOT NULL,
	�����������_����� varchar(255) NOT NULL,
	�������� varchar(100),
	����� varchar(100),
	���������� varchar(255),
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
	����� varchar(255) NOT NULL,
	���������� varchar(255),
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
	���������_����� varchar(100) NOT NULL,
	�����_������ varchar(100) NOT NULL,
	���������� int NOT NULL,
	�����������_������������� int NOT NULL,
	���_������� datetime2 NOT NULL,
	�������_���� int NOT NULL,
  CONSTRAINT [PK_������_��������] PRIMARY KEY CLUSTERED
  (
  [Row_id] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
CREATE TABLE Sbyt.[������������] (
	Row_ID int IDENTITY (1,1) NOT NULL,
	������������ varchar(255) NOT NULL,
	�����������_�������� float NOT NULL,
	����������� int NOT NULL,
	�������_����������� tinyint NOT NULL,
	�����_������������ varchar(255),
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
	���������_����� datetime2 NOT NULL,
	��������� float NOT NULL,
	������ float NOT NULL,
	��������������_������ float NOT NULL,
	��������_������ float NOT NULL,
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
	�������� varchar(255) NOT NULL,
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
	�����_Add tinyint NOT NULL DEFAULT '-1',
	���_��������� int,
	����� int,
	���������� int,
	��������������� int,
	���������� float,
	����� float,
	��������� float,
	������������ varchar(255),
  CONSTRAINT [PK_��������] PRIMARY KEY CLUSTERED
  (
  [Row_id] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
CREATE TABLE Sbyt.[������_���������] (
	Row_ID int IDENTITY (1,1) NOT NULL,
	������_�������� int NOT NULL,
	������ varchar(255) NOT NULL,
	���������� float NOT NULL,
	����� float NOT NULL,
	����� float NOT NULL,
	��������� float NOT NULL,
	��_����� datetime2 NOT NULL,
  CONSTRAINT [PK_������_���������] PRIMARY KEY CLUSTERED
  (
  [Row_id] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
CREATE TABLE Sbyt.[������������] (
	Row_ID int IDENTITY (1,1) NOT NULL,
	����� varchar(100) NOT NULL,
	������ image,
	������� varchar(100) NOT NULL,
	��� varchar(100) NOT NULL,
	�������� varchar(100),
	����� varchar(100),
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
ALTER TABLE sbyt.[�������] WITH CHECK ADD CONSTRAINT [�������_fk3] FOREIGN KEY ([���������]) REFERENCES sbyt.[��������������]([Row_ID])
ON UPDATE NO ACTION
ON DELETE NO ACTION
GO
ALTER TABLE sbyt.[�������] CHECK CONSTRAINT [�������_fk3]
GO
ALTER TABLE sbyt.[�������] WITH CHECK ADD CONSTRAINT [�������_fk4] FOREIGN KEY ([�������]) REFERENCES sbyt.[��������������]([Row_ID])
ON UPDATE NO ACTION
ON DELETE NO ACTION
GO
ALTER TABLE sbyt.[�������] CHECK CONSTRAINT [�������_fk4]
GO
ALTER TABLE sbyt.[�������] WITH CHECK ADD CONSTRAINT [�������_fk5] FOREIGN KEY ([������]) REFERENCES sbyt.[��������������]([Row_ID])
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
CREATE INDEX ind_�������_���������			ON sbyt.[�������] (���������);
CREATE INDEX ind_�������_�������			ON sbyt.[�������] (�������);
CREATE INDEX ind_�������_������				ON sbyt.[�������] (������);

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