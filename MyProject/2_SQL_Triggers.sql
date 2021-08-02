USE [Project_Sbyt]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---------------------
--Таблица: Договора--
---------------------

CREATE OR ALTER trigger [sbyt].[trig_Договор_LOG_DEL] on [sbyt].[Договор] after delete as begin
   set NOCOUNT on;

   -- если ничего не удалено, то ничего не делаем
   declare @row_count int;
   select @row_count = count( * ) from deleted;

   if (@row_count <> 0) begin
      declare @descr varchar(768),
              @document int,
              @rec_info varchar(256);

         select @rec_info = sbyt.atoa( [Номер] ) + ' от ' + sbyt.dtoa( [Начало_договора] )
		 from deleted;

         select @descr =
            sbyt.itoa( [ROW_ID] ) + ';' +
            sbyt.atoa( (select [Название] from [Организации]
                         where ROW_ID = deleted.[Плательщик_ИД]) ) + ';' +
            sbyt.atoa( (select [Название] from [Организации]
                         where ROW_ID = deleted.[Грузополучатель_ИД]) ) + ';' +
            sbyt.atoa( (select [Название] from [Классификаторы]
                         where ROW_ID = deleted.[Бюджет_ИД]) ) + ';' +
            sbyt.atoa( (select [Название] from [Классификаторы]
                         where ROW_ID = deleted.[Отрасль_ИД]) ) + ';' +
            sbyt.atoa( (select [Название] from [Классификаторы]
                         where ROW_ID = deleted.[Категория_ИД]) ) + ';' +
            sbyt.dtoa( [Начало_договора] ) + ';' +
            sbyt.dtoa( [Окончание_договора] ) + ';' +
            sbyt.atoa( [Примечание] ) + ';' +
            sbyt.itoa( [Тип_договора] ) + ';',
	        @document = ROW_ID
         from deleted;
      
         set @descr = 'Удален договор (' + @rec_info + '): ' + @descr;

		 DECLARE @OperTime datetime2, @hostName nvarchar(256), @user nvarchar(256);
		 SET @hostName = host_name();
		 SET @OperTime = current_timestamp;
		 SET @user = SYSTEM_USER;

      execute sbyt.proc_write_journal_SB_SendMessage @user, @OperTime, @descr, null, @document, 'Договор', @hostName, 'Delete'
   end
end;

GO

CREATE OR ALTER trigger [sbyt].[trig_Договор_LOG_INS] on [sbyt].[Договор] after insert as begin
   set NOCOUNT on;

   declare @descr varchar(768),
           @document int,
           @rec_info varchar(256);

      select @rec_info = sbyt.atoa( [Номер] ) + ' от ' + sbyt.dtoa( [Начало_договора] )
      from inserted;

      select
         @descr =
			sbyt.itoa( [ROW_ID] ) + ';' +
	        sbyt.atoa( (select [Название] from [Организации]
                         where ROW_ID = inserted.[Плательщик_ИД]) ) + ';' +
            sbyt.atoa( (select [Название] from [Организации]
                         where ROW_ID = inserted.[Грузополучатель_ИД]) ) + ';' +
            sbyt.atoa( (select [Название] from [Классификаторы]
                         where ROW_ID = inserted.[Бюджет_ИД]) ) + ';' +
            sbyt.atoa( (select [Название] from [Классификаторы]
                         where ROW_ID = inserted.[Отрасль_ИД]) ) + ';' +
            sbyt.atoa( (select [Название] from [Классификаторы]
                         where ROW_ID = inserted.[Категория_ИД]) ) + ';' +
            sbyt.dtoa( [Начало_договора] ) + ';' +
            sbyt.dtoa( [Окончание_договора] ) + ';' +
            sbyt.atoa( [Примечание] ) + ';' +
            sbyt.itoa( [Тип_договора] ) + ';',
			@document = ROW_ID
	 from inserted;

     set @descr = 'Добавлен договор (' + @rec_info + '): ' + @descr;

		 DECLARE @OperTime datetime2, @hostName nvarchar(256), @user nvarchar(256);
		 SET @hostName = host_name();
		 SET @OperTime = current_timestamp;
		 SET @user = SYSTEM_USER;

      execute sbyt.proc_write_journal_SB_SendMessage @user, @OperTime, @descr, null, @document, 'Договор', @hostName, 'Insert'
end;

GO

