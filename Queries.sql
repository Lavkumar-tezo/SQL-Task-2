use Lavdb;

--1. Get the firstname and lastname of the employees who placed orders between 15th August,1996 and 15th August,1997
SELECT FirstName, LastName FROM Employee JOIN Orders ON Employee.EmployeeId = Orders.EmployeeId 
AND Orders.OrderDate BETWEEN '1996-08-15' AND '1997-08-15';

--2. Get the distinct EmployeeIDs who placed orders before 16th October,1996
SELECT distinct Employee.EmployeeId FROM Employee JOIN Orders ON Employee.EmployeeId = Orders.EmployeeId 
AND Orders.OrderDate <= '1996-10-16';

--3. How many products were ordered in total by all employees between 13th of January,1997 and 16th of April,1997.
SELECT COUNT(OrderID) AS [TotalOrders] FROM Orders WHERE OrderDate BETWEEN '1997-01-13' AND '1997-04-16' AND EmployeeID IS NOT NULL;
SELECT COUNT(OrderID) AS [TotalOrders] FROM Employee JOIN Orders ON Employee.EmployeeID=Orders.EmployeeID WHERE OrderDate BETWEEN '1997-01-13' AND '1997-04-16';


--4. What is the total quantity of products for which Anne Dodsworth placed orders between 13th of January,1997 and 16th of April,1997.
SELECT SUM(Quantity) AS [TotalOrder] FROM Orders JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID 
AND Orders.OrderDate BETWEEN '1997-01-13' AND '1997-04-16' 
AND Orders.EmployeeID= (SELECT EmployeeID FROM Employee WHERE 
FirstName='Anne' AND LastName='Dodsworth');

--another
SELECT SUM(Quantity) AS [TotalOrder] FROM Employee JOIN Orders ON Employee.EmployeeID=Orders.EmployeeID JOIN OrderDetails ON
Orders.OrderID=OrderDetails.OrderID WHERE OrderDate BETWEEN '1997-01-13' AND '1997-04-16' AND
FirstName='Anne' AND LastName='Dodsworth';

--5. How many orders have been placed in total by Robert King
SELECT COUNT(OrderID) as [TotalOrder] FROM Employee JOIN Orders ON Employee.EmployeeID=Orders.EmployeeID WHERE 
FirstName='Robert' AND LastName='King'

--6. How many products have been ordered by Robert King between 15th August,1996 and 15th August,1997
SELECT COUNT(DISTINCT OrderDetails.ProductId) FROM Orders JOIN OrderDetails ON Orders.OrderID=OrderDetails.OrderID
AND OrderDate BETWEEN '1996-08-15' AND '1997-08-15' AND Orders.EmployeeID= (SELECT EmployeeID FROM Employee WHERE 
FirstName='Robert' AND LastName='King' AND OrderDate BETWEEN '1996-08-15' AND '1997-08-15');

--other
SELECT COUNT(DISTINCT OrderDetails.ProductId) FROM Employee JOIN Orders ON Employee.EmployeeID=Orders.EmployeeID JOIN OrderDetails On 
Orders.OrderID=OrderDetails.OrderID WHERE OrderDate BETWEEN '1996-08-15' AND '1997-08-15' AND 
FirstName='Robert' AND LastName='King';

--7. I want to make a phone call to the employees to wish them on the occasion of Christmas who placed orders between 13th of January,1997 and 16th of April,1997. I want the EmployeeID, Employee Full Name, HomePhone Number.
SELECT DISTINCT Employee.EmployeeID, CONCAT(FirstName,' ',LastName) as [FullName], HomePhone FROM Employee JOIN Orders ON 
Employee.EmployeeID=Orders.EmployeeID WHERE OrderDate BETWEEN '1997-01-13' AND '1997-04-16';

--8. Which product received the most orders. Get the product's ID and Name and number of orders it received.
SELECT TOP 1 OrderDetails.ProductID, ProductName,COUNT(OrderID) as [TotalOrder] FROM Products JOIN OrderDetails ON 
Products.ProductID=OrderDetails.ProductID GROUP BY OrderDetails.ProductID,ProductName Order BY COUNT(OrderID) DESC;

--9. Which are the least shipped products. List only the top 5 from your list.
SELECT TOP 5 * FROM Products ORDER BY UnitsOnOrder;

--10. What is the total price that is to be paid by Laura Callahan for the order placed on 13th of January,1997
SELECT SUM(UnitPrice * Quantity) as [TotalAmount] FROM Employee JOIN Orders ON Employee.EmployeeID=Orders.EmployeeID 
JOIN OrderDetails ON Orders.OrderID=OrderDetails.OrderID WHERE OrderDate = '1997-01-13' 
AND FirstName='Laura' AND LastName='Callahan'

