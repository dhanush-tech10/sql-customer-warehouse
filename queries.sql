-- name: Total revenue by category
SELECT p.category, ROUND(SUM(f.amount), 2) AS revenue
FROM fact_sales f
JOIN dim_product p ON p.product_key = f.product_key
GROUP BY p.category
ORDER BY revenue DESC;

-- name: Monthly revenue trend
SELECT d.year, d.month, ROUND(SUM(f.amount), 2) AS revenue
FROM fact_sales f
JOIN dim_date d ON d.date_key = f.date_key
GROUP BY d.year, d.month
ORDER BY d.year, d.month;

-- name: Top 5 customers by spend
SELECT c.name, c.city, ROUND(SUM(f.amount), 2) AS total_spent
FROM fact_sales f
JOIN dim_customer c ON c.customer_key = f.customer_key
GROUP BY c.customer_key
ORDER BY total_spent DESC
LIMIT 5;

-- name: Rank customers within each city (window function)
SELECT city, name, total_spent,
       RANK() OVER (PARTITION BY city ORDER BY total_spent DESC) AS rank_in_city
FROM (
    SELECT c.city, c.name, ROUND(SUM(f.amount), 2) AS total_spent
    FROM fact_sales f
    JOIN dim_customer c ON c.customer_key = f.customer_key
    GROUP BY c.customer_key
)
ORDER BY city, rank_in_city;

-- name: Running total of revenue by month (window function)
WITH monthly AS (
    SELECT d.year, d.month, SUM(f.amount) AS revenue
    FROM fact_sales f
    JOIN dim_date d ON d.date_key = f.date_key
    GROUP BY d.year, d.month
)
SELECT year, month, ROUND(revenue, 2) AS revenue,
       ROUND(SUM(revenue) OVER (ORDER BY year, month), 2) AS running_total
FROM monthly
ORDER BY year, month;

-- name: Customers who never bought Electronics
SELECT c.name
FROM dim_customer c
WHERE NOT EXISTS (
    SELECT 1
    FROM fact_sales f
    JOIN dim_product p ON p.product_key = f.product_key
    WHERE f.customer_key = c.customer_key AND p.category = 'Electronics'
);