CREATE OR ALTER trigger [sbyt].[trig_Договор_LOG_UPD] on [sbyt].[Договор] after update as begin
   set NOCOUNT on;

   declare @descr varchar(1000),
           @document int,
           @rec_info varchar(256);


      select @rec_info = sbyt.atoa( [Номер] ) + ' от ' + sbyt.dtoa( [Начало_договора] ) 
	  from deleted;

      select
         @descr =
            case when sbyt.IsDistinct(inserted.[Номер], deleted.[Номер]) = 1 then
               '->(' + sbyt.atoa( (select [Номер] from inserted) ) + ');'
            else '' end +

            case when sbyt.IsDistinct(inserted.[Плательщик_ИД], deleted.[Плательщик_ИД]) = 1 then
               '"Плательщик" ' + sbyt.atoa( (select [Название] from [Организации]
                                              where ROW_ID = deleted.[Плательщик_ИД]) ) +
               '->' + sbyt.atoa( (select [Название] from [Организации]
                                   where ROW_ID = inserted.[Плательщик_ИД]) ) + ';'
            else '' end +

            case when sbyt.IsDistinct(inserted.[Грузополучатель_ИД], deleted.[Грузополучатель_ИД]) = 1 then
               '"Грузополучатель" ' + sbyt.atoa( (select [Название] from [Организации]
                                                   where ROW_ID = deleted.[Грузополучатель_ИД]) ) +
               '->' + sbyt.atoa( (select [Название] from [Организации]
                                   where ROW_ID = inserted.[Грузополучатель_ИД]) ) + ';'
            else '' end +

            case when sbyt.IsDistinct(inserted.[Бюджет_ИД], deleted.[Бюджет_ИД]) = 1 then
               '"Бюджет" ' + sbyt.atoa( (select [Название] from [Классификаторы]
                                                   where ROW_ID = deleted.[Бюджет_ИД]) ) +
               '->' + sbyt.atoa( (select [Название] from [Классификаторы]
                                   where ROW_ID = inserted.[Бюджет_ИД]) ) + ';'
            else '' end +

			case when sbyt.IsDistinct(inserted.[Отрасль_ИД], deleted.[Отрасль_ИД]) = 1 then
               '"Отрасль" ' + sbyt.atoa( (select [Название] from [Классификаторы]
                                                    where ROW_ID = deleted.[Отрасль_ИД]) ) +
               '->' + sbyt.atoa( (select [Название] from [Классификаторы]
                                   where ROW_ID = inserted.[Отрасль_ИД]) ) + ';'
            else '' end +

			case when sbyt.IsDistinct(inserted.[Категория_ИД], deleted.[Категория_ИД]) = 1 then
               '"Категория" ' + sbyt.atoa( (select [Название] from [Классификаторы]
                                                   where ROW_ID = deleted.[Категория_ИД]) ) +
               '->' + sbyt.atoa( (select [Название] from [Классификаторы]
                                   where ROW_ID = inserted.[Категория_ИД]) ) + ';'
            else '' end +
			            
            case when sbyt.IsDistinct(inserted.[Начало_договора], deleted.[Начало_договора]) = 1 then
               '"Начало договора" ' + sbyt.dtoa( deleted.[Начало_договора] ) +
               '->' + sbyt.dtoa( inserted.[Начало_договора] ) + ';'
            else '' end +

            case when sbyt.IsDistinct(inserted.[Окончание_договора], deleted.[Окончание_договора]) = 1 then
               '"Окончание" ' + sbyt.dtoa( deleted.[Окончание_договора] ) +
               '->' + sbyt.dtoa( inserted.[Окончание_договора] ) + ';'
            else '' end +

            case when sbyt.IsDistinct(inserted.[Примечание], deleted.[Примечание]) = 1 then
               '"Примечание" ' + sbyt.atoa( deleted.[Примечание] ) +
               '->' + sbyt.atoa( inserted.[Примечание] ) + ';'
            else '' end +

            case when sbyt.IsDistinct(inserted.[Тип_договора], deleted.[Тип_договора]) = 1 then
               '"Тип договора" ' + sbyt.atoa( deleted.[Тип_договора] ) +
               '->' + sbyt.atoa( inserted.[Тип_договора] ) + ';'
            else '' end,

         @document = deleted.ROW_ID
      from deleted, inserted
      where deleted.ROW_ID = inserted.ROW_ID;

   -- если произошло обновление, но значения нужных полей не изменились,
   -- то ничего не делаем
   if (len( @descr ) <> 0) begin
         set @descr = 'Изменен договор (' + @rec_info + '): ' + @descr;

		 DECLARE @OperTime datetime2, @hostName nvarchar(256), @user nvarchar(256);
		 SET @hostName = host_name();
		 SET @OperTime = current_timestamp;
		 SET @user = SYSTEM_USER;

      execute sbyt.proc_write_journal_SB_SendMessage @user, @OperTime, @descr, null, @document, 'Договор', @hostName, 'Update'
   end
