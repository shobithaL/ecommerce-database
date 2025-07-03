CREATE DATABASE EcommerceDB;
USE EcommerceDB;

CREATE TABLE Customers (
  CustomerID INT PRIMARY KEY,
  Name VARCHAR(255),
  Email VARCHAR(255) UNIQUE,
  Address VARCHAR(255)
);

CREATE TABLE Products (
  ProductID INT PRIMARY KEY,
  ProductName VARCHAR(255),
  Price DECIMAL(10, 2),
  Description TEXT
);

CREATE TABLE Orders (
  OrderID INT PRIMARY KEY,
  CustomerID INT,
  OrderDate DATE,
  Total DECIMAL(10, 2),
  FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE OrderItems (
  OrderItemID INT PRIMARY KEY,
  OrderID INT,
  ProductID INT,
  Quantity INT,
  FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
  FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

INSERT INTO Customers (CustomerID, Name, Email, Address) 
VALUES 
(1, 'John Doe', 'johndoe@example.com', '123 Main St'),
(2, 'Jane Smith', 'janesmith@example.com', NULL),
(3, 'Bob Johnson', 'bobjohnson@example.com', '789 Oak St');

INSERT INTO Products (ProductID, ProductName, Price, Description) 
VALUES 
(1, 'Apple Watch', 19.99, 'Smartwatch'),
(2, 'Nike Air Max', 9.99, 'Running shoes'),
(3, 'Samsung TV', 29.99, '4K Smart TV');

INSERT INTO Orders (OrderID, CustomerID, OrderDate, Total) 
VALUES 
(1, 1, '2022-01-01', 19.99),
(2, 2, '2022-01-15', 9.99),
(3, 1, '2022-02-01', 29.99);

INSERT INTO OrderItems (OrderItemID, OrderID, ProductID, Quantity) 
VALUES 
(1, 1, 1, 1),
(2, 2, 2, NULL),
(3, 3, 3, 1);


UPDATE Products 
SET Price = 14.99 
WHERE ProductID = 1;


DELETE FROM OrderItems 
WHERE OrderID = 2;

DELETE FROM Orders 
WHERE OrderID = 2;

SELECT * FROM Customers;
SELECT Name, Email FROM Customers;

SELECT * FROM Customers WHERE Name = 'John Doe';

SELECT * FROM Orders WHERE Total > 10 AND OrderDate = '2022-01-01';

SELECT * FROM Customers WHERE Email LIKE '%@example.com';

SELECT * FROM Orders WHERE Total BETWEEN 10 AND 20;

SELECT * FROM Products ORDER BY Price DESC;
SELECT * FROM Orders ORDER BY OrderDate ASC;

SELECT *
FROM Customers
INNER JOIN Orders
ON Customers.CustomerID = Orders.CustomerID;

SELECT *
FROM Customers
LEFT JOIN Orders
ON Customers.CustomerID = Orders.CustomerID;

SELECT *
FROM Customers
RIGHT JOIN Orders
ON Customers.CustomerID = Orders.CustomerID;

SELECT * 
FROM Customers 
LEFT JOIN Orders 
ON Customers.CustomerID = Orders.CustomerID
UNION
SELECT * 
FROM Customers 
RIGHT JOIN Orders 
ON Customers.CustomerID = Orders.CustomerID;

SELECT Name, (SELECT AVG(Total) FROM Orders) AS AverageOrderTotal
FROM Customers;

SELECT * FROM Orders o
WHERE o.Total > (SELECT AVG(Total) FROM Orders WHERE CustomerID = o.CustomerID);

SELECT * FROM 
(SELECT CustomerID, AVG(Total) AS AverageOrderTotal 
FROM Orders GROUP BY CustomerID) AS Subquery
WHERE AverageOrderTotal > 20;

SELECT * FROM Customers
WHERE CustomerID IN (SELECT CustomerID FROM Orders WHERE Total > 20);

SELECT * FROM Customers c
WHERE EXISTS (SELECT 1 FROM Orders o WHERE o.CustomerID = c.CustomerID AND o.Total > 20);

SELECT * FROM Customers c
WHERE NOT EXISTS (SELECT 1 FROM Orders o WHERE o.CustomerID = c.CustomerID);