--11. How many number of unique employees placed orders for Gorgonzola Telino or Gnocchi di nonna Alice or Raclette Courdavault or Camembert Pierrot in the month January,1997
SELECT COUNT(DISTINCT Orders.EmployeeID) FROM Orders JOIN OrderDetails ON Orders.OrderID=OrderDetails.OrderID AND 
YEAR(OrderDate) = 1997 AND MONTH(OrderDate) = 1 AND
ProductID IN (SELECT ProductID FROM Products WHERE ProductName IN 
('Gorgonzola Telino','Gnocchi di nonna Alice','Raclette Courdavault','Camembert Pierrot'));

--12. What is the full name of the employees who ordered Tofu between 13th of January,1997 and 30th of January,1997
SELECT CONCAT(FirstName,' ',LastName) as [FullName] FROM Employee JOIN Orders 
ON Employee.EmployeeID=Orders.EmployeeID JOIN OrderDetails ON Orders.OrderID=OrderDetails.OrderID JOIN
Products On OrderDetails.ProductID=Products.ProductID WHERE ProductName='Tofu' AND 
OrderDate BETWEEN '1997-01-13' AND '1997-01-30'

--13. What is the age of the employees in days, months and years who placed orders during the month of August. Get employeeID and full name as well
SELECT Employee.EmployeeID, CONCAT(FirstName,' ',LastName) as [FullName],
CASE
	WHEN DAY(GETDATE()) >= DAY(BirthDate) THEN DAY(GETDATE()) - DAY(BirthDate)
	ELSE DAY(GETDATE()) - DAY(BirthDate) +30
END AS [Day],
CASE
	WHEN MONTH(GETDATE()) >= MONTH(BirthDate) AND DAY(GETDATE()) >= DAY(BirthDate) THEN MONTH(GETDATE()) - MONTH(BirthDate)
	WHEN MONTH(GETDATE()) > MONTH(BirthDate) AND DAY(GETDATE()) < DAY(BirthDate) THEN MONTH(GETDATE()) - MONTH(BirthDate) -1
	ELSE MONTH(GETDATE()) - MONTH(BirthDate)+11
END AS [Month],
CASE 
        WHEN MONTH(GETDATE()) > MONTH(BirthDate) OR MONTH(GETDATE()) = MONTH(BirthDate) AND DAY(GETDATE()) >= DAY(BirthDate) THEN DATEDIFF(year, BirthDate, GETDATE()) 
        ELSE DATEDIFF(year, BirthDate, GETDATE()) - 1 
    END AS [YEAR],
BirthDate
FROM Employee JOIN Orders ON Employee.EmployeeID=Orders.EmployeeID WHERE MONTH(OrderDate)=08;


--14. Get all the shipper's name and the number of orders they shipped
SELECT CompanyName, COUNT(OrderID)as [NoOfOrders] FROM Shippers JOIN Orders ON Shippers.ShipperID=Orders.ShipperID GROUP BY Orders.ShipperID,Shippers.CompanyName;

--15. Get the all shipper's name and the number of products they shipped.
SELECT CompanyName, COUNT(ProductId) FROM Shippers JOIN Orders ON Shippers.ShipperID=Orders.ShipperID 
JOIN OrderDetails ON Orders.OrderID=OrderDetails.OrderID GROUP BY CompanyName;

--16. Which shipper has bagged most orders. Get the shipper's id, name and the number of orders.
SELECT TOP 1 Shippers.ShipperID,CompanyName, COUNT(OrderID) FROM Shippers JOIN Orders ON Shippers.ShipperID=Orders.ShipperID 
GROUP BY Shippers.ShipperID,CompanyName ORDER BY COUNT(OrderID) DESC;

--17. Which shipper supplied the most number of products between 10th August,1996 and 20th September,1998. Get the shipper's name and the number of products.
SELECT TOP 1 CompanyName, COUNT(ProductId) FROM Shippers JOIN Orders ON Shippers.ShipperID=Orders.ShipperID 
JOIN OrderDetails ON Orders.OrderID=OrderDetails.OrderID WHERE OrderDate BETWEEN '1996-08-10' AND '1998-09-20' GROUP BY CompanyName ORDER BY COUNT(ProductId) DESC;

--18. Which employee didn't order any product 4th of April 1997
SELECT * FROM Employee WHERE EmployeeID NOT IN (SELECT Employee.EmployeeID FROM Employee JOIN Orders ON Employee.EmployeeID=Orders.EmployeeID 
WHERE Orders.OrderDate ='1997-04-04');

--19. How many products where shipped to Steven Buchanan
SELECT COUNT(ProductID) AS [TotalCount] FROM Employee JOIN Orders ON 
Employee.EmployeeID=Orders.EmployeeID JOIN OrderDetails ON OrderDetails.OrderID=Orders.OrderID 
WHERE FirstName='Steven' AND LastName='Buchanan' AND ShippedDate IS NOT NULL;

