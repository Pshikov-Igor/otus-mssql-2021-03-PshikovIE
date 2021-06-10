USE [Project_Sbyt]
GO

-------------------------------------
--������������ �������� �����������--
-------------------------------------

INSERT INTO [sbyt].[����_��������������]
           ([�����],[�����_Add],[��������])
     VALUES
           (null,0,'���� ���������'),
		   (null,0,'���������'),
		   (null,0,'�������'),
		   (null,0,'������'),
		   (null,0,'���� ���������'),
		   (null,0,'���� ����������'),
		   (null,0,'���� ����������')
GO

--Delete select * from [sbyt].[��������������]

------------------
--���� ���������--
------------------
INSERT INTO [sbyt].[��������������]
           ([���],[�����],[�����_Add],[���],[��������],[����������])
     VALUES
           (1,null,1,null,'���� ���������','�����')
GO

Declare @kl int = (Select top 1 Row_ID from sbyt.[��������������] Where [��������] = '���� ���������');

INSERT INTO [sbyt].[��������������]
           ([���],[�����],[�����_Add],[���],[��������],[����������])
     VALUES
           (1,@kl,0,null,'������� ���������������',''),
		   (1,@kl,0,null,'������� �����-�������',''),
		   (1,@kl,0,null,'������� ������������� �����','')
GO

------------------
--���������--
------------------
INSERT INTO [sbyt].[��������������]
           ([���],[�����],[�����_Add],[���],[��������],[����������])
     VALUES
           (2,null,1,null,'���������','�����')
GO

Declare @kl int = (Select top 1 Row_ID from sbyt.[��������������] Where [��������] = '���������');

INSERT INTO [sbyt].[��������������]
           ([���],[�����],[�����_Add],[���],[��������],[����������])
     VALUES
           (2,@kl,0,null,'���������',''),
		   (2,@kl,0,null,'��������������',''),
		   (2,@kl,0,null,'�������������� � ������������ � ��� �����������','')
GO

------------------
--�������--
------------------
INSERT INTO [sbyt].[��������������]
           ([���],[�����],[�����_Add],[���],[��������],[����������])
     VALUES
           (3,null,1,null,'�������','�����')
GO

Declare @kl int = (Select top 1 Row_ID from sbyt.[��������������] Where [��������] = '�������');

INSERT INTO [sbyt].[��������������]
           ([���],[�����],[�����_Add],[���],[��������],[����������])
     VALUES
           (3,@kl,0,null,'������ �����������',''),
		   (3,@kl,0,null,'������������ � ������� ���������������',''),
		   (3,@kl,0,null,'������������ � ������� ������','')
GO

------------------
--������--
------------------
INSERT INTO [sbyt].[��������������]
           ([���],[�����],[�����_Add],[���],[��������],[����������])
     VALUES
           (4,null,1,null,'������','�����')
GO

Declare @kl int = (Select top 1 Row_ID from sbyt.[��������������] Where [��������] = '������');

INSERT INTO [sbyt].[��������������]
           ([���],[�����],[�����_Add],[���],[��������],[����������])
     VALUES
           (4,@kl,0,null,'����������� ������',''),
		   (4,@kl,0,null,'��������� ������',''),
		   (4,@kl,0,null,'������������� ������','')
GO

------------------
--���� ���������--
------------------
INSERT INTO [sbyt].[��������������]
           ([���],[�����],[�����_Add],[���],[��������],[����������])
     VALUES
           (5,null,1,null,'���� ���������','�����')
GO

Declare @kl int = (Select top 1 Row_ID from sbyt.[��������������] Where [��������] = '���� ���������');

INSERT INTO [sbyt].[��������������]
           ([���],[�����],[�����_Add],[���],[��������],[����������])
     VALUES
           (5,@kl,0,null,'��',''),
		   (5,@kl,0,null,'��',''),
		   (5,@kl,0,null,'��','')
GO

------------------
--���� ����������--
------------------
INSERT INTO [sbyt].[��������������]
           ([���],[�����],[�����_Add],[���],[��������],[����������])
     VALUES
           (6,null,1,null,'���� ����������','�����')
GO

Declare @kl int = (Select top 1 Row_ID from sbyt.[��������������] Where [��������] = '���� ����������');

INSERT INTO [sbyt].[��������������]
           ([���],[�����],[�����_Add],[���],[��������],[����������])
     VALUES
           (6,@kl,0,null,'����-�������',''),
		   (6,@kl,0,null,'���',''),
		   (6,@kl,0,null,'����','')
GO

------------------
--���� ����������--
------------------
INSERT INTO [sbyt].[��������������]
           ([���],[�����],[�����_Add],[���],[��������],[����������])
     VALUES
           (7,null,1,null,'���� ����������','�����')
GO

Declare @kl int = (Select top 1 Row_ID from sbyt.[��������������] Where [��������] = '���� ����������');

