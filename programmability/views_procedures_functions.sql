-- Views, stored procedures and a function for KakishAutomotiveDB
USE KakishAutomotiveDB;
GO

-- View: every sale with its customer, vehicle and salesperson (the Power BI dashboard reads from this)
CREATE VIEW vw_SalesDetail AS
SELECT s.sale_id, s.sale_date, s.final_price,
       c.name AS customer_name,
       v.make, v.model, v.year AS vehicle_year, v.condition,
       sp.name AS salesperson
FROM Sales s
JOIN Customers c ON s.customer_id = c.customer_id
JOIN Vehicles v ON s.vehicle_id = v.vehicle_id
JOIN Salespeople sp ON s.salesperson_id = sp.salesperson_id;
GO

-- Procedure: revenue and number of sales per month
CREATE PROCEDURE GetMonthlySales
AS
BEGIN
    SELECT YEAR(sale_date) AS sale_year, MONTH(sale_date) AS sale_month,
           SUM(final_price) AS total_revenue, COUNT(*) AS num_sales
    FROM Sales
    GROUP BY YEAR(sale_date), MONTH(sale_date)
    ORDER BY sale_year, sale_month;
END;
GO

-- Procedure: all sales handled by one salesperson
CREATE PROCEDURE GetSalesBySalesperson
    @SalespersonID INT
AS
BEGIN
    SELECT s.sale_id, c.name AS customer, v.make, v.model, s.sale_date, s.final_price
    FROM Sales s
    JOIN Customers c ON s.customer_id = c.customer_id
    JOIN Vehicles v ON s.vehicle_id = v.vehicle_id
    WHERE s.salesperson_id = @SalespersonID
    ORDER BY s.sale_date;
END;
GO

-- Function: how much one customer has spent in total
CREATE FUNCTION dbo.GetCustomerTotalSpend (@CustomerID INT)
RETURNS DECIMAL(12,2)
AS
BEGIN
    DECLARE @Total DECIMAL(12,2);
    SELECT @Total = ISNULL(SUM(final_price), 0) FROM Sales WHERE customer_id = @CustomerID;
    RETURN @Total;
END;
GO

-- Tests
SELECT * FROM vw_SalesDetail;
EXEC GetMonthlySales;
EXEC GetSalesBySalesperson @SalespersonID = 2;
SELECT customer_id, name, dbo.GetCustomerTotalSpend(customer_id) AS total_spend
FROM Customers
ORDER BY total_spend DESC;
