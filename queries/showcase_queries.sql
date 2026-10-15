-- 1. Revenue by make
SELECT v.make, COUNT(*) AS cars_sold, SUM(s.final_price) AS revenue
FROM Sales s
JOIN Vehicles v ON s.vehicle_id = v.vehicle_id
GROUP BY v.make
ORDER BY revenue DESC;

-- 2. Salesperson ranking (window function)
SELECT sp.name, SUM(s.final_price) AS total_sales,
       RANK() OVER (ORDER BY SUM(s.final_price) DESC) AS sales_rank
FROM Sales s
JOIN Salespeople sp ON s.salesperson_id = sp.salesperson_id
GROUP BY sp.name;

-- 3. Financed vs cash sales
SELECT CASE WHEN f.financing_id IS NULL THEN 'Cash' ELSE 'Financed' END AS payment_type,
       COUNT(*) AS num_sales,
       SUM(s.final_price) AS revenue
FROM Sales s
LEFT JOIN Financing f ON s.sale_id = f.sale_id
GROUP BY CASE WHEN f.financing_id IS NULL THEN 'Cash' ELSE 'Financed' END;

-- 4. Customers who spent more than the average customer (CTE + subquery)
WITH CustomerSpend AS (
    SELECT customer_id, SUM(final_price) AS total_spent
    FROM Sales
    GROUP BY customer_id
)
SELECT c.name, cs.total_spent
FROM CustomerSpend cs
JOIN Customers c ON c.customer_id = cs.customer_id
WHERE cs.total_spent > (SELECT AVG(total_spent) FROM CustomerSpend)
ORDER BY cs.total_spent DESC;