INSERT INTO [sbyt].[��������������]
           ([���],[�����],[�����_Add],[���],[��������],[����������])
     VALUES
           (7,@kl,0,null,'������� ���������� ���',''),
		   (7,@kl,0,null,'�������� ���� �� ������ ������ � �������� ����������',''),
		   (7,@kl,0,null,'�������� �����������',''),
		   (7,@kl,0,null,'��� ��������� ����������',''),
		   (7,@kl,0,null,'������� ���������',''),
		   (7,@kl,0,null,'��������� ���������� �����������','')
GO

--Select * from sbyt.[��������������]

-----------------
---������������--
-----------------
INSERT INTO [Sbyt].[������������]
           ([������������],[�����������_��������],[�����������],[�������_�����������],[�����_������������])
     VALUES
           ('������-32-��-W32',10,6,2,'��� �������-����������'),
		   ('������-12-��-W3',10,6,2,'��� �������-����������'),
		   ('�������� 201.7',10,5,1,'��� ���������-�ʻ'),
		   ('�������� 230 AM',8,5,1,'��� ���������-�ʻ')
GO


--Select * from sbyt.������������

-----------------
---�����������---
-----------------
INSERT INTO [Sbyt].[�����������]
           ([���],[���],[����],[��������],[������������],[���_�����������],[�����������_�����],[�����������_�����],[��������],[�����],[����������])
     VALUES
           ('1234567890','1234567800','1234567890123','����������� �1','������ �������� ����������� �1',1,'���������� ��������, ����� �������, ����� ������, ��� 1'
           ,'���������� ��������, ����� �������, ����� ������, ��� 1','+78342270000,+78342270099','test123@yandex.ru',''),
		   ('2234567890','2234567800','2234567890123','����������� �2','������ �������� ����������� �2',1,'���������� ��������, ����� �������, ����� ������, ��� 47'
           ,'���������� ��������, ����� �������, ����� ������, ��� 47','88342271000,88342271099','test222@mail.ru','�������������� �����������'),
		   ('3234567890','3234567800','3234567890123','����������� �3','������ �������� ����������� �3',1,'���������� ��������, ����� �������, ����� ���������, ��� 31'
           ,'���������� ��������, ����� �������, ����� ���������, ��� 31','88342283000','test333@rambler.ru',''),
		   ('123456789012','','','�� ������ �.�.','�������������� ��������������� ������ ���� ��������',0,'�. �������, ��. ��������, �. 20'
           ,'�. �������, ��. ��������, �. 20','89173992525','ivanov@yandex.ru',''),
		   ('123456789021','','','�� ������� �.�.','�������������� ��������������� ������� ������ ��������',0,'�. �������, ��. ����������������, �. 41'
           ,'�. �������, ��. ����������������, �. 41','89173992500','sidorov@yandex.ru','�������� ������������'),
		   ('4234567890','4234567800','','����������� �4','������ �������� ����������� �4',1,'�. �������, ��. ���������, �. 101'
           ,'�. �������, ��. ���������, �. 101','88342283000','test444@rambler.ru','')
GO

--Select * from sbyt.�����������

-----------------
---������������---
-----------------

INSERT INTO [Sbyt].[������������]
           ([�����],[������],[�������],[���],[��������],[�����])
     VALUES
           ('SuperAdmin','','������','�����','����������','����� ��������������� �������������'),
		   ('m.ivanova','','�������','�����','��������','�����������')
GO

--Select * from sbyt.������������


---------------------------
--�������� ������ �������--
---------------------------

--�����������
INSERT INTO [Sbyt].[�����������]
           ([���],[���],[����],[��������],[������������],[���_�����������],[�����������_�����],[�����������_�����],[��������],[�����],[����������])
	 OUTPUT inserted.*
     VALUES
           ('1111111111','2222222222','1034567890123','��� ���� � ������','�������� � ������������ ���������������� "���� � ������"',1,
		   '���������� ��������, ����� �������, ����� ������, ��� 31','���������� ��������, ����� �������, ����� ������, ��� 31','8342270001','RogaIKopyta@yandex.ru','���������� ���� �� ���������� �������� ������� �.�. ��� 477735')
	
GO

--������������� ��������� �� �����������, ���� ��� ����������
Declare @orgID int		= (Select top 1 o.Row_ID from Sbyt.����������� o where o.��� = '1111111111' and o.��� = '2222222222')
Declare @prID int		= (Select top 1 k.Row_ID from sbyt.[��������������] k Where k.��� = 7 and k.�������� = '������� ���������� ���')

INSERT INTO [Sbyt].[��������]
           ([����_���������],[���������_����],[���������_�������],[���������_�����������],[������],[��������],[����������])
     VALUES
           (@prID,null,null,@orgID,GetDate(),1,'����')
GO

--������� �������
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
           ([�����],[����������],[���������������],[������_��������],[���_��������],[���������_��],[�������_��],[������_��],[����������])
     VALUES
           ('20210601\1',@orgID,@orgID,'20210101',@tipDogID,@katID,@otrID,null,'���������� ������������ ��� ��������� ��������')
GO

