-- Creation of Physical Tables for Dim and Fact
-- Used Parquet format to lower Athena query costs

CREATE TABLE dim_customer
WITH (
    format = 'PARQUET'
)
AS
SELECT DISTINCT
    customer_id,
    customer_name,
    segment
FROM stg_orders;

CREATE TABLE dim_product
WITH (
    format = 'PARQUET'
)
AS
SELECT DISTINCT
    product_id,
    product_name,
    category,
    sub_category
FROM stg_orders;



CREATE TABLE dim_location
WITH (
    format = 'PARQUET'
)
AS
SELECT DISTINCT
    CONCAT(country_region,'|',city,'|',state_province,'|',postal_code,'|',region) AS location_id,
    country_region,
    city,
    state_province,
    postal_code,
    region
FROM stg_orders;



CREATE TABLE dim_order_date
WITH (
    format = 'PARQUET'
)
AS
SELECT DISTINCT
    date_format(order_date, '%Y%m%d') AS date_id,
    order_date,
    year(order_date) AS year,
    month(order_date) AS month,
    date_format(order_date, '%M') AS month_name,
    concat('Q', cast(quarter(order_date) AS varchar)) AS quarter
FROM stg_orders;


CREATE TABLE dim_ship_date
WITH (
    format = 'PARQUET'
)
AS
SELECT DISTINCT
    date_format(ship_date, '%Y%m%d') AS date_id,
    ship_date,
    year(ship_date) AS year,
    month(ship_date) AS month,
    date_format(ship_date, '%M') AS month_name,
    concat('Q', cast(quarter(ship_date) AS varchar)) AS quarter
FROM stg_orders;



CREATE TABLE fact_sales
WITH (
    format = 'PARQUET',
    partitioned_by = ARRAY['order_year_month']
)
AS
SELECT
            o.order_id,
            date_format(o.order_date, '%Y%m%d') AS order_date_id,
            date_format(o.ship_date, '%Y%m%d') AS ship_date_id,
            o.customer_id,
            o.product_id,
            CONCAT(o.country_region, '|', o.city, '|', o.state_province, '|', o.postal_code, '|', o.region) AS location_id,
            o.ship_mode,
            o.sales,
            o.quantity,
            o.discount,
            o.profit,
            CASE
                WHEN upper(r.returned) = 'YES' THEN 'YES'
                ELSE 'NO'
            END AS is_returned,
            date_format(o.order_date, '%Y-%m') AS order_year_month
FROM        stg_orders o
LEFT JOIN   stg_returns r
            ON o.order_id = r.order_id;
            