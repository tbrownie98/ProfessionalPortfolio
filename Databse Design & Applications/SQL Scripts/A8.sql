/*
William Brown
CIS 310-01
Assignment 8
3/20/2017
*/

/*1) List the products with a list price greater than the average list price of all 
products.*/
SELECT ItemID,
	   [Description],
	   ListPrice
FROM Merchandise
WHERE ListPrice > (SELECT AVG(ListPrice) 
				   FROM Merchandise)

--A)
SELECT ItemID,
	   [Description],
	   ListPrice
FROM Merchandise
WHERE ((ListPrice)>(SELECT AVG(ListPrice) 
                    FROM Merchandise))
ORDER BY ListPrice DESC

/*2) Which merchandise items have an average sale price more than 50 percent higher
than their average purchase cost?*/
SELECT O.ItemID,
	   AVG(O.Cost) AS AvgCost,
	   AVG(S.SalePrice) AS AvgSalePrice
FROM OrderItem O
	INNER JOIN SaleItem S ON O.ItemID = S.ItemID
GROUP BY O.ItemID
HAVING AVG(S.SalePrice) > (AVG(O.Cost)*.5)+AVG(O.Cost)

--A)
CREATE VIEW AVERAGECOST AS
SELECT ItemID,
	   AVG([Cost]) AS AvgCost
FROM OrderItem
GROUP BY ItemID

CREATE VIEW AVERAGESALE AS
SELECT ItemID,
	   AVG(SalePrice) AS AvgSalePrice
FROM SaleItem
GROUP BY ItemID

SELECT M.ItemID,   
	   M.[Description],
	   AC.AvgCost,
	   ASale.AvgSalePrice
FROM AVERAGECOST AC
	INNER JOIN Merchandise M ON AC.ItemID = M.ItemID
	INNER JOIN AVERAGESALE ASale ON M.ItemID = ASale.ItemID
WHERE ASale.AvgSalePrice > 1.5*AC.AvgCost

/*3) List the employees and their total merchandise sales expressed as a percentage of 
total merchandise sales for all employees.*/
--????????????????????????????????????????????????????????????????????????????????????
SELECT E.EmployeeID,
	   E.LastName,
	   SUM(Quantity*SalePrice) AS 'TotalSales',
	   (SUM(Quantity*SalePrice)/(SELECT SUM(SalePrice*Quantity) 
								FROM SaleItem)) AS 'PetSales'
FROM Employee E
	RIGHT OUTER JOIN Sale S ON E.EmployeeID = S.EmployeeID
	RIGHT OUTER JOIN SaleItem SI ON S.SaleID = SI.SaleID
GROUP BY E.EmployeeID, E.LastName
ORDER BY SUM(Quantity*SalePrice)

--A)
SELECT E.EmployeeID,
	   E.LastName,
	   SUM(Quantity*SalePrice) AS 'TotalSales',
	   (SUM(Quantity*SalePrice)/ (SELECT SUM(SalePrice*Quantity) 
								 FROM Sale S
								 INNER JOIN SaleItem SI ON S.SaleID = SI.SaleID)*100) AS 'PetSales'
FROM Employee E
	RIGHT OUTER JOIN Sale S ON E.EmployeeID = S.EmployeeID
	RIGHT OUTER JOIN SaleItem SI ON S.SaleID = SI.SaleID
GROUP BY E.EmployeeID, E.LastName
ORDER BY SUM(Quantity*SalePrice) DESC

/*4) On average, which supplier charges the highest shipping cost as a percent of the 
merchandise order total?*/
SELECT S.SupplierID,
	   S.[Name],
	   AVG(A.ShippingCost) AS 'PetShipCost'
FROM Supplier S
	INNER JOIN AnimalOrder A ON S.SupplierID = A.SupplierID
WHERE A.ShippingCost = (SELECT MAX(ShippingCost)
					   FROM AnimalOrder)
GROUP BY S.SupplierID, S.[Name], A.ShippingCost

--A)


/*5) Which customer has given us the most total money for animals and merchandise?*/
SELECT TOP 1 C.CustomerID,
	   C.LastName,
	   C.FirstName,
	   SUM(SI.SalePrice*SI.Quantity) AS 'MercTotal',
	   SUM(SA.SalePrice) AS 'AnimalTotal',
	   SUM(SI.SalePrice*SI.Quantity+SA.SalePrice) AS 'GrandTotal'
FROM Customer C
	INNER JOIN Sale S ON C.CustomerID = S.CustomerID
	INNER JOIN SaleItem SI ON S.SaleID = SI.SaleID
	INNER JOIN SaleAnimal SA ON S.SaleID = SA.SaleID
GROUP BY C.CustomerID, C.LastName, C.FirstName
ORDER BY GrandTotal DESC

--A)


/*6) Which customers who bought more than $100 in merchandise in May also spent more 
than $50 on merchandise in October?*/
SELECT S.CustomerID,
	   C.LastName,
	   C.FirstName,
	   SUM(SI.SalePrice*SI.Quantity) AS 'MayTotal'
FROM Sale S
	INNER JOIN Customer C ON C.CustomerID = S.CustomerID
	INNER JOIN SaleItem SI ON SI.SaleID = S.SaleID