--������� ��������� �� �������
Declare @dogID int	= (Select top 1 d.Row_ID from Sbyt.������� d where d.����� = '20210601\1');
Declare @prID1 int	= (Select top 1 k.Row_ID from sbyt.[��������������] k Where k.��� = 7 and k.�������� = '�������� ���� �� ������ ������ � �������� ����������')
Declare @prID2 int	= (Select top 1 k.Row_ID from sbyt.[��������������] k Where k.��� = 7 and k.�������� = '��� ��������� ����������')

INSERT INTO [Sbyt].[��������]
           ([����_���������],[���������_����],[���������_�������],[���������_�����������],[������],[��������],[����������])
     VALUES
           (@prID1,null,@dogID,null,GetDate(),0,'��� �������'),
		   (@prID2,null,@dogID,null,GetDate(),5,'�������� ���������� ��� ������� ��������� ��������������� �����')
GO

--������� ������� �����
INSERT INTO [Sbyt].[�������_�����]
           ([�����],[�����],[����������])
     VALUES
           (10000001,'�. �������, �� �������, � 13','���������� ���������'),
		   (10000002,'�. �������, �� �������, � 15 ���. 4',''),
		   (10000003,'�. �������, �� ������ , � 114 ���. 312','������� ��������'),
		   (10000004,'�. �������, �� ������ , � 114 ���. 311','')

--�������� ������ ������� ����� � ������� � ��� ���� � ������
Declare @dogID int	= (Select top 1 d.Row_ID from Sbyt.������� d where d.����� = '20210601\1')
Declare @ls1 int	= (Select top 1 ls.Row_ID from Sbyt.[�������_�����] ls where ls.����� = 10000001)
Declare @ls2 int	= (Select top 1 ls.Row_ID from Sbyt.[�������_�����] ls where ls.����� = 10000002)
Declare @ls3 int	= (Select top 1 ls.Row_ID from Sbyt.[�������_�����] ls where ls.����� = 10000003)
Declare @ls4 int	= (Select top 1 ls.Row_ID from Sbyt.[�������_�����] ls where ls.����� = 10000004)

INSERT INTO [Sbyt].[�������_��������]
           ([�������],[�������],[������],[������])
	VALUES (@dogID,@ls1,'20210101','20210228'),
		   (@dogID,@ls2,'20210101','20451231'),
		   (@dogID,@ls3,'20210101','20451231'),
		   (@dogID,@ls4,'20210101','20451231')
GO

--������� ��������� �� ������� �����
Declare @ls1 int	= (Select top 1 ls.Row_ID from Sbyt.[�������_�����] ls where ls.����� = 10000002)
Declare @ls2 int	= (Select top 1 ls.Row_ID from Sbyt.[�������_�����] ls where ls.����� = 10000003)
Declare @prID1 int	= (Select top 1 k.Row_ID from sbyt.[��������������] k Where k.��� = 7 and k.�������� = '������� ���������')


INSERT INTO [Sbyt].[��������]
           ([����_���������],[���������_����],[���������_�������],[���������_�����������],[������],[��������],[����������])
     VALUES
           (@prID1,@ls1,null,null,'20210101',15,'�.��.'),
		   (@prID1,@ls2,null,null,'20210101',45,'�.��.')
GO

-------------------------------------------------------------
--������� ������ ����� �� ������� ����-----------------------
-------------------------------------------------------------

Declare @ls bigint	= (Select top 1 ls.Row_ID from Sbyt.[�������_�����] ls where ls.����� = 10000003)
Declare @nom int	= (Select top 1 nom.Row_ID from Sbyt.������������ nom where nom.������������ = '�������� 201.7')

INSERT INTO [Sbyt].[������_��������]
           ([������],[������������_�������],[���������_�����],[�����_������],[����������],[�����������_�������������],[���_�������],[�������_����])
	OUTPUT inserted.*
     VALUES
           ('20210101',@nom,'123456789-07','123-987654',1,1,'20200801',@ls)
GO

-------------------
--��������� �����--
-------------------
--��������� ���������� �� ���������� �������� �� ������� ������ �������

Declare @prID int	= (Select top 1 k.Row_ID from sbyt.[��������������] k Where k.��� = 7 and k.�������� = '������� ���������')

Select org.���, org.���, org.��������, dg.����� as �������������, dg.������_�������� as ������������, ls.�����, ls.�����,
	   ISNULL(sv.��������, 0)	as ����������������, 
	   ISNULL(nom.������������,'') �������������, 
	   ISNULL(so.���������_�����,'') as ��������������
		 from Sbyt.����������� org
		 join Sbyt.������� dg			on dg.���������� = org.Row_ID
		 join Sbyt.�������_�������� Ld	on ld.������� = dg.Row_ID
		 join Sbyt.�������_����� Ls		on ld.������� = ls.Row_ID
	left join Sbyt.�������� sv			on sv.���������_���� = ls.Row_ID
										  and (getdate() between sv.������ and sv.������)	
										  and sv.����_��������� = @prID
	left join Sbyt.[������_��������] so	on so.�������_���� = ls.Row_ID
	left join Sbyt.������������ nom		on so.������������_������� = nom.Row_ID
Where org.��� = '1111111111' and GETDATE() between ld.������ and ld.������

