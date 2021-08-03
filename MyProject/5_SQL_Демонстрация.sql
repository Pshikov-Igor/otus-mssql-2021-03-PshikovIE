-------------------
--��������� �����--
-------------------
Declare @d date = getdate();

--��������� ���������� �� �������� �� ������� ������ �������
Declare @prID int	= (Select top 1 k.Row_ID from sbyt.[��������������] k Where k.��� = 7 and k.�������� = '������� ���������')

Select org.���, org.���, org.��������, dg.����� as �������������, dg.������_�������� as ������������, ls.����� as �������, ls.�����,
	   ISNULL(sv.��������, 0)	as ����������������, 
	   ISNULL(nom.������������,'') �������������, 
	   ISNULL(so.���������_�����,'') as ��������������
		 from Sbyt.����������� org
		 join Sbyt.������� dg			on dg.����������_�� = org.Row_ID
		 join Sbyt.�������_�������� Ld	on ld.�������_�� = dg.Row_ID
		 join Sbyt.�������_����� Ls		on ld.�������_�� = ls.Row_ID
	left join Sbyt.�������� sv			on sv.���������_���� = ls.Row_ID
										  and (@d between sv.������ and sv.������)	
										  and sv.����_��������� = @prID
	left join Sbyt.[������_��������] so	on so.�������_���� = ls.Row_ID
	left join Sbyt.������������ nom		on so.������������_������� = nom.Row_ID
Where org.��� = '1111111111' and @d between ld.������ and ld.������

--��������� ��������� ���������
;With PokazanieCTE as ( 
						Select ps.������_���������, max(ps.����) as ���� from Sbyt.���������_��������� ps
						group by ps.������_���������
					  )

Select dg.����� as �������������, dg.������_�������� as ������������, ls.�����, ls.�����, ls.���������� as ��������������,
	 so.���������_�����			as ��������������, 
	 p.���������_�����			as ������������,			
	 p.���������				as ����������������, 
	 p.��������������_������	as ��������������������������������������,
	 p.��������_������			as ��������������
		 from sbyt.�������_����� ls
		 join sbyt.�������_�������� ld on ld.�������_�� = ls.Row_ID
		 join sbyt.������� dg on ld.�������_�� = dg.Row_ID
		 join sbyt.������_�������� so on ld.�������_�� = so.�������_����
		 join PokazanieCTE pok on pok.������_��������� = so.Row_ID
		 join Sbyt.���������_��������� p on pok.������_��������� = p.������_���������
												and p.���� = pok.����
Where @d between ld.������ and ld.������ -- ����������� ������� �����

--���������� � ������� � ������� ������
Select org.������������, dg.����� as �������������,dg.������_�������� as ������������,
	   doc.������������, doc.����� as ��������������, doc.���� as �������������, doc.��������� as �����, 
		 case 
				When doc.���������� > 0 Then cast(doc.���������� as nvarchar)
				else ''
		 end  as ����������
		 from sbyt.�������� doc
		 join sbyt.�������������� td on td.Row_ID = doc.���_���������
		 join Sbyt.����������� org on org.Row_ID = doc.����������_��
		 join Sbyt.������� dg on dg.Row_ID = doc.��������_�������
Where year(doc.����) = year(@d) and month(doc.����) = month(@d) 
	  and doc.���_��������� in (24,25)


-------------------------------------------------------------------------------------------------------------------

---------------------------
--��������������� �������--
---------------------------

 --������� �������
 --������� ����� ������� � ��� ����������������
select distinct t.name as PartitionalTable
from sys.partitions p
inner join sys.tables t
	on p.object_id = t.object_id
where p.partition_number <> 1

SELECT $PARTITION.fnJournalOperationsPartition(����) AS Partition, COUNT(*) AS [COUNT], MIN(����) as MinDate ,MAX(����) as MaxDate
FROM Sbyt.������_���������
GROUP BY $PARTITION.fnJournalOperationsPartition(����) 
ORDER BY Partition;  

--� ���� ������ ��������������� ������� ����������, ��������������, ��� ������� ����� ������ �����, �� ������� ������� ������� � ��������, �� ��������� � ������� ��������, ������ ����������

-------------------
--Service Brocker--
-------------------

--�������� �������
SELECT CAST(message_body AS XML),*
FROM sbyt.TargetQueueSbyt;

SELECT CAST(message_body AS XML),*
FROM sbyt.InitiatorQueueSbyt;