--20. How many orders where shipped to Michael Suyama by Federal Shipping
SELECT COUNT(OrderID) as [TotalOrder] FROM Employee JOIN Orders ON Employee.EmployeeID=Orders.EmployeeID
JOIN Shippers ON Orders.ShipperID=Shippers.ShipperID WHERE FirstName='Michael' AND
LastName='Suyama' AND CompanyName='Federal Shipping' AND ShippedDate IS NOT NULL;

--21. How many orders are placed for the products supplied from UK and Germany
SELECT COUNT(Orders.OrderID) as [TotalOrder] FROM Orders JOIN OrderDetails 
ON Orders.OrderID=OrderDetails.OrderID JOIN Products ON OrderDetails.ProductID=Products.ProductID 
JOIN Suppliers On Products.SupplierID=Suppliers.SupplierID WHERE Country='UK' OR Country='Germany';

--22. How much amount Exotic Liquids received due to the order placed for its products in the month of January,1997
SELECT SUM(Products.UnitPrice * OrderDetails.Quantity) as [TotalAmount] FROM Orders JOIN OrderDetails 
ON Orders.OrderID=OrderDetails.OrderID JOIN Products ON OrderDetails.ProductID=Products.ProductID 
JOIN Suppliers On Products.SupplierID=Suppliers.SupplierID WHERE CompanyName='Exotic Liquids' AND
MONTH(OrderDate)=1 AND YEAR(OrderDate)=1997;

--23. In which days of January, 1997, the supplier Tokyo Traders haven't received any orders. -- error
WITH CTE AS (SELECT 1 DATE UNION all SELECT DATE +1 FROM CTE WHERE DATE<31 ) SELECT * from CTE WHERE DATE NOT IN 
(SELECT DAY(OrderDate) FROM Orders JOIN OrderDetails ON Orders.OrderID=OrderDetails.OrderID JOIN Products 
ON OrderDetails.ProductID=Products.ProductID JOIN Suppliers On Products.SupplierID=Suppliers.SupplierID 
WHERE CompanyName='Tokyo Traders' AND MONTH(OrderDate)=1 AND YEAR(OrderDate)=1997);

--24. Which of the employees did not place any order for the products supplied by Ma Maison in the month of May
SELECT * FROM Employee WHERE EmployeeID NOT IN ( SELECT Employee.EmployeeID FROM Employee JOIN Orders On 
Employee.EmployeeID=Orders.EmployeeID JOIN OrderDetails ON Orders.OrderID=OrderDetails.OrderID
JOIN Products ON OrderDetails.ProductID=Products.ProductID JOIN Suppliers ON 
Products.SupplierID=Suppliers.SupplierID WHERE MONTH(OrderDate)= 5 AND CompanyName ='Ma Maison');

--25. Which shipper shipped the least number of products for the month of September and October,1997 combined.
SELECT TOP 1 Shippers.CompanyName,COUNT(Orders.OrderID) FROM Orders JOIN Shippers ON Orders.ShipperID=Shippers.ShipperID WHERE MONTH(OrderDate) =9 OR
MONTH(OrderDate)=10 GROUP BY Orders.ShipperID,Shippers.CompanyName ORDER BY COUNT(Orders.OrderID);

--26. What are the products that weren't shipped at all in the month of August, 1997
SELECT * FROM Products WHERE ProductID NOT IN ( SELECT Products.ProductID FROM Orders JOIN OrderDetails
ON Orders.OrderID=OrderDetails.OrderID JOIN Products ON Products.ProductID=OrderDetails.ProductID
WHERE MONTH(ShippedDate)= 8 AND YEAR(ShippedDate)=1997);

--27. What are the products that weren't ordered by each of the employees. List each employee and the products that he didn't order.
SELECT Employee.EmployeeID, CONCAT(FirstName,' ',LastName) as [EmployeeName], Products.ProductID, ProductName 
FROM Employee CROSS JOIN Products WHERE NOT EXISTS (SELECT 1 FROM Orders JOIN OrderDetails ON 
Orders.OrderID = OrderDetails.OrderID WHERE Employee.EmployeeID = Orders.EmployeeID AND 
Products.ProductID = OrderDetails.ProductID);


--28. Who is busiest shipper in the months of April, May and June during the year 1996 and 1997
SELECT TOP 1 CompanyName,COUNT(CompanyName) As[TotalOrder]  FROM Orders JOIN Shippers ON Orders.ShipperID=Shippers.ShipperID WHERE 
MONTH(ShippedDate) IN (4,5,6) AND YEAR(ShippedDate) IN (1996,1997) GROUP BY CompanyName
ORDER BY COUNT(CompanyName) DESC;

