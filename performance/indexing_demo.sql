-- Indexing demo for KakishAutomotiveDB
-- The Sales table only has 15 rows, so an index would show no visible difference there.
-- This script builds a separate test table with 100,000 generated rows instead.

USE KakishAutomotiveDB;
GO

-- 1. Create the test table
CREATE TABLE SalesPerfTest (
    sale_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_id INT,
    vehicle_id INT,
    salesperson_id INT,
    sale_date DATE,
    final_price DECIMAL(10,2)
);
GO

-- 2. Fill it with 100,000 random rows
INSERT INTO SalesPerfTest (customer_id, vehicle_id, salesperson_id, sale_date, final_price)
SELECT TOP (100000)
    ABS(CHECKSUM(NEWID())) % 20 + 1,
    ABS(CHECKSUM(NEWID())) % 20 + 1,
    ABS(CHECKSUM(NEWID())) % 5 + 1,
    DATEADD(DAY, ABS(CHECKSUM(NEWID())) % 730, '2024-01-01'),
    ABS(CHECKSUM(NEWID())) % 40000 + 3000
FROM sys.all_objects a
CROSS JOIN sys.all_objects b;
GO

-- 3. BEFORE the index
-- Turn on "Include Actual Execution Plan" (Ctrl+M) before running this.
-- The plan shows a Clustered Index Scan and suggests a missing index.
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

SELECT customer_id, SUM(final_price) AS total_spent
FROM SalesPerfTest
WHERE sale_date BETWEEN '2025-03-01' AND '2025-03-31'
GROUP BY customer_id;
GO

-- 4. Create the index on the date column
CREATE NONCLUSTERED INDEX idx_perf_sale_date
ON SalesPerfTest (sale_date)
INCLUDE (customer_id, final_price);
GO

-- 5. AFTER the index
-- Same query as step 3. The plan now shows an Index Seek on idx_perf_sale_date.
SELECT customer_id, SUM(final_price) AS total_spent
FROM SalesPerfTest
WHERE sale_date BETWEEN '2025-03-01' AND '2025-03-31'
GROUP BY customer_id;
GO

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;
