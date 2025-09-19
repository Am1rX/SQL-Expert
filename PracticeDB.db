-- Drop the database if it already exists to start fresh
IF DB_ID('PracticeDB') IS NOT NULL
BEGIN
    ALTER DATABASE PracticeDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE PracticeDB;
END
GO

-- 1. Create a new database for our practice sessions
CREATE DATABASE PracticeDB;
GO

-- 2. Switch to the newly created database context
USE PracticeDB;
GO

-- 3. Create the Products table
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName NVARCHAR(100),
    Category NVARCHAR(50),
    Price DECIMAL(18, 2),
    StockQuantity INT
);

-- 4. Create the Employees table
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FullName NVARCHAR(100),
    DepartmentID INT
);

-- 5. Create the Departments table
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName NVARCHAR(50)
);

-- 6. Create the Sales table
CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    EmployeeID INT,
    ProductName NVARCHAR(100),
    Category NVARCHAR(50),
    Price DECIMAL(18, 2),
    Quantity INT,
    SaleAmount AS (Price * Quantity) -- Computed column for total sale amount
);

-- 7. Create the Students table
CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    StudentName NVARCHAR(100)
);

-- 8. Create the Courses table
CREATE TABLE Courses (
    CourseID INT PRIMARY KEY,
    CourseName NVARCHAR(100)
);

-- 9. Create the Enrollments table (linking Students and Courses)
CREATE TABLE Enrollments (
    EnrollmentID INT PRIMARY KEY,
    StudentID INT,
    CourseID INT
);

-- Insert sample data into all tables --

-- Data for Products
INSERT INTO Products (ProductID, ProductName, Category, Price, StockQuantity) VALUES
(101, N'لپ تاپ مدل A', N'دیجیتال', 30000000, 15),
(102, N'ماوس بی‌سیم', N'لوازم جانبی', 500000, 150),
(103, N'کتاب SQL', N'کتاب', 200000, 50),
(104, N'لپ تاپ مدل B', N'دیجیتال', 45000000, 8),
(105, N'کیبورد مکانیکی', N'لوازم جانبی', 1200000, 40),
(106, N'مانیتور', N'دیجیتال', 7000000, 22),
(110, N'هدفون', N'لوازم جانبی', 850000, 0); -- This product will be deleted later in a test

-- Data for Employees
INSERT INTO Employees (EmployeeID, FullName, DepartmentID) VALUES
(1, N'سارا اکبری', 1),
(2, N'سینا محمدی', 2),
(3, N'لیلا زمانی', 1),
(4, N'نوید کریمی', NULL);

-- Data for Departments
INSERT INTO Departments (DepartmentID, DepartmentName) VALUES
(1, N'فروش'),
(2, N'فنی'),
(3, N'مالی');

-- Data for Sales
INSERT INTO Sales (SaleID, EmployeeID, ProductName, Category, Price, Quantity) VALUES
(1001, 2, N'ماوس بی‌سیم', N'لوازم جانبی', 500000, 10),
(1002, 1, N'لپ تاپ مدل A', N'دیجیتال', 30000000, 2),
(1003, 2, N'کیبورد مکانیکی', N'لوازم جانبی', 1200000, 8),
(1004, 3, N'لپ تاپ مدل B', N'دیجیتال', 45000000, 1),
(1005, 1, N'مانیتور', N'دیجیتال', 7000000, 3),
(1006, 1, N'کتاب SQL', N'کتاب', 200000, 5);

-- Data for Students
INSERT INTO Students (StudentID, StudentName) VALUES
(1, N'آرش امینی'),
(2, N'بهار صالحی'),
(3, N'پدرام نظری');

-- Data for Courses
INSERT INTO Courses (CourseID, CourseName) VALUES
(10, N'پایگاه داده'),
(20, N'برنامه نویسی'),
(30, N'شبکه');

-- Data for Enrollments
INSERT INTO Enrollments (EnrollmentID, StudentID, CourseID) VALUES
(1001, 1, 10),
(1002, 2, 10),
(1003, 1, 20),
(1004, 3, 30);

PRINT 'Database PracticeDB and all tables created and populated successfully.';
GO
