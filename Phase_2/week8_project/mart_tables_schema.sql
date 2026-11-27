-- Creation of Mart Tables

-- Daily Sales Performance Trend
CREATE TABLE mart_daily_sales
WITH (
    format = 'PARQUET'
)
AS
SELECT      d.order_date,
            f.order_year_month,
            SUM(f.sales) AS total_sales,
            SUM(f.profit) AS total_profit,
            COUNT(DISTINCT f.order_id) AS total_orders,
            SUM(f.sales) / COUNT(DISTINCT f.order_id) AS avg_order_value
FROM        fact_sales f
JOIN        dim_order_date d
            ON f.order_date_id = d.date_id
GROUP BY    d.order_date, f.order_year_month;

-- Monthly Sales Performance Trend
CREATE TABLE mart_monthly_sales
WITH (
    format = 'PARQUET'
)
AS
SELECT      f.order_year_month,
            SUM(f.sales) AS total_sales,
            SUM(f.profit) AS total_profit,
            COUNT(DISTINCT f.order_id) AS total_orders
FROM        fact_sales f
GROUP BY    f.order_year_month;

-- Quarterly Sales Performance Trend
CREATE TABLE mart_quarterly_sales
WITH (
    format = 'PARQUET'
)
AS
SELECT      d.year,
            d.quarter,
            SUM(f.sales) AS total_sales,
            SUM(f.profit) AS total_profit,
            COUNT(DISTINCT f.order_id) AS total_orders
FROM        fact_sales f
JOIN        dim_order_date d
            ON f.order_date_id = d.date_id
GROUP BY    d.year, d.quarter;

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
GROUP BY    p.product_id, p.product_name, p.category, p.sub_category;

-- Regional Performance
CREATE TABLE mart_regional_sales
WITH (
    format = 'PARQUET'
)
AS
SELECT      l.region,
            p.regional_manager,
            SUM(f.sales) AS total_sales,
            SUM(f.profit) AS total_profit,
            COUNT(DISTINCT f.order_id) AS total_orders
FROM        fact_sales f
JOIN        dim_location l
            ON f.location_id = l.location_id
JOIN        stg_people p
            ON l.region = p.region
GROUP BY    l.region, p.regional_manager;

