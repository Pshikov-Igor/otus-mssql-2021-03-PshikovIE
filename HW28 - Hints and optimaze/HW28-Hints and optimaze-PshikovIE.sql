SET STATISTICS IO, TIME ON

Select ord.CustomerID, det.StockItemID, SUM(det.UnitPrice), SUM(det.Quantity), COUNT(ord.OrderID)
FROM Sales.Orders AS ord																		--������
JOIN Sales.OrderLines AS det ON det.OrderID = ord.OrderID										--�������������
JOIN Sales.Invoices AS Inv ON Inv.OrderID = ord.OrderID											--�����
JOIN Sales.CustomerTransactions AS Trans ON Trans.InvoiceID = Inv.InvoiceID						--���������� ��������
JOIN Warehouse.StockItemTransactions AS ItemTrans ON ItemTrans.StockItemID = det.StockItemID	--���������� 
WHERE Inv.BillToCustomerID != ord.CustomerID  -- ���� ��� �� ������� 
	AND (
		Select SupplierId FROM Warehouse.StockItems AS It --��� ������������� ���������� ������� = 12
		Where It.StockItemID = det.StockItemID
		) = 12 
	AND (
		SELECT SUM(Total.UnitPrice*Total.Quantity) --�������� ����� �� ������� > 250000 
		FROM Sales.OrderLines AS Total 
		Join Sales.Orders AS ordTotal On ordTotal.OrderID = Total.OrderID 
		WHERE ordTotal.CustomerID = Inv.CustomerID
		) > 250000 
	AND DATEDIFF(dd, Inv.InvoiceDate, ord.OrderDate) = 0 --������������� ������
GROUP BY ord.CustomerID, det.StockItemID 
ORDER BY ord.CustomerID, det.StockItemID

/*
�����������:
1) ������ ����� �������� �� ���� ������� ���� ��������� �������� � SELECT.
��� �����������, ������������ CTE ��� �����������.
2) ���������� ���� �������� ���� �������� ������� � ���, ��� ������������ ������������ �������.
��������� �������� Index SCAN 93%, ��� ���������� ����������� ����� 70510 (����. Invoices)
*/

; With salesCTE as (
					SELECT ordTotal.CustomerID--, SUM(Total.UnitPrice*Total.Quantity) as TotalSUM 
					FROM Sales.OrderLines	AS Total 
					Join Sales.Orders		AS ordTotal On ordTotal.OrderID = Total.OrderID 
					GROUP BY ordTotal.CustomerID 
					HAVING SUM(Total.UnitPrice*Total.Quantity) > 250000 
					)


Select	ord.CustomerID		as CustomerID, 
		det.StockItemID		as StockItemID, 
		SUM(det.UnitPrice)	as SumUnitPrice, 
		SUM(det.Quantity)	as SumQuantity, 
		COUNT(ord.OrderID)	as CountOrder
FROM salesCTE							AS sCTE
JOIN Sales.Invoices						AS Inv ON sCTE.CustomerID = Inv.CustomerID
JOIN Sales.Orders						AS ord	ON Inv.OrderID = ord.OrderID																
JOIN Sales.OrderLines					AS det	ON det.OrderID = ord.OrderID										
JOIN Warehouse.StockItems				AS It	ON It.StockItemID = det.StockItemID
JOIN Sales.CustomerTransactions			AS Trans ON Trans.InvoiceID = Inv.InvoiceID					
JOIN Warehouse.StockItemTransactions	AS ItemTrans ON ItemTrans.StockItemID = det.StockItemID		
WHERE Inv.BillToCustomerID != ord.CustomerID  
	AND DATEDIFF(dd, Inv.InvoiceDate, ord.OrderDate) = 0 
    AND It.SupplierId = 12
GROUP BY ord.CustomerID, det.StockItemID 
ORDER BY ord.CustomerID, det.StockItemID

SET STATISTICS IO, TIME OFF

/*

C�������� ������������ ������� 

�������� ������:
 ����� ������ SQL Server:
   ����� �� = 164 ��, ����������� ����� = 2543 ��.

����������������� ������:
 ����� ������ SQL Server:
   ����� �� = 62 ��, ����������� ����� = 183 ��.

*/