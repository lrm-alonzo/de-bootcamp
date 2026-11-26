-- Dashboard-ready SQL queries

-- Quarterly Sales Performance Trend
SELECT      d.quarter,
            SUM(f.sales) AS total_sales,
            SUM(f.profit)AS total_profit,
            COUNT(DISTINCT f.order_id) AS total_orders
FROM        fact_sales f
JOIN        dim_order_date d
            ON f.order_date_id = d.date_id
GROUP BY    d.quarter
ORDER BY    d.quarter;

-- Top Category by Revenue of 2026
SELECT      p.category,
            SUM(p.total_sales) AS total_sales,
            SUM(p.total_profit) AS total_profit
FROM        mart_product_performance p
GROUP BY    p.category
ORDER BY    total_sales DESC;


-- Top 5 City by Revenue
SELECT      l.city,
            SUM(f.sales) AS total_sales,
            SUM(f.profit) AS total_profit,
            COUNT(DISTINCT f.order_id) AS total_orders
FROM        fact_sales f
JOIN        dim_location l
            ON f.location_id = l.location_id
GROUP BY    l.city
ORDER BY    total_sales DESC
LIMIT 5;