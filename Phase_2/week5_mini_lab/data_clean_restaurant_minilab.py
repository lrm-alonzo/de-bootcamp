import pandas as pd

# Input File path variable
import_path = r"C:\Users\Lynne\Documents\CLMagno_Bootcamp\de-bootcamp\Phase 2\restaurant_sales_data.csv"

# Output File path variable
output_path = r"C:\Users\Lynne\Documents\CLMagno_Bootcamp\de-bootcamp\Phase 2\clean_restaurant_sales.csv"
summary_path = r"C:\Users\Lynne\Documents\CLMagno_Bootcamp\de-bootcamp\Phase 2\clean_restaurant_summary.csv"

df = pd.read_csv(import_path)

# Renaming of column header
df = df.rename(columns={
    "Order ID": "order_id",
    "Customer ID": "customer_id",
    "Category": "category",
    "Item": "item",
    "Price": "price",
    "Quantity": "quantity",
    "Order Total": "order_total",
    "Order Date": "order_date",
    "Payment Method": "payment_method"
})

# Convertion of Data types and update of invalid entries to NaN
df["price"] = pd.to_numeric(df["price"], errors="coerce")
df["quantity"] = pd.to_numeric(df["quantity"], errors="coerce")
df["order_total"] = pd.to_numeric(df["order_total"], errors="coerce")
df["order_date"] = pd.to_datetime(df["order_date"], errors="coerce")

# Replace all NaN string to unknown
df["order_id"] = df["order_id"].fillna("unknown")
df["customer_id"] = df["customer_id"].fillna("unknown")
df["category"] = df["category"].fillna("unknown")
df["item"] = df["item"].fillna("unknown")
df["payment_method"] = df["payment_method"].fillna("unknown")

# Updating invalid amount of price (order_total / quantity)
df.loc[df["price"].isna(), "price"] = (df["order_total"] / df["quantity"])

# Updating invalid amount of quantity (order_total / price)
df.loc[df["quantity"].isna(), "quantity"] = (df["order_total"] / df["price"])

# Updating invalid amount of order_total (price * quantity)
df.loc[df["order_total"].isna(), "order_total"] = (df["price"] * df["quantity"])

# Extract month number
df["month_year"] = df["order_date"].dt.to_period("M").astype(str)



#print(df.info())

# Summary Report
summary_item_month_year = (
    df.groupby(["item", "month_year"], as_index=False)
      .agg({"quantity": "sum", "order_total": "sum"})
      .sort_values(by=["month_year", "item"])
)

print(summary_item_month_year.head())

df.to_csv(output_path, index=False)
summary_item_month_year.to_csv(summary_path, index=False)