# PROJECT · Week 5 Project: Raw Data Cleanup & Analysis Pipeline

# Goal
Create a Python-Pandas script to cleanup messy CSV file and outputs a clean CSV and summary report.

# Features
1. Cleans raw CSV data by:
  - Renaming columns
  - Dropping duplicates
  - Convert data types
  - Handling invalid strings
  - Recalculate of missing price_per_unit, quantity, total_spent
2. Generates a clean raw CSV and summary report

# How to Run
python data_clean_cafe_week5_proj.py

# Expected Output
Clean rows: 10000
      item month_year  quantity  total_spent
0     Cake    2023-01     285.0        855.0
12  Coffee    2023-01     278.0        556.0
24  Cookie    2023-01     250.0        250.0
36   Juice    2023-01     306.0        918.0
48   Salad    2023-01     315.0       1575.0
