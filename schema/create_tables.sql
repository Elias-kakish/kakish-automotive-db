-- KAKISH Automotives database schema (SQL Server / T-SQL)
-- Tables are created in dependency order, because foreign keys need the referenced table to exist first.

IF DB_ID('KakishAutomotiveDB') IS NULL
    CREATE DATABASE KakishAutomotiveDB;
GO

USE KakishAutomotiveDB;
GO

CREATE TABLE Dealerships (
    dealership_id INT PRIMARY KEY IDENTITY(1,1),
    name VARCHAR(100),
    city VARCHAR(50)
);

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY IDENTITY(1,1),
    name VARCHAR(100),
    phone VARCHAR(20)
);

CREATE TABLE Vehicles (
    vehicle_id INT PRIMARY KEY IDENTITY(1,1),
    dealership_id INT FOREIGN KEY REFERENCES Dealerships(dealership_id),
    make VARCHAR(50),
    model VARCHAR(50),
    year INT,
    condition VARCHAR(20),
    price DECIMAL(10,2)
);

CREATE TABLE Salespeople (
    salesperson_id INT PRIMARY KEY IDENTITY(1,1),
    dealership_id INT FOREIGN KEY REFERENCES Dealerships(dealership_id),
    name VARCHAR(100)
);

-- Sales is the hub table: it links a customer, a vehicle and a salesperson
CREATE TABLE Sales (
    sale_id INT PRIMARY KEY IDENTITY(1,1),
    customer_id INT FOREIGN KEY REFERENCES Customers(customer_id),
    vehicle_id INT FOREIGN KEY REFERENCES Vehicles(vehicle_id),
    salesperson_id INT FOREIGN KEY REFERENCES Salespeople(salesperson_id),
    sale_date DATE,
    final_price DECIMAL(10,2)
);

-- Only financed sales have a row here (cash sales do not)
CREATE TABLE Financing (
    financing_id INT PRIMARY KEY IDENTITY(1,1),
    sale_id INT FOREIGN KEY REFERENCES Sales(sale_id),
    loan_amount DECIMAL(10,2),
    interest_rate DECIMAL(5,2),
    term_months INT
);

-- Only sales that included a trade-in have a row here
CREATE TABLE TradeIns (
    tradein_id INT PRIMARY KEY IDENTITY(1,1),
    sale_id INT FOREIGN KEY REFERENCES Sales(sale_id),
    make VARCHAR(50),
    model VARCHAR(50),
    year INT,
    trade_value DECIMAL(10,2)
);

CREATE TABLE TestDrives (
    testdrive_id INT PRIMARY KEY IDENTITY(1,1),
    customer_id INT FOREIGN KEY REFERENCES Customers(customer_id),
    vehicle_id INT FOREIGN KEY REFERENCES Vehicles(vehicle_id),
    scheduled_time DATETIME
);
