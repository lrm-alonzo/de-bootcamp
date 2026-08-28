import pandas as pd

# File paths
import_path = r"C:\Users\Lynne\Documents\CLMagno_Bootcamp\de-bootcamp\Phase 2\week5-project\dirty_cafe_sales.csv"
output_path = r"C:\Users\Lynne\Documents\CLMagno_Bootcamp\de-bootcamp\Phase 2\week5-project\clean_cafe_sales.csv"
summary_path = r"C:\Users\Lynne\Documents\CLMagno_Bootcamp\de-bootcamp\Phase 2\week5-project\clean_cafe_summary.csv"
pivot_path = r"C:\Users\Lynne\Documents\CLMagno_Bootcamp\de-bootcamp\Phase 2\week5-project\clean_cafe_revenue_pivot.csv"

df = pd.read_csv(import_path)

# Correct price
price_mapping = {
    "Cake": 3.0,
    "Coffee": 2.0,
    "Cookie": 1.0,
    "Juice": 3.0,
    "Salad": 5.0,
    "Sandwich": 4.0,
    "Smoothie": 4.0,
    "Tea": 1.5,
}

def clean_up(df: pd.DataFrame) -> pd.DataFrame:
    # Rename columns
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
    # Drop duplicates
    df = df.drop_duplicates(subset=["transaction_id"])
    # Convert types
    df["price_per_unit"] = pd.to_numeric(df["price_per_unit"], errors="coerce")
    df["quantity"] = pd.to_numeric(df["quantity"], errors="coerce")
    df["total_spent"] = pd.to_numeric(df["total_spent"], errors="coerce")
    df["transaction_date"] = pd.to_datetime(df["transaction_date"], errors="coerce")
    # Replace invalid strings
    df["transaction_id"] = df["transaction_id"].replace(["ERROR", "UNKNOWN", "NaN"], pd.NA)
    df["item"] = df["item"].replace(["ERROR", "UNKNOWN", "NaN"], pd.NA)
    df["payment_method"] = df["payment_method"].replace(["ERROR", "UNKNOWN", "NaN"], pd.NA)
    df["location"] = df["location"].replace(["ERROR", "UNKNOWN", "NaN"], pd.NA)
    # Fill missing values
    df["transaction_id"] = df["transaction_id"].fillna("Unknown")
    df["item"] = df["item"].fillna("Unknown")
    df["payment_method"] = df["payment_method"].fillna("Unknown")
    df["location"] = df["location"].fillna("Unknown")
    # Recalculate null fields
    df["price_per_unit"] = df["price_per_unit"].fillna(df["item"].map(price_mapping))
    df.loc[df["quantity"].isna(), "quantity"] = (df["total_spent"] / df["price_per_unit"])
    df.loc[df["total_spent"].isna(), "total_spent"] = (df["quantity"] * df["price_per_unit"])
    return df

def summarize_item_month_year(df: pd.DataFrame) -> pd.DataFrame:
    # Add month_year
    df["month_year"] = df["transaction_date"].dt.to_period("M").astype(str)
    summary = (
        df.groupby(["item", "month_year"], as_index=False)
          .agg({"quantity": "sum", "total_spent": "sum"})
          .sort_values(by=["month_year", "item"])
    )
    return summary

def summary_pivot_table(summary: pd.DataFrame) -> pd.DataFrame:
    # Revenue Pivot Table
    pivot_table = summary.pivot_table(
        index="month_year",
        columns="item",
        values="total_spent",
        aggfunc="sum"
    )
    return pivot_table

def main():
    clean_data = clean_up(df)
    summary = summarize_item_month_year(clean_data)
    pivot_table = summary_pivot_table(summary)
    print(f"Clean rows: {len(clean_data)}")
    print(summary.head())
    clean_data.to_csv(output_path, index=False)
    summary.to_csv(summary_path, index=False)
    pivot_table.to_csv(pivot_path)


if __name__ == "__main__":
    main()