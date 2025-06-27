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