--29. Which country supplied the maximum products for all the employees in the year 1997
SELECT TOP 1 Country, COUNT(Country) AS [ProductCount] FROM Orders JOIN OrderDetails ON Orders.OrderID=OrderDetails.OrderID JOIN Products
ON OrderDetails.ProductID=Products.ProductID JOIN Suppliers ON Products.SupplierID=Suppliers.SupplierID WHERE YEAR(ShippedDate)=1997
GROUP BY Country ORDER BY COUNT(Country) DESC;


--30. What is the average number of days taken by all shippers to ship the product after the order has been placed by the employees
SELECT AVG(DATEDIFF(DAY,OrderDate,ShippedDate)) as[AvgDays] FROM Orders WHERE OrderDate IS NOT NULL AND ShippedDate IS NOT NULL;

--31. Who is the quickest shipper of all.
SELECT TOP 1 Shippers.ShipperID, CompanyName AS ShipperName, AVG(DATEDIFF(DAY, OrderDate, Orders.ShippedDate)) AS [AvgShippingDays]
FROM    Shippers JOIN   Orders ON Shippers.ShipperID = Orders.ShipperID WHERE   Orders.ShippedDate IS NOT NULL
GROUP BY   Shippers.ShipperID, Shippers.CompanyName ORDER BY   AVG(DATEDIFF(DAY, Orders.OrderDate, Orders.ShippedDate));

--32. Which order took the least number of shipping days. Get the orderid, employees full name, number of products, number of days took to ship and shipper company name
SELECT TOP 1 OrderID,FirstName,LastName,DATEDIFF(DAY,OrderDate,ShippedDate) as[DayTaken],CompanyName FROM 
Employee JOIN Orders ON Employee.EmployeeID=Orders.EmployeeID JOIN Shippers ON
Orders.ShipperID=Shippers.ShipperID WHERE OrderDate IS NOT NULL AND ShippedDate IS NOT NULL
ORDER BY DATEDIFF(DAY,OrderDate,ShippedDate);

--UNION
-- 1. Which orders took the least number and maximum number of shipping days? Get the orderid, employees full name, number of products, number of days taken to ship the product and shipper company name. Use 1 and 2 in the final result set to distinguish the 2 orders.
WITH CTE AS (SELECT OrderID,FirstName,LastName,DATEDIFF(DAY,OrderDate,ShippedDate) as[DayTaken],CompanyName FROM 
Employee JOIN Orders ON Employee.EmployeeID=Orders.EmployeeID JOIN Shippers ON
Orders.ShipperID=Shippers.ShipperID WHERE OrderDate IS NOT NULL AND ShippedDate IS NOT NULL)
SELECT *,'Least' AS [SortType] FROM CTE WHERE DayTaken=(SELECT MIN(DayTaken) FROM CTE) UNION ALL
SELECT *,'Maximum' AS [SortType] FROM CTE WHERE DayTaken=(SELECT MAX(DayTaken) FROM CTE);

-- 2. Which is cheapest and the costliest of products purchased in the second week of October, 1997. Get the product ID, product Name and unit price. Use 1 and 2 in the final result set to distinguish the 2 products
WITH CTE AS (SELECT Products.ProductID,ProductName,Products.UnitPrice,OrderDate FROM Orders JOIN OrderDetails 
ON Orders.OrderID=OrderDetails.OrderID JOIN Products ON OrderDetails.ProductID=Products.ProductID WHERE OrderDate 
BETWEEN DATEADD(DAY,7-DATEPART(WEEKDAY,'1997-10-01'),'1997-10-01') AND 
DATEADD(DAY,14-DATEPART(WEEKDAY,'1997-10-01'),'1997-10-01') ) 
SELECT *,'Cheapest' AS [SortType]  FROM CTE WHERE UnitPrice = (SELECT MIN(UnitPrice) FROM CTE) UNION ALL
SELECT *,'Costliest' AS [SortType]  FROM CTE WHERE UnitPrice = (SELECT MAX(UnitPrice) FROM CTE);

-- CASE
-- . Find the distinct shippers who are to ship the orders placed by employees with IDs 1, 3, 5, 7. Show the shipper's name as "Express Speedy" if the shipper's ID is 2 and "United Package" if the shipper's ID is 3 and "Shipping Federal" if the shipper's ID is 1.
SELECT distinct CASE WHEN Orders.ShipperID =2 THEN 'Express Speedy' WHEN Orders.ShipperID = 3 THEN 'United Package'
WHEN Orders.ShipperID = 1 THEN 'Shipping Federal'END AS [ShipperName],Orders.ShipperID FROM Employee JOIN Orders 
ON Employee.EmployeeID=Orders.EmployeeID WHERE Employee.EmployeeID IN (1,3,5,7);