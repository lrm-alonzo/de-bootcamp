-- Creation of Mart Tables

-- Monthly Sales Performance Trend
CREATE TABLE mart_sales_summary
WITH (
    format = 'PARQUET'
)
AS
SELECT      d.year,
            d.month,
            d.month_name,
            SUM(f.sales) AS total_sales,
            SUM(f.profit) AS total_profit,
            COUNT(DISTINCT f.order_id) AS total_orders
FROM        fact_sales f
JOIN        dim_order_date d
            ON f.order_date_id = d.date_id
GROUP BY    d.year, d.month, d.month_name
ORDER BY    d.month;

-- Regional Performance
CREATE TABLE mart_regional_sales
WITH (
    format = 'PARQUET'
)
AS
SELECT      l.region,
            SUM(f.sales) AS total_sales,
            SUM(f.profit) AS total_profit,
            COUNT(DISTINCT f.order_id) AS total_orders
FROM        fact_sales f
JOIN        dim_location l
            ON f.location_id = l.location_id
GROUP BY    l.region
ORDER BY    total_sales DESC;

-- Product Performance
CREATE TABLE mart_product_performance
WITH (
    format = 'PARQUET'
)
AS
SELECT      p.product_id,
            p.product_name,
            p.category,
            p.sub_category,
            SUM(f.sales) AS total_sales,
            SUM(f.profit) AS total_profit,
            SUM(f.quantity) AS total_quantity
FROM        fact_sales f
JOIN        dim_product p
            ON f.product_id = p.product_id
GROUP BY    p.product_id, p.product_name, p.category, p.sub_category
ORDER BY    total_sales DESC;