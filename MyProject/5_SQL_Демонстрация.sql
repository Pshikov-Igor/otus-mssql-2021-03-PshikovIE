-------------------
--Посмотрим итоги--
-------------------
Declare @d date = getdate();

--Посмотрим информацию по договору на текущий момент времени
Declare @prID int	= (Select top 1 k.Row_ID from sbyt.[Классификаторы] k Where k.Тип = 7 and k.Название = 'Площадь помещения')

Select org.ИНН, org.КПП, org.Название, dg.Номер as НомерДоговора, dg.Начало_договора as ДатаДоговора, ls.Номер as НомерЛС, ls.Адрес,
	   ISNULL(sv.Значение, 0)	as ПлощадьПомещения, 
	   ISNULL(nom.Наименование,'') МодельПрибора, 
	   ISNULL(so.Заводской_номер,'') as ЗаводскойНомер
		 from Sbyt.Организации org
		 join Sbyt.Договор dg			on dg.Плательщик_ИД = org.Row_ID
		 join Sbyt.Лицевые_договора Ld	on ld.Договор_ИД = dg.Row_ID
		 join Sbyt.Лицевые_счета Ls		on ld.Лицевой_ИД = ls.Row_ID
	left join Sbyt.Свойства sv			on sv.Параметры_Счет = ls.Row_ID
										  and (@d between sv.ДатНач and sv.ДатКнц)	
										  and sv.Виды_Параметры = @prID
	left join Sbyt.[Список_объектов] so	on so.Объекты_Счет = ls.Row_ID
	left join Sbyt.Номенклатура nom		on so.Номенклатура_Объекты = nom.Row_ID
Where org.ИНН = '1111111111' and @d between ld.ДатНач and ld.ДатКнц

--Ведомость показаний счетчиков
;With PokazanieCTE as ( 
						Select ps.Объект_Показание, max(ps.Дата) as Дата from Sbyt.Показания_счетчиков ps
						group by ps.Объект_Показание
					  )

Select dg.Номер as НомерДоговора, dg.Начало_договора as ДатаДоговора, ls.Номер, ls.Адрес, ls.Примечание as МестоУстановки,
	 so.Заводской_номер			as ЗаводскойНомер, 
	 p.Расчетный_месяц			as МесяцРасчета,			
	 p.Показание				as ТекущиеПоказания, 
	 p.Дополнительный_расход	as ДополнительныйРасходТрансформатораТока,
	 p.Итоговый_расход			as ИтоговыйРасход
		 from sbyt.Лицевые_счета ls
		 join sbyt.Лицевые_договора ld on ld.Лицевой_ИД = ls.Row_ID
		 join sbyt.Договор dg on ld.Договор_ИД = dg.Row_ID
		 join sbyt.Список_объектов so on ld.Лицевой_ИД = so.Объекты_Счет
		 join PokazanieCTE pok on pok.Объект_Показание = so.Row_ID
		 join Sbyt.Показания_счетчиков p on pok.Объект_Показание = p.Объект_Показание
												and p.Дата = pok.Дата
Where @d between ld.ДатНач and ld.ДатКнц -- Действующие лицевые счета

--Начисления и Платежи в текущем месяце
Select org.Наименование, dg.Номер as НомерДоговора,dg.Начало_договора as ДатаДоговора,
	   doc.Наименование, doc.Номер as НомерДокумента, doc.Дата as ДатаДокумента, doc.СуммаСНДС as Сумма, 
		 case 
				When doc.Количество > 0 Then cast(doc.Количество as nvarchar)
				else ''
		 end  as Количество
		 from sbyt.Документ doc
		 join sbyt.Классификаторы td on td.Row_ID = doc.Тип_документа
		 join Sbyt.Организации org on org.Row_ID = doc.Плательщик_ИД
		 join Sbyt.Договор dg on dg.Row_ID = doc.Документ_Договор
Where year(doc.Дата) = year(@d) and month(doc.Дата) = month(@d) 
	  and doc.Тип_документа in (24,25)


-------------------------------------------------------------------------------------------------------------------

---------------------------
--Секционирование таблицы--
---------------------------

 --Таблицы созданы
 --смотрим какие таблицы у нас партиционированы
select distinct t.name as PartitionalTable
from sys.partitions p
inner join sys.tables t
	on p.object_id = t.object_id
where p.partition_number <> 1

SELECT $PARTITION.fnJournalOperationsPartition(Дата) AS Partition, COUNT(*) AS [COUNT], MIN(Дата) as MinDate ,MAX(Дата) as MaxDate
FROM Sbyt.Журнал_изменений
GROUP BY $PARTITION.fnJournalOperationsPartition(Дата) 
ORDER BY Partition;  

--В моем случае секционирование немного выигрывает, предполагается, что таблица будет быстро рости, на больших объемах разница в скорости, по сравнению с обычной таблицей, должна увеличится

-------------------
--Service Brocker--
-------------------

--Проверим очереди
SELECT CAST(message_body AS XML),*
FROM sbyt.TargetQueueSbyt;

SELECT CAST(message_body AS XML),*
FROM sbyt.InitiatorQueueSbyt;