end;

GO

--------------------------
--Таблица: Лицевые счета--
--------------------------

CREATE OR ALTER trigger sbyt.[trig_Лицевые_счета_LOG_INS] on [sbyt].[Лицевые_счета] after insert as begin
   set NOCOUNT on;

   declare @descr varchar(1000),
           @account int;

   declare @OperTime datetime2, @hostName nvarchar(256), @user nvarchar(256);
	   set @hostName = host_name();
	   set @user = SYSTEM_USER;

   select
      @descr =
         sbyt.itoa( [Номер] ) + ';' +
		 sbyt.atoa( [Адрес] ) + ';' +
		 sbyt.atoa( [Примечание] ), 
      @account = ROW_ID
   from inserted;

   set @descr = 'Добавлен лицевой счет: ' + @descr;
   set @OperTime = current_timestamp;
	
   execute sbyt.proc_write_journal_SB_SendMessage @user, @OperTime, @descr, @account, null, 'Лицевые_счета', @hostName, 'Insert'
end;

GO

CREATE OR ALTER trigger sbyt.[trig_Лицевые_счета_LOG_DEL] on [sbyt].[Лицевые_счета] after delete as begin
   set NOCOUNT on;

   -- если ничего не удалено, то ничего не делаем
   declare @row_count int;
   select @row_count = count( * ) from deleted;

   if (@row_count <> 0) begin
	  declare @OperTime datetime2, @hostName nvarchar(256), @user nvarchar(256);
	  set @hostName = host_name();
	  set @user = SYSTEM_USER;

      declare @descr varchar(1000);
      declare @account int;

      select @descr =	 sbyt.itoa( [Номер] ) + ';' +
						 sbyt.atoa( [Адрес] ) + ';' +
						 sbyt.atoa( [Примечание] ), 
			 @account = ROW_ID
      from deleted;

      set @descr = 'Удален лицевой счет: ' + @descr;
	  set @OperTime = current_timestamp;
	
      execute sbyt.proc_write_journal_SB_SendMessage @user, @OperTime, @descr, @account, null, 'Лицевые_счета', @hostName, 'Delete'
   end
end;

GO

CREATE OR ALTER TRIGGER sbyt.[trig_Лицевые_счета_LOG_UPD] ON sbyt.[Лицевые_счета] AFTER UPDATE AS 
BEGIN
   SET NOCOUNT ON;
   
   declare @row_count int;
   SELECT @row_count = count( * ) FROM inserted;
   declare @descr varchar(1000),
           @account int 

   declare @OperTime datetime2, @hostName nvarchar(256), @user nvarchar(256);
	   set @hostName = host_name();
	   set @user = SYSTEM_USER;
 
   IF( @row_count > 0 )    
   BEGIN
      DECLARE UpdCurr CURSOR LOCAL FOR 
      SELECT
         (
            case when sbyt.IsDistinct(inserted.[Номер], deleted.[Номер]) = 1 then
                  '"Номер" ' + sbyt.itoa( deleted.[Номер] ) +
                  '->' + sbyt.itoa( inserted.[Номер] ) + ';'
            else '' end +

			case when sbyt.IsDistinct(inserted.Адрес, deleted.Адрес) = 1 then
                  '"Адрес" ' + sbyt.atoa( deleted.Адрес ) +
                  '->' + sbyt.atoa( inserted.Адрес ) + ';'
            else '' end +
            
            case when sbyt.IsDistinct(inserted.[Примечание], deleted.[Примечание]) = 1 then
                  '"Примечание" ' + sbyt.atoa( deleted.[Примечание] ) +
                  '->' + sbyt.atoa( inserted.[Примечание] ) + ';'
            else '' end 
         ) AS descr ,
         deleted.ROW_ID AS account
      FROM deleted, inserted
      WHERE deleted.ROW_ID = inserted.ROW_ID;
   
      OPEN UpdCurr
      FETCH NEXT FROM UpdCurr INTO @descr, @account
      WHILE @@fetch_status = 0 
      BEGIN       
        IF (len( @descr ) <> 0) 
        BEGIN

          set @descr = 'Изменен лицевой счет: ' + @descr;
		  set @OperTime = current_timestamp;
	      execute sbyt.proc_write_journal_SB_SendMessage @user, @OperTime, @descr, @account, null, 'Лицевые_счета', @hostName, 'Update'

        END
        FETCH NEXT FROM UpdCurr INTO @descr, @account
      END
     
      CLOSE UpdCurr
      DEALLOCATE UpdCurr
   
   END
END