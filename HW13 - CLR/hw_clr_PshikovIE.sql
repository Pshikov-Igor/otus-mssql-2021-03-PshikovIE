USE [WideWorldImporters]

-- Подключаем CLR
exec sp_configure 'show advanced options', 1;
exec sp_configure 'clr enabled', 1;
exec sp_configure 'clr strict security', 0 
GO
reconfigure;
GO

-- Копируем dll сборку в БД
CREATE ASSEMBLY MyFirstAssembly_Pshikov
FROM 'D:\MyFirstProject_Pshikov.dll'
WITH PERMISSION_SET = SAFE;  

-- Подключаем функцию из сборки 
CREATE FUNCTION dbo.fn_MyExponentiation(@number float, @extent int)  
RETURNS float
AS EXTERNAL NAME MyFirstAssembly_Pshikov.[WWI_Pshikov_Namespace.WWI_Pshikov_Class].MyExponentiation;
GO 

-- Используем функцию
SELECT dbo.fn_MyExponentiation(2, 10)

-- Подключаем процедуру из сборки
CREATE PROCEDURE dbo.usp_MyHelloProcedure
(  
    @Name nvarchar(50), @namber int
)  
AS EXTERNAL NAME MyFirstAssembly_Pshikov.[WWI_Pshikov_Namespace.WWI_Pshikov_Class].MyHelloProcedure;  
GO 

-- Используем ХП
exec dbo.usp_MyHelloProcedure @Name = 'Pshikov Igor', @namber = 100;

----- Проверка
SELECT * FROM sys.assemblies
SELECT * FROM sys.assembly_modules
-----

-- Чистка
/*
 DROP PROCEDURE dbo.usp_MyHelloProcedure 
 DROP FUNCTION  dbo.fn_MyExponentiation 
 DROP ASSEMBLY  MyFirstAssembly_Pshikov
*/