-- Dashboard-ready SQL queries

-- Monthly Sales Performance Trend
SELECT      d.month,
            d.month_name,
            ROUND(SUM(f.sales), 2) AS total_sales,
            ROUND(SUM(f.profit), 2) AS total_profit,
            COUNT(DISTINCT f.order_id) AS total_orders
FROM        fact_sales f
JOIN        dim_order_date d
            ON f.order_date_id = d.date_id
GROUP BY    d.month, d.month_name
ORDER BY    d.month;

-- Top 10 Products by Revenue of 2026
SELECT      p.product_name,
            p.category,
            ROUND(SUM(f.sales), 2) AS total_sales,
            ROUND(SUM(f.profit), 2) AS total_profit
FROM        fact_sales f
JOIN        dim_product p
            ON f.product_id = p.product_id
GROUP BY    p.product_name, p.category
ORDER BY    total_sales DESC
LIMIT 10;


-- 2026 Sales by Region
SELECT      l.region,
            ROUND(SUM(f.sales), 2) AS total_sales,
            ROUND(SUM(f.profit), 2) AS total_profit,
            COUNT(DISTINCT f.order_id) AS total_orders
FROM        fact_sales f
JOIN        dim_location l
            ON f.location_id = l.location_id
GROUP BY    l.region
ORDER BY    total_sales DESC;