
-- Week 4 Project: Reporting Engine
-- Create 1 Fact and 3 Dim tables. 
-- Write an advanced stored procedure using CTEs and Window Functions to generate a monthly performance report.

--DDL
CREATE TABLE dim_customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100),
    phone_number VARCHAR(15) NOT NULL
);


CREATE TABLE dim_employees (
    employee_id SERIAL PRIMARY KEY,
    store_id INT REFERENCES stores(store_id),
    department_id INT REFERENCES departments(department_id),
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    position VARCHAR(50),
    email VARCHAR(100),
    phone_number VARCHAR(15),
    salary DECIMAL(10, 2)
);

CREATE TABLE dim_products (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    supplier_id INT REFERENCES suppliers(supplier_id),
    price DECIMAL(10, 2) NOT NULL CHECK (price >= 0)
);

CREATE TABLE dim_stores (
    store_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    store_location VARCHAR(200)
);


CREATE TABLE fact_orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    store_id INT REFERENCES stores(store_id),
    employee_id INT REFERENCES employees(employee_id),
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10, 2)
);

CREATE TABLE fact_order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    product_id INT REFERENCES products(product_id),
    quantity INT,
    unit_price DECIMAL(10, 2)
);

--PROCEDURE
CREATE OR REPLACE PROCEDURE monthly_product()
LANGUAGE plpgsql
AS $$
BEGIN
	-- Clean up records older than 5 years
    DELETE FROM monthly_product
    WHERE year::int < EXTRACT(YEAR FROM CURRENT_DATE) - 5;

	--INSERT OF NEW RECORDS
    INSERT INTO monthly_product (month_name, year, product_name, total_sales, product_rank)
    WITH monthly_product_sales AS (
        SELECT  TO_CHAR(fo.order_date, 'MONTH') AS month_name,
                TO_CHAR(fo.order_date, 'YYYY') AS year,
                fo.order_id,
                foi.product_id,
                foi.unit_price * quantity AS total_amt
        FROM    fact_orders fo
        INNER JOIN fact_order_items foi
                ON fo.order_id = foi.order_id
    ),
    monthly_product_details AS (
        SELECT  ps.month_name,
                ps.year,
                dp.name AS product_name,
                SUM(total_amt) AS total_sales
        FROM    monthly_product_sales ps
        INNER JOIN dim_products dp
                ON ps.product_id = dp.product_id
        GROUP BY ps.month_name, ps.year, dp.name
    ),
    monthly_product_ranking AS (
        SELECT  *,
                DENSE_RANK() OVER (PARTITION BY month_name, year ORDER BY total_sales DESC) AS product_rank
        FROM    monthly_product_details
    )
    SELECT month_name, year, product_name, total_sales, product_rank
    FROM monthly_product_ranking
    ORDER BY product_rank;
END;
$$;