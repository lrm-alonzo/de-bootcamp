import os
import sys
import requests
import json
import time
import pandas as pd

from pathlib import Path
from dotenv import load_dotenv
from sqlalchemy import create_engine, text
from sqlalchemy.exc import SQLAlchemyError

# Import the universal logger
from logger_setup import get_logger

# Load .env file
load_dotenv("crypto_currency_cred.env")

# API details
API_URL = os.getenv("API_URL")

# Database details
DB_HOST = os.getenv("DB_HOST")
DB_NAME = os.getenv("DB_NAME")
DB_PORT = os.getenv("DB_PORT")
DB_USER = os.getenv("DB_USER")
DB_PASSWORD = os.getenv("DB_PASSWORD")
DATABASE_URL = f"postgresql+psycopg2://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"

engine = create_engine(DATABASE_URL)

# Logs Configuration: file + terminal
base_dir = Path("C:/Users/Lynne/Documents/CLMagno_Bootcamp/de-bootcamp/Phase_2/week6_project")
base_dir.mkdir(parents=True, exist_ok=True)
log_file = base_dir / "main_run_logs.log"

logger = get_logger("main_run", str(log_file), mode="append")

# Create Schema path
create_sql_path = base_dir / "creation_schema.sql"

# Dim and Fact Insert script path
dim_fact_sql = base_dir / "dim_fact_insert.sql"

# Extract from API with error handling
def fetch_coins(API_URL, vs_currency="usd", per_page=250, max_pages=100, delay=5):
    all_coins = []
    page = 1

    logger.info("Fetching data...")

    while page <= max_pages:
        parameters = {
            "vs_currency": vs_currency,
            "order": "market_cap_desc",
            "per_page": per_page,
            "page": page,
            "sparkline": False
        }

        try:
            logger.info("Fetching page %s...", page)
            response = requests.get(API_URL, params=parameters, timeout=30)
            response.raise_for_status()
            data = response.json()

            if not data:
                logger.info("No more data returned. Stopping pagination.")
                break

            all_coins.extend(data)
            logger.info("Page %s received with %s coins.", page, len(data))
            page += 1

            time.sleep(delay)  # polite delay

        except requests.exceptions.Timeout as err:
            logger.error("Request timed out on page %s: %s", page, err)
            raise
        except requests.exceptions.HTTPError as err:
            if response.status_code == 429:
                retry_after = response.headers.get("Retry-After")
                wait_time = int(retry_after) if retry_after else 60
                logger.warning("Rate limit hit on page %s. Waiting %s seconds before retry...", page, wait_time)
                time.sleep(wait_time)
                continue
            else:
                logger.error("HTTP error on page %s: %s", page, err)
                raise
        except requests.exceptions.RequestException as err:
            logger.error("Other request error on page %s: %s", page, err)
            raise

    if not all_coins:
        raise RuntimeError("No coins fetched. Aborting run.")

    logger.info("Total coins fetched: %s", len(all_coins))
    #print(json.dumps(all_coins[:2], indent=2))
    logger.info("Done fetching data...")
    return all_coins


# Transform with Pandas
def transform_coins(coins_data: list[dict]) -> pd.DataFrame:
    logger.info("Transforming data...")
    df = pd.DataFrame(coins_data)

    # Flatten ROI if it exists
    if "roi" in df.columns:
        roi_df = df["roi"].apply(pd.Series)
        roi_df = roi_df.rename(columns={
            "times": "roi_times",
            "currency": "roi_currency",
            "percentage": "roi_percentage"
        })
        df = pd.concat([df.drop(columns=["roi"]), roi_df], axis=1)

    # Renaming of columns
    df = df.rename(columns={"id": "coin_id"})
    df = df.rename(columns={"last_updated": "last_updated_utc"})

    # Convert types
    df["coin_id"] = df["coin_id"].fillna("Unknown").astype(str)
    df["symbol"] = df["symbol"].fillna("Unknown").astype(str)
    df["name"] = df["name"].fillna("Unknown").astype(str)
    df["image"] = df["image"].fillna("Unknown").astype(str)
    df["current_price"] = pd.to_numeric(df["current_price"], errors="coerce").fillna(0)
    df["market_cap"] = pd.to_numeric(df["market_cap"], errors="coerce").fillna(0)
    df["market_cap_rank"] = pd.to_numeric(df["market_cap_rank"], errors="coerce").fillna(0)
    df["fully_diluted_valuation"] = pd.to_numeric(df["fully_diluted_valuation"], errors="coerce").fillna(0)
    df["total_volume"] = pd.to_numeric(df["total_volume"], errors="coerce").fillna(0)
    df["high_24h"] = pd.to_numeric(df["high_24h"], errors="coerce").fillna(0)
    df["low_24h"] = pd.to_numeric(df["low_24h"], errors="coerce").fillna(0)
    df["price_change_24h"] = pd.to_numeric(df["price_change_24h"], errors="coerce").fillna(0)
    df["price_change_percentage_24h"] = pd.to_numeric(df["price_change_percentage_24h"], errors="coerce").fillna(0)
    df["market_cap_change_24h"] = pd.to_numeric(df["market_cap_change_24h"], errors="coerce").fillna(0)
    df["market_cap_change_percentage_24h"] = pd.to_numeric(df["market_cap_change_percentage_24h"], errors="coerce").fillna(0)
    df["circulating_supply"] = pd.to_numeric(df["circulating_supply"], errors="coerce").fillna(0)
    df["total_supply"] = pd.to_numeric(df["total_supply"], errors="coerce").fillna(0)
    df["max_supply"] = pd.to_numeric(df["max_supply"], errors="coerce").fillna(0)
    df["ath"] = pd.to_numeric(df["ath"], errors="coerce").fillna(0)
    df["ath_change_percentage"] = pd.to_numeric(df["ath_change_percentage"], errors="coerce").fillna(0)
    df["ath_date"] = pd.to_datetime(df["ath_date"], errors="coerce").fillna(pd.NaT)
    df["atl"] = pd.to_numeric(df["atl"], errors="coerce").fillna(0)
    df["atl_change_percentage"] = pd.to_numeric(df["atl_change_percentage"], errors="coerce").fillna(0)
    df["atl_date"] = pd.to_datetime(df["atl_date"], errors="coerce").fillna(pd.NaT)
    df["roi_times"] = pd.to_numeric(df["roi_times"], errors="coerce").fillna(0)
    df["roi_currency"] = df["roi_currency"].fillna("Unknown").astype(str)
    df["roi_percentage"] = pd.to_numeric(df["roi_percentage"], errors="coerce").fillna(0)
    df["last_updated_utc"] = pd.to_datetime(df["last_updated_utc"], errors="coerce", utc=True)

    logger.info("Total rows in DataFrame: %s", len(df))
    logger.info("Data transformation completed.")
    return df

