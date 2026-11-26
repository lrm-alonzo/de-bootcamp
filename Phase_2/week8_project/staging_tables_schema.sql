-- Creation of Physical Tables for Staging
-- Used Parquet format to lower Athena query costs


-- Staging Orders
-- Excluded the row_id from the raw_orders due to redundancy
-- Cleaned the data from raw_orders using CAST and TRIM

CREATE TABLE stg_orders
WITH (
    format = 'PARQUET'
)
AS
SELECT
    TRIM(order_id) AS order_id,
    CAST(date_parse(order_date, '%m/%d/%Y') AS DATE) AS order_date,
    CAST(date_parse(ship_date, '%m/%d/%Y') AS DATE) AS ship_date,
    TRIM(ship_mode) AS ship_mode,
    TRIM(customer_id) AS customer_id,
    TRIM(customer_name) AS customer_name,
    TRIM(segment) AS segment,
    TRIM(country_region) AS country_region,
    TRIM(city) AS city,
    TRIM(state_province) AS state_province,
    postal_code,
    TRIM(region) AS region,
    TRIM(product_id) AS product_id,
    TRIM(category) AS category,
    TRIM(sub_category) AS sub_category,
    TRIM(product_name) AS product_name,
    CAST(sales AS DOUBLE) AS sales,
    CAST(quantity AS INTEGER) AS quantity,
    CAST(discount AS DOUBLE) AS discount,
    CAST(profit AS DOUBLE) AS profit
FROM raw_orders;



CREATE TABLE stg_people
WITH (
    format = 'PARQUET'
)
AS
SELECT
    TRIM(regional_manager) AS regional_manager,
    TRIM(region) AS region
FROM raw_people;


CREATE TABLE stg_returns
WITH (
    format = 'PARQUET'
)
AS
SELECT
    TRIM(order_id) AS order_id,
    TRIM(returned) AS returned
FROM raw_returns;