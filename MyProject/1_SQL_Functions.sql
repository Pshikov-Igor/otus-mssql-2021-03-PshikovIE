USE [Project_Sbyt]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Функции конвертации информации в текст
CREATE OR ALTER FUNCTION sbyt.[atoa]( @str varchar(256) ) RETURNS nvarchar(1000)
AS BEGIN
   RETURN coalesce( @str, 'NULL' );
END;

GO

CREATE OR ALTER FUNCTION sbyt.[ftoa]( @val float ) RETURNS nvarchar(1000)
AS BEGIN
   RETURN coalesce( cast( @val as nvarchar(1000) ), 'NULL' );
END;

GO

CREATE OR ALTER FUNCTION sbyt.[itoa]( @val bigint ) RETURNS nvarchar(1000)
AS BEGIN
   RETURN coalesce( cast( @val AS nvarchar(1000) ), 'NULL' );
END;

GO

CREATE OR ALTER FUNCTION sbyt.[dtoa]( @val datetime ) RETURNS nvarchar(1000)
AS BEGIN
   RETURN coalesce( convert( nvarchar(1000), @val, 4 ), 'NULL' );
END;

GO

--Функция проверки соответствият или равенства полей
CREATE OR ALTER FUNCTION sbyt.[IsDistinct](@val1 SQL_VARIANT, @val2 SQL_VARIANT) 
returns BIT 
AS 
BEGIN 
   IF ( @val1 = @val2 OR ( @val1 IS NULL AND @val2 IS NULL ) ) 
     RETURN 0; 

   RETURN 1; 
END;
GO  

CREATE OR ALTER PROCEDURE [sbyt].[proc_write_journal]
   @user nvarchar(256),
   @curr_date datetime2,
   @descr nvarchar(1000),
   @account int,
   @contract int,
   @TableName nvarchar(256),
   @hostname nvarchar(256),
   @operation nvarchar(256)
AS BEGIN

   IF ( len(@descr) = 0 or @descr is null )
      return
   
   IF ( @curr_date is null )
	SET @curr_date = current_timestamp;

   IF ( @user is null )
	SET @user = SYSTEM_USER;

   IF ( @hostname is null )
	SET @hostname = host_name(); 

   IF ( @TableName is null )
	SET @TableName = ''; 

   DECLARE @userID int;
   Select @userID = Row_id from sbyt.Пользователи u Where u.Логин = @user;
   IF ( @userID is null )
	Select @userID = Row_id from sbyt.Пользователи u Where u.Логин = 'System';

   INSERT INTO [Sbyt].[Журнал_изменений]
      (Дата,  Журнал_Пользователь,  Действие, Журнал_Счет, Журнал_Договор, Таблица, ИмяКомпьютера, Операция)
   VALUES
      ( @curr_date, @userID, ISNULL( @descr, '' ),  @account, @contract, @TableName, @hostname, @operation);

END;

GO
