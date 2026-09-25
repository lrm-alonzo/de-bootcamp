# PROJECT · Week 6 Project: End-to-End ETL Pipeline

# Goal
Build an end-to-end ETL pipeline script to fetch API records, transform the data, and load it into a PostgreSQL database.

# Features
1. Fetch API records from CoinGecko.com
2. Transform the data by:
  - Renaming columns
  - Convert data types
  - Handling invalid strings
3. Load the data into the PostgreSQL database

# How to Run
This project includes three python scripts and two sql scripts:

1. Main Run Script (main_run.py)
  - Fetches API records
  - Transforms the data
  - Creates the necessary tables
  - Inserts the transformed data into each table

2. Daily Run Script (daily_run.py)
  - Fetches API records
  - Transforms the data
  - Upserts new coins into the coins table
  - Inserts the transformed data into each table

3. Logger Setup Script (logger_setup.py)
  - Universal logger setup used by main_run.py and daily_run.py

4. Schema and Indexes Creation (creation_schema.sql)
  - Scripts on creating raw tables, dim tables, fact tables, and indexes

5. Turning raw data to cleaned data (dim_fact_insert.sql)
  - Inserting cleaned data to dim and fact tables

# Logs
- main_run_logs.log
- daily_run_logs.log