GROUP BY S.CustomerID, C.LastName, C.FirstName, S.SaleDate
HAVING (MONTH(S.SaleDate) = 5 
AND SUM(SalePrice*SI.Quantity)>100 
AND S.CustomerID IN (SELECT CustomerID
					FROM Sale S
						INNER JOIN SaleItem SI ON S.SaleID = SI.SaleID
					GROUP BY CustomerID, SaleDate
					
--A)																				HAVING MONTH(S.SaleDate) = 10 AND SUM(SalePrice*SI.Quantity)>50))

/*7) What was the net change in quantity on hand for premium canned dog food between 
January 1 and July 1?*/
SELECT M.[Description],
	   M.ItemID,
	   COUNT(OI.ItemID) AS 'Purchased',
	   COUNT(SI.ItemID) AS 'Sold'
FROM Merchandise M
	INNER JOIN OrderItem OI ON M.ItemID = OI.ItemID
	INNER JOIN SaleItem SI ON M.ItemID = SI.ItemID
	INNER JOIN Sale S ON SI.SaleID = S.SaleID
WHERE S.SaleDate > '2004-01-01' AND S.SaleDate < '2004-07-01'
GROUP BY M.[Description], M.ItemID

--A)

/*8) Which merchandise items with a list price of more than $50 had no sales July?*/
SELECT ItemID,
	   [Description],
	   ListPrice
FROM Merchandise
WHERE ListPrice > 50 
AND ItemID IN (SELECT M.ItemID 
								   FROM Merchandise M
										INNER JOIN SaleItem SI ON M.ItemID = SI.ItemID 
										INNER JOIN Sale S ON SI.SaleID = S.SaleID
								   WHERE MONTH(S.SaleDate) <> 7)

--A)

/*9) Which merchandise items with more than 100 units on hand have not been ordered in 
2004? Use an outer join to answer the question.*/
SELECT M.ItemID,
	   [Description],
	   QuantityOnHand,
	   O.ItemID
FROM Merchandise M 
	LEFT OUTER JOIN OrderItem O ON M.ItemID = O.ItemID
	LEFT OUTER JOIN MerchandiseOrder MO ON O.PONumber = MO.PONumber
WHERE QuantityOnHand > 100 
AND O.ItemID IS NULL 
OR YEAR(OrderDate)<>2004

--A)

/*10) Which merchandise items with more than 100 units on hand have not been ordered in 
2004? Use a subquery to answer the question.*/
SELECT M.ItemID,
	   [Description],
	   QuantityOnHand
FROM Merchandise M 
WHERE ItemID IN (SELECT M.ItemID
				 FROM Merchandise M 
					LEFT OUTER JOIN OrderItem O ON M.ItemID = O.ItemID
					LEFT OUTER JOIN MerchandiseOrder MO ON O.PONumber = MO.PONumber 
				WHERE QuantityOnHand > 100 
				AND O.ItemID IS NULL 
				OR YEAR(OrderDate)<>2004)

--A)

/*11) Save a query to list the total amount of money spent by each customer. Create the 
table shown to categorize customers based on sales. Write a query that lists each customer 
from the first query and displays the proper label. Must only SQL statements and include 
all statements used in the proper order.*/
CREATE VIEW CustomerGTotal AS 
SELECT S.CustomerID, 
	   C.LastName, 
	   C.FirstName, 
	   SUM(ISNULL(SI.SalePrice,0)*ISNULL(Quantity,0)+ISNULL(SA.SalePrice,0)) AS 'GrandTotal'
FROM Sale S
	LEFT OUTER JOIN Customer C ON S.CustomerID = C.CustomerID
	LEFT OUTER JOIN SaleAnimal SA ON S.SaleID = SA.SaleID
	LEFT OUTER JOIN SaleItem SI ON S.SaleID = SI.SaleID
GROUP BY S.CustomerID, LastName, FirstName

DROP VIEW CustomerGTotal

SELECT * FROM CustomerGTotal

CREATE TABLE CustCategory (Category VARCHAR(4), Low INT, High INT)

INSERT INTO CustCategory 
VALUES ('Weak',0,200),
	   ('Good',200,800),
	   ('Best',800,1000)

SELECT DISTINCT CGT.*, Category
FROM CustomerGTotal CGT
	INNER JOIN CustCategory CC ON GrandTotal < 10000

--A)


/*12) List all suppliers (animals and merchandise) who sold us items in June. Identify 
whether they sold use animals or merchandise.*/
SELECT S.[Name],
	   CASE 
			WHEN S.SupplierID = AO.SupplierID THEN 'Animal'
			WHEN S.SupplierID = MO.SupplierID THEN 'Merchandise'
		END AS 'Category'
FROM Supplier S
	INNER JOIN AnimalOrder AO ON S.SupplierID = AO.SupplierID
	INNER JOIN MerchandiseOrder MO ON S.SupplierID = MO.SupplierID
	INNER JOIN OrderItem OI ON MO.PONumber = OI.PONumber
	INNER JOIN SaleItem SI ON OI.ItemID = SI.ItemID
	INNER JOIN Sale SA ON SI.SaleID = SA.SaleID
WHERE MONTH(SA.SaleDate) = 6

--A)