--Просмотр открытых диалогов
SELECT conversation_handle, is_initiator, s.name as 'local service', 
far_service, sc.name 'contract', ce.state_desc
FROM sys.conversation_endpoints ce
LEFT JOIN sys.services s
ON ce.service_id = s.service_id
LEFT JOIN sys.service_contracts sc
ON ce.service_contract_id = sc.service_contract_id
ORDER BY conversation_handle;

/*
--!проверим ручками, что все работает
--Target
EXEC sbyt.proc_write_journal_SB_GetMessage;

--Initiator
EXEC sbyt.proc_write_journal_SB_ConfirmMessage;
*/

Select j.*,p.Фамилия,p.Имя,p.Отчество, p.Отдел from Sbyt.Журнал_изменений j
		 join sbyt.Пользователи p on p.Row_ID = j.Журнал_Пользователь
Where year(j.Дата) = 2021

----------------------------------------------------------------------------
--Посмотрим изменение журнала
----------------------------------------------------------------------------

Declare @orgID int		= (Select top 1 o.Row_ID from Sbyt.Организации o where o.ИНН = '1111111111' and o.КПП = '2222222222')
Declare @tipDogID int	= (Select top 1 kl.Row_ID 
						   from Sbyt.Классификаторы kl 
						   join Sbyt.Типы_классификатора tkl on kl.Тип = tkl.Row_ID
						   Where tkl.Название = 'Типы договоров' and kl.Папки_Add = 0 and kl.Название = 'Договор купли-продажи')
Declare @katID int		= (Select top 1 kl.Row_ID 
						   from Sbyt.Классификаторы kl 
						   join Sbyt.Типы_классификатора tkl on kl.Тип = tkl.Row_ID
						   Where tkl.Название = 'Категории' and kl.Папки_Add = 0 and kl.Название = 'Промышленность')
Declare @otrID int		= (Select top 1 kl.Row_ID 
						   from Sbyt.Классификаторы kl 
						   join Sbyt.Типы_классификатора tkl on kl.Тип = tkl.Row_ID
						   Where tkl.Название = 'Отрасль' and kl.Папки_Add = 0 and kl.Название = 'Деятельность в области спорта')

INSERT INTO [Sbyt].[Договор]
           ([Номер],[Плательщик_ИД],[Грузополучатель_ИД],[Начало_договора],[Тип_договора],[Категория_ИД],[Отрасль_ИД],[Бюджет_ИД],[Примечание])
     VALUES
           ('202108\11',@orgID,@orgID,'20210801',@tipDogID,@katID,@otrID,null,'Демонстрационный договор')
GO


Select * from sbyt.Договор

update d
set d.Номер = '202108\12',
	d.Грузополучатель_ИД = 6,
	d.Категория_ИД = (Select top 1 kl.Row_ID 
						   from Sbyt.Классификаторы kl 
						   join Sbyt.Типы_классификатора tkl on kl.Тип = tkl.Row_ID
						   Where tkl.Название = 'Категории' and kl.Папки_Add = 0 and kl.Название = 'Непромышленные и приравненные к ним потребители')
from sbyt.Договор d
where Номер = '202108\11'

Delete from sbyt.Договор 
where  Номер = '202108\12'

--Посмотрим журнал
Select j.*,p.Фамилия,p.Имя,p.Отчество, p.Отдел from Sbyt.Журнал_изменений j
		 join sbyt.Пользователи p on p.Row_ID = j.Журнал_Пользователь
Where year(j.Дата) = 2021
order by j.Дата desc



-------------------------------------
--Лицевые счета
-------------------------------------

INSERT INTO [Sbyt].[Лицевые_счета]
           ([Номер],[Адрес],[Примечание])
     VALUES  (10000099,'г. Саранск, ул Ленина , д 1 пом. 1','Демонстрационный ЛС')

		   
Select * from sbyt.Лицевые_счета

update ls
set ls.Примечание = 'Тамбур',
	ls.Адрес = 'г. Саранск, ул Ленина , д 1 пом. 2'
from sbyt.Лицевые_счета ls
where  Номер = 10000099

Delete from sbyt.Лицевые_счета 
where Номер = 10000099

Select j.*,p.Фамилия,p.Имя,p.Отчество, p.Отдел from Sbyt.Журнал_изменений j
		 join sbyt.Пользователи p on p.Row_ID = j.Журнал_Пользователь
Where year(j.Дата) = 2021 and Таблица = 'Лицевые_счета'
order by j.Дата desc

-------------------------------------------------
--Убедимся еще раз что все отработало корректно--
-------------------------------------------------

SELECT CAST(message_body AS XML),*
FROM sbyt.TargetQueueSbyt;

SELECT CAST(message_body AS XML),*
FROM sbyt.InitiatorQueueSbyt;

--Просмотр открытых диалогов
SELECT conversation_handle, is_initiator, s.name as 'local service', 
far_service, sc.name 'contract', ce.state_desc
FROM sys.conversation_endpoints ce
LEFT JOIN sys.services s
ON ce.service_id = s.service_id
LEFT JOIN sys.service_contracts sc
ON ce.service_contract_id = sc.service_contract_id
ORDER BY conversation_handle;
