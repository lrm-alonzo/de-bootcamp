import os
import sys

from pathlib import Path
from dotenv import load_dotenv

# Import the universal logger
from logger_setup import get_logger

# Import functions from main_run.py
from main_run import fetch_coins, transform_coins, insert_data, run_dim_fact_script

# Load .env file
load_dotenv("crypto_currency_cred.env")

# API details
API_URL = os.getenv("API_URL")

# Logs Configuration: use logger_setup
base_dir = Path("C:/Users/Lynne/Documents/CLMagno_Bootcamp/de-bootcamp/Phase_2/week6_project")
base_dir.mkdir(parents=True, exist_ok=True)
log_file = base_dir / "daily_run_logs.log"

logger = get_logger("daily_run", str(log_file), mode="append")

# Dim and Fact Insert script path
dim_fact_sql = base_dir / "dim_fact_insert.sql"

def main():
    try:
        logger.info("========== Daily run starts ==========")
        coins_data = fetch_coins(API_URL,"usd",50,3,5) # (API_URL, vs_currency="usd", per_page=250, max_pages=100, delay=5)
        coins_df = transform_coins(coins_data)

        insert_data(coins_df)
        run_dim_fact_script(dim_fact_sql)

        logger.info("========== Daily run execution completed successfully! ==========")
    except Exception:
        logger.exception("Daily run aborted due to error")
        sys.exit(1)

if __name__ == "__main__":
    main()