--�������� �������� ��������
SELECT conversation_handle, is_initiator, s.name as 'local service', 
far_service, sc.name 'contract', ce.state_desc
FROM sys.conversation_endpoints ce
LEFT JOIN sys.services s
ON ce.service_id = s.service_id
LEFT JOIN sys.service_contracts sc
ON ce.service_contract_id = sc.service_contract_id
ORDER BY conversation_handle;

/*
--!�������� �������, ��� ��� ��������
--Target
EXEC sbyt.proc_write_journal_SB_GetMessage;

--Initiator
EXEC sbyt.proc_write_journal_SB_ConfirmMessage;
*/

Select j.*,p.�������,p.���,p.��������, p.����� from Sbyt.������_��������� j
		 join sbyt.������������ p on p.Row_ID = j.������_������������
Where year(j.����) = 2021

----------------------------------------------------------------------------
--��������� ��������� �������
----------------------------------------------------------------------------

Declare @orgID int		= (Select top 1 o.Row_ID from Sbyt.����������� o where o.��� = '1111111111' and o.��� = '2222222222')
Declare @tipDogID int	= (Select top 1 kl.Row_ID 
						   from Sbyt.�������������� kl 
						   join Sbyt.����_�������������� tkl on kl.��� = tkl.Row_ID
						   Where tkl.�������� = '���� ���������' and kl.�����_Add = 0 and kl.�������� = '������� �����-�������')
Declare @katID int		= (Select top 1 kl.Row_ID 
						   from Sbyt.�������������� kl 
						   join Sbyt.����_�������������� tkl on kl.��� = tkl.Row_ID
						   Where tkl.�������� = '���������' and kl.�����_Add = 0 and kl.�������� = '��������������')
Declare @otrID int		= (Select top 1 kl.Row_ID 
						   from Sbyt.�������������� kl 
						   join Sbyt.����_�������������� tkl on kl.��� = tkl.Row_ID
						   Where tkl.�������� = '�������' and kl.�����_Add = 0 and kl.�������� = '������������ � ������� ������')

INSERT INTO [Sbyt].[�������]
           ([�����],[����������_��],[���������������_��],[������_��������],[���_��������],[���������_��],[�������_��],[������_��],[����������])
     VALUES
           ('202108\11',@orgID,@orgID,'20210801',@tipDogID,@katID,@otrID,null,'���������������� �������')
GO


Select * from sbyt.�������

update d
set d.����� = '202108\12',
	d.���������������_�� = 6,
	d.���������_�� = (Select top 1 kl.Row_ID 
						   from Sbyt.�������������� kl 
						   join Sbyt.����_�������������� tkl on kl.��� = tkl.Row_ID
						   Where tkl.�������� = '���������' and kl.�����_Add = 0 and kl.�������� = '�������������� � ������������ � ��� �����������')
from sbyt.������� d
where ����� = '202108\11'

Delete from sbyt.������� 
where  ����� = '202108\12'

--��������� ������
Select j.*,p.�������,p.���,p.��������, p.����� from Sbyt.������_��������� j
		 join sbyt.������������ p on p.Row_ID = j.������_������������
Where year(j.����) = 2021
order by j.���� desc



-------------------------------------
--������� �����
-------------------------------------

INSERT INTO [Sbyt].[�������_�����]
           ([�����],[�����],[����������])
     VALUES  (10000099,'�. �������, �� ������ , � 1 ���. 1','���������������� ��')

		   
Select * from sbyt.�������_�����

update ls
set ls.���������� = '������',
	ls.����� = '�. �������, �� ������ , � 1 ���. 2'
from sbyt.�������_����� ls
where  ����� = 10000099

Delete from sbyt.�������_����� 
where ����� = 10000099

Select j.*,p.�������,p.���,p.��������, p.����� from Sbyt.������_��������� j
		 join sbyt.������������ p on p.Row_ID = j.������_������������
Where year(j.����) = 2021 and ������� = '�������_�����'
order by j.���� desc

-------------------------------------------------
--�������� ��� ��� ��� ��� ���������� ���������--
-------------------------------------------------

SELECT CAST(message_body AS XML),*
FROM sbyt.TargetQueueSbyt;

SELECT CAST(message_body AS XML),*
FROM sbyt.InitiatorQueueSbyt;

--�������� �������� ��������
SELECT conversation_handle, is_initiator, s.name as 'local service', 
far_service, sc.name 'contract', ce.state_desc
FROM sys.conversation_endpoints ce
LEFT JOIN sys.services s
ON ce.service_id = s.service_id
LEFT JOIN sys.service_contracts sc
ON ce.service_contract_id = sc.service_contract_id
ORDER BY conversation_handle;
