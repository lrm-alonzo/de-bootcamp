# BrightCart 2026 Sales Cloud Data Warehouse & Analytics Dashboard
- Data Engineering Bootcamp – Phase 2, Week 8 Project
-----------------------------------------------------------------------------------
# Goal
- Build an AWS-based Cloud Data Warehouse for BrightCart's 2026 sales data using Amazon S3 and Amazon Athena.
- Design and implement a modern data warehouse architecture consisting of raw, staging, dimension, fact, and mart layers.
- Apply partitioning and Parquet-based storage optimization for analytics workloads.
- Create dashboard-ready data marts and SQL queries that support sales performance analysis and business decision-making.
-----------------------------------------------------------------------------------
# Deployment Steps
Step 1: Create an S3 Bucket and upload Source files.

Source files are stored in CSV format using UTF-8 encoding to ensure consistent character encoding and compatibility across the data pipeline.
<img width="1360" height="398" alt="image" src="https://github.com/user-attachments/assets/c627fcd6-6119-448d-a438-245febb83582" />

Step 2: Create the Data Warehouse Layers in Amazon Athena
Create external tables for the raw datasets and transform the data into a dimensional data warehouse architecture consisting of:
1. Raw Tables:
  - raw_orders
  - raw_people
  - raw_returns
2. Staging Tables:
  - stg_orders
  - stg_people
  - stg_returns
3. Dimension Tables:
  - dim_customer
  - dim_product
  - dim_location
  - dim_order_date
  - dim_ship_date
4. Fact Table
  - fact_sales: Added a returned flag for return orders by joining to stg_returns
5. Mart Tables
  - mart_daily_sales
  - mart_monthly_sales
  - mart_quarterly_sales
  - mart_product_performance
  - mart_regional_sales
  - mart_sales_city
  - mart_category

All staging, dimension, fact, and mart tables are implemented as physical tables using CTAS (CREATE TABLE AS SELECT) and stored in Parquet format.

<img width="1325" height="886" alt="image" src="https://github.com/user-attachments/assets/8bfde429-6e19-4411-8f65-ea5c2a93dde6" />

Step 3: Implement Data Warehouse Optimization
- Apply data warehouse optimization techniques to improve analytical query performance:
  - Store transformed datasets in Parquet format.
  - Partition the fact_sales table by order_year_month.
  - Use a dimensional star schema design to simplify reporting and analytics workloads.

Step 4: Build dashboard-ready SQL queries
  - SQL queries can be found here: https://github.com/lrm-alonzo/de-bootcamp/blob/master/Phase_2/week8_project/dashboard_ready_sql_queries.sql
-----------------------------------------------------------------------------------
# Optimization
Performance optimization was achieved through partitioning and Parquet columnar storage.
Bucketing was considered but not implemented

1. Partitioning:
    - Table: **fact_sales**
    - Column: **order_year_month**
    - Why: The project focuses on analyzing BrightCart's sales performance, with most reporting requirements involve analyzing sales trends over time. To support this, the fact_sales table is partitioned by order_year_month (YYYY-MM). This structure allows Athena to read only the relevant monthly partition when queries are filtered by a specific period, rather than scanning the entire dataset.
<img width="1362" height="722" alt="image" src="https://github.com/user-attachments/assets/660b32a9-fbd1-4991-9c20-33a13df2324e" />


2. Parquet Storage Format:
   - Storage Format: PARQUET
   - Why: Although Athena does not support native clustering keys, storing tables in Parquet format provides columnar storage optimization. Athena reads only the columns needed for a query, reducing the amount of data scanned and improving query performance for analytical workloads.
  
3. Bucketing Consideration:
    - Columns: **customer_id, product_id**
    - Why not used: Bucketing was considered but not implemented, as partitioning by order_year_month provides the greatest benefit for the project's date-based reporting requirements. Given the dataset size and query patterns, bucketing would add complexity with limited performance gains.
      
Benefits of Optimizing: 
  - Faster dashboard and reporting queries
  - Reduced data scanned by Athena
  - Lower query costs
  - Improved performance for monthly sales trend analysis
  - Better support for business intelligence and analytics workloads
