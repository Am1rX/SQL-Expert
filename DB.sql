/*
================================================================================
Online Bookstore Database Creation Script (Large Dataset Version)
================================================================================
This script creates the 'OnlineBookstoreDB' and populates it with a large
volume of sample data to simulate a real-world environment for performance testing.
*/

-- Step 1: Create the Database
USE master;
GO

IF DB_ID('OnlineBookstoreDB') IS NOT NULL
BEGIN
    ALTER DATABASE OnlineBookstoreDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE OnlineBookstoreDB;
END
GO

CREATE DATABASE OnlineBookstoreDB;
GO

-- Step 2: Switch to the new database context
USE OnlineBookstoreDB;
GO

-- Step 3: Create Tables (Same as before)
-- Authors Table
CREATE TABLE Authors (
    AuthorID INT PRIMARY KEY IDENTITY(1,1),
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    BirthYear INT
);
GO

-- Books Table
CREATE TABLE Books (
    BookID INT PRIMARY KEY IDENTITY(1,1),
    Title NVARCHAR(200) NOT NULL,
    AuthorID INT FOREIGN KEY REFERENCES Authors(AuthorID),
    Genre NVARCHAR(50),
    Price DECIMAL(10, 2) NOT NULL,
    StockQuantity INT NOT NULL
);
GO

-- Customers Table
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY IDENTITY(1,1),
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100) UNIQUE NOT NULL,
    City NVARCHAR(50)
);
GO

-- Orders Table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID),
    OrderDate DATETIME NOT NULL,
    TotalAmount DECIMAL(10, 2)
);
GO

-- OrderItems Table
CREATE TABLE OrderItems (
    OrderItemID INT PRIMARY KEY IDENTITY(1,1),
    OrderID INT FOREIGN KEY REFERENCES Orders(OrderID),
    BookID INT FOREIGN KEY REFERENCES Books(BookID),
    Quantity INT NOT NULL,
    PriceAtTimeOfOrder DECIMAL(10, 2) NOT NULL
);
GO

-- Step 4: Populate Tables with Expanded Sample Data

-- Insert More Authors
INSERT INTO Authors (FirstName, LastName, BirthYear) VALUES
('George', 'Orwell', 1903), ('J.K.', 'Rowling', 1965), ('J.R.R.', 'Tolkien', 1892),
('Agatha', 'Christie', 1890), ('Stephen', 'King', 1947), ('Isaac', 'Asimov', 1920),
('Jane', 'Austen', 1775), ('Mark', 'Twain', 1835), ('Leo', 'Tolstoy', 1828);
GO

-- Insert More Books
INSERT INTO Books (Title, AuthorID, Genre, Price, StockQuantity) VALUES
('1984', 1, 'Dystopian', 15.99, 520), ('Animal Farm', 1, 'Political Satire', 12.50, 600),
('Harry Potter and the Sorcerer''s Stone', 2, 'Fantasy', 24.95, 1300),
('The Hobbit', 3, 'Fantasy', 20.00, 1250), ('The Lord of the Rings', 3, 'Fantasy', 35.50, 1150),
('And Then There Were None', 4, 'Mystery', 14.00, 780), ('The Shining', 5, 'Horror', 18.75, 590),
('IT', 5, 'Horror', 22.30, 475), ('Foundation', 6, 'Sci-Fi', 19.99, 850),
('Pride and Prejudice', 7, 'Romance', 13.25, 950),
('Adventures of Huckleberry Finn', 8, 'Fiction', 11.50, 400),
('War and Peace', 9, 'Historical Novel', 25.00, 300);
GO

-- Step 5: Mass-generate Customers and Orders

PRINT 'Generating a large number of customers...';
-- Generate 500 Customers
DECLARE @i_cust INT = 1;
WHILE @i_cust <= 500
BEGIN
    INSERT INTO Customers (FirstName, LastName, Email, City)
    VALUES
    ('Customer_First_' + CAST(@i_cust AS NVARCHAR(10)),
     'Customer_Last_' + CAST(@i_cust AS NVARCHAR(10)),
     'customer' + CAST(@i_cust AS NVARCHAR(10)) + '@email.com',
     CHOOSE(CAST(RAND()*4+1 AS INT), 'Tehran', 'Shiraz', 'Isfahan', 'Tabriz'));
    SET @i_cust = @i_cust + 1;
END
GO

PRINT 'Generating a large number of orders... This may take a moment.';
-- Generate 5000 Orders
BEGIN TRANSACTION;
DECLARE @i_order INT = 1;
WHILE @i_order <= 5000
BEGIN
    DECLARE @RandomCustomerID INT = (SELECT TOP 1 CustomerID FROM Customers ORDER BY NEWID());
    DECLARE @RandomOrderDate DATETIME = DATEADD(day, -CAST(RAND()*1000 AS INT), GETDATE());
    DECLARE @NewOrderID INT;
    DECLARE @OrderTotal DECIMAL(10, 2) = 0;

    -- Insert the order header
    INSERT INTO Orders (CustomerID, OrderDate) VALUES (@RandomCustomerID, @RandomOrderDate);
    SET @NewOrderID = SCOPE_IDENTITY();

    -- Insert 1 to 5 order items for this order
    DECLARE @num_items INT = CAST(RAND()*4+1 AS INT);
    DECLARE @j_item INT = 1;
    WHILE @j_item <= @num_items
    BEGIN
        DECLARE @RandomBookID INT = (SELECT TOP 1 BookID FROM Books ORDER BY NEWID());
        DECLARE @BookPrice DECIMAL(10, 2);
        SELECT @BookPrice = Price FROM Books WHERE BookID = @RandomBookID;

        INSERT INTO OrderItems (OrderID, BookID, Quantity, PriceAtTimeOfOrder)
        VALUES (@NewOrderID, @RandomBookID, 1, @BookPrice);

        SET @OrderTotal = @OrderTotal + @BookPrice;
        SET @j_item = @j_item + 1;
    END

    -- Update the total amount for the order
    UPDATE Orders SET TotalAmount = @OrderTotal WHERE OrderID = @NewOrderID;

    SET @i_order = @i_order + 1;
END
COMMIT TRANSACTION;
GO

PRINT 'OnlineBookstoreDB database created and populated successfully with large dataset!';

