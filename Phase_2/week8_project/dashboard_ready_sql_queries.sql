-- Dashboard-ready SQL Queries

-- Top 5 City by Revenue
SELECT      l.city,
            l.state_province,
            SUM(f.sales) AS total_sales,
            SUM(f.profit) AS total_profit,
            COUNT(DISTINCT f.order_id) AS total_orders
FROM        fact_sales f
JOIN        dim_location l
            ON f.location_id = l.location_id
GROUP BY    l.city, l.state_province
ORDER BY    total_sales DESC
LIMIT 5;


-- Top 5 Category by Revenue
SELECT      p.category,
            SUM(p.total_sales) AS total_sales,
            SUM(p.total_profit) AS total_profit
FROM        mart_product_performance p
GROUP BY    p.category
ORDER BY    total_sales DESC
LIMIT 5;

-- Top 5 Products by Revenue
SELECT      p.product_name,
            SUM(p.total_sales) AS total_sales,
            SUM(p.total_profit) AS total_profit
FROM        mart_product_performance p
GROUP BY    p.product_name
ORDER BY    total_sales DESC
LIMIT 5;