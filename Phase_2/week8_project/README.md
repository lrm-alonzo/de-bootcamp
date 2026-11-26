# BrightCart 2026 Sales Cloud Data Warehouse & Analytics Dashboard
- Data Engineering Bootcamp – Phase 2, Week 8 Project
-----------------------------------------------------------------------------------
# Goal
- Build an AWS-based Cloud Data Warehouse for BrightCart's 2026 sales data using Amazon S3 and Amazon Athena.
- Design and implement a modern data warehouse architecture consisting of raw, staging, dimension, fact, and mart layers.
- Apply partitioning and Parquet-based storage optimization for analytics workloads.
- Create dashboard-ready data marts and SQL queries that support sales performance analysis and business decision-making.
-----------------------------------------------------------------------------------
# Entity Relationship Diagram
<img width="951" height="688" alt="image" src="https://github.com/user-attachments/assets/561f3b30-1fa5-42df-a159-532dba3cc7af" />

-----------------------------------------------------------------------------------
# Deployment Steps
Step 1: Create an S3 Bucket and upload Source files.
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
  3.Dimension Tables:
  - dim_customer
  - dim_product
  - dim_location
  - dim_order_date
  - dim_ship_date
  4. Fact Table
  - fact_sales
  5. Mart Tables
  - mart_sales_summary
  - mart_product_performance
  - mart_regional_sales

All staging, dimension, fact, and mart tables are implemented as physical tables using CTAS (CREATE TABLE AS SELECT) and stored in Parquet format.

Step 3: Implement Data Warehouse Optimization
- Apply data warehouse optimization techniques to improve analytical query performance:
  - Store transformed datasets in Parquet format.
  - Partition the fact_sales table by order_month.
  - Use a dimensional star schema design to simplify reporting and analytics workloads.

Step 4: Build dashboard-ready SQL queries
  - SQL queries can be found here: https://github.com/lrm-alonzo/de-bootcamp/blob/master/Phase_2/week8_project/Dashboard_ready_SQL_queries.sql
-----------------------------------------------------------------------------------
# Optimization
Since Amazon Athena does not support native clustering keys, performance optimization was achieved through partitioning and Parquet columnar storage.

1. Partitioning:
    - Table: **fact_sales**
    - Column: **order_month**
    - Why: The project focuses on analyzing BrightCart's 2026 sales performance, with most reporting requirements based on monthly trends. Partitioning the fact table by order_month allows Athena to scan only the required monthly partition instead of the entire dataset, reducing query execution time and data scanned.
     
2. Parquet Storage Format:
   - Storage Format: PARQUET
   - Why: Although Athena does not support native clustering keys, storing tables in Parquet format provides columnar storage optimization. Athena reads only the columns needed for a query, reducing the amount of data scanned and improving query performance for analytical workloads.

Benefits of Optimizing: 
  - Faster dashboard and reporting queries
  - Reduced data scanned by Athena
  - Lower query costs
  - Improved performance for monthly sales trend analysis
  - Better support for business intelligence and analytics workloads