# Load to PostgreSQL
# Create Tables
def run_create_script(create_sql_path):
    try:
        with engine.begin() as conn:
            # Test connection
            conn.execute(text("SELECT 1"))
            logger.info("Database connection successful to %s at %s:%s", DB_NAME, DB_HOST, DB_PORT)
            logger.info("Execution of Creation Schema SQL script start...")

            with open(str(create_sql_path), "r") as file:
                create_sql_script = file.read()

            conn.exec_driver_sql(create_sql_script)
            logger.info("Successfully executed Creation Schema SQL script")

    except SQLAlchemyError as e:
        logger.error("Database connection or script execution failed: %s", e)
        sys.exit(1)

# Importing raw data to database
def insert_data(coins_df=None):
    if coins_df is None:
        logger.error("No DataFrame provided for insertion.")
        return

    try:
        logger.info("Inserting records...")

        # Add inserted_at column to all rows before slicing
        coins_df = coins_df.copy()
        coins_df["inserted_at"] = pd.Timestamp.now()

        # --- Insert ALL tables (append-only, duplicates allowed) ---
        tables = {
            "raw_coins": coins_df[["coin_id", "symbol", "name", "image", "inserted_at"]],
            "raw_market_data": coins_df[["coin_id", "current_price", "market_cap", "market_cap_rank",
                                         "fully_diluted_valuation", "total_volume", "inserted_at"]],
            "raw_performance": coins_df[["coin_id", "high_24h", "low_24h", "price_change_24h",
                                         "price_change_percentage_24h", "market_cap_change_24h",
                                         "market_cap_change_percentage_24h", "inserted_at"]],
            "raw_supply": coins_df[["coin_id", "circulating_supply", "total_supply", "max_supply", "inserted_at"]],
            "raw_all_time_data": coins_df[["coin_id", "ath", "ath_change_percentage", "ath_date",
                                           "atl", "atl_change_percentage", "atl_date", "inserted_at"]],
            "raw_roi": coins_df[["coin_id", "roi_times", "roi_currency", "roi_percentage", "last_updated_utc", "inserted_at"]]
        }

        for table_name, subset in tables.items():
            subset.to_sql(table_name, engine, if_exists="append", index=False)
            logger.info("Inserted %s rows into %s table", len(subset), table_name)

            with engine.connect() as conn:
                total_rows = conn.execute(text(f"SELECT COUNT(*) FROM {table_name}")).scalar()
                logger.info("%s table now has %s rows in total", table_name, total_rows)

        logger.info("Data from API are successfully inserted into raw tables.")

    except SQLAlchemyError as e:
        logger.error("Data insertion failed: %s", e)

# Inserting records from raw to dim and fact tables
def run_dim_fact_script(dim_fact_sql):
    try:
        with engine.begin() as conn:
            logger.info("Execution of Insert Dim and Fact SQL script start...")

            with open(str(dim_fact_sql), "r") as file:
                insert_sql_script = file.read()

            conn.exec_driver_sql(insert_sql_script)
            logger.info("Successfully inserted records to Dim and Fact tables")

    except SQLAlchemyError as e:
        logger.error("Database connection or script execution failed: %s", e)
        sys.exit(1)


def main():
    try:
        logger.info("========== Main script starts ==========")
        coins_data = fetch_coins(API_URL,"usd",50,2,10) # (API_URL, vs_currency="usd", per_page=250, max_pages=100, delay=5)
        coins_df = transform_coins(coins_data)
        run_create_script(create_sql_path)
        insert_data(coins_df)
        run_dim_fact_script(dim_fact_sql)
        logger.info("========== Main script execution completed successfully! ==========")
    except Exception:
        logger.exception("========== Main script aborted due to error ==========")
        sys.exit(1)

if __name__ == "__main__":
    main()