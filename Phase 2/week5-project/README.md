# PROJECT · Week 5 Project: Raw Data Cleanup & Analysis Pipeline

# Goal
Create a Python-Pandas script to cleanup messy CSV file and outputs a clean CSV, summary, and pivot report.

# Features
1. Cleans raw CSV data by:
  - Renaming columns
  - Dropping duplicates
  - Convert data types
  - Handling invalid strings
  - Recalculate of missing price_per_unit, quantity, total_spent
2. Generates a clean raw CSV, summary, and pivot report

# How to Run
python data_clean_cafe_week5_proj.py

# Expected Output
Clean rows: 10000
month_year  2023-01  2023-02  2023-03  2023-04  2023-05  2023-06  2023-07  2023-08  2023-09  2023-10  2023-11  2023-12
item                                                                                                                  
Cake          855.0    684.0    801.0    816.0    843.0    777.0    717.0    834.0    867.0    951.0    927.0    762.0
Coffee        556.0    572.0    650.0    512.0    502.0    590.0    582.0    608.0    450.0    680.0    492.0    620.0
Cookie        250.0    223.0    269.0    218.0    266.0    255.0    286.0    249.0    259.0    257.0    289.0    255.0
Juice         918.0    846.0    924.0    915.0    831.0    855.0    627.0    705.0    735.0    915.0    816.0    936.0
Salad        1575.0   1200.0   1330.0   1460.0   1220.0   1505.0   1475.0   1450.0   1180.0   1420.0   1470.0   1290.0
Sandwich     1384.0   1016.0   1176.0   1028.0   1168.0   1104.0   1056.0   1024.0   1128.0    968.0    996.0   1020.0
Smoothie      756.0   1012.0    988.0   1148.0   1048.0   1140.0   1056.0   1052.0   1172.0   1108.0   1124.0   1172.0
Tea           396.0    400.5    388.5    367.5    342.0    390.0    376.5    426.0    417.0    456.0    324.0    381.0
Unknown       564.0    690.5    689.5    714.5    737.5    737.0    702.0    764.5    663.0    559.0    529.0    741.0
