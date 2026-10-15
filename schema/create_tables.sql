-- KAKISH Automotives database schema (SQL Server / T-SQL)
-- Tables are created in dependency order, because foreign keys need the referenced table to exist first.
-- Every foreign key column is NOT NULL, because each relationship here is required
-- (a sale always has a customer, a vehicle and a salesperson).

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
    dealership_id INT NOT NULL,
    make VARCHAR(50),
    model VARCHAR(50),
    year INT,
    condition VARCHAR(20),
    price DECIMAL(10,2),
    CONSTRAINT fk_vehicles_dealership
        FOREIGN KEY (dealership_id) REFERENCES Dealerships(dealership_id)
);

CREATE TABLE Salespeople (
    salesperson_id INT PRIMARY KEY IDENTITY(1,1),
    dealership_id INT NOT NULL,
    name VARCHAR(100),
    CONSTRAINT fk_salespeople_dealership
        FOREIGN KEY (dealership_id) REFERENCES Dealerships(dealership_id)
);

-- Sales is the hub table: it links a customer, a vehicle and a salesperson
CREATE TABLE Sales (
    sale_id INT PRIMARY KEY IDENTITY(1,1),
    customer_id INT NOT NULL,
    vehicle_id INT NOT NULL,
    salesperson_id INT NOT NULL,
    sale_date DATE,
    final_price DECIMAL(10,2),
    CONSTRAINT fk_sales_customer
        FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    CONSTRAINT fk_sales_vehicle
        FOREIGN KEY (vehicle_id) REFERENCES Vehicles(vehicle_id),
    CONSTRAINT fk_sales_salesperson
        FOREIGN KEY (salesperson_id) REFERENCES Salespeople(salesperson_id)
);

-- Only financed sales have a row here (cash sales do not)
CREATE TABLE Financing (
    financing_id INT PRIMARY KEY IDENTITY(1,1),
    sale_id INT NOT NULL,
    loan_amount DECIMAL(10,2),
    interest_rate DECIMAL(5,2),
    term_months INT,
    CONSTRAINT fk_financing_sale
        FOREIGN KEY (sale_id) REFERENCES Sales(sale_id)
);

-- Only sales that included a trade-in have a row here
CREATE TABLE TradeIns (
    tradein_id INT PRIMARY KEY IDENTITY(1,1),
    sale_id INT NOT NULL,
    make VARCHAR(50),
    model VARCHAR(50),
    year INT,
    trade_value DECIMAL(10,2),
    CONSTRAINT fk_tradeins_sale
        FOREIGN KEY (sale_id) REFERENCES Sales(sale_id)
);

CREATE TABLE TestDrives (
    testdrive_id INT PRIMARY KEY IDENTITY(1,1),
    customer_id INT NOT NULL,
    vehicle_id INT NOT NULL,
    scheduled_time DATETIME,
    CONSTRAINT fk_testdrives_customer
        FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    CONSTRAINT fk_testdrives_vehicle
        FOREIGN KEY (vehicle_id) REFERENCES Vehicles(vehicle_id)
);
