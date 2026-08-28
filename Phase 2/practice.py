import pandas as pd

# File path variable
# r = raw string, will not read the \ as new line
csv_path = r"C:\Users\Lynne\Documents\CLMagno_Bootcamp\de-bootcamp\Phase 2\dirty_cafe_sales.csv"

df = pd.read_csv(csv_path)

# Renaming of column header
df = df.rename(columns={
    "Transaction ID": "transaction_id",
    "Item": "item",
    "Quantity": "quantity",
    "Price Per Unit": "price_per_unit",
    "Total Spent": "total_spent",
    "Payment Method": "payment_method",
    "Location": "location",
    "Transaction Date": "transaction_date"
})

print(df.info())
