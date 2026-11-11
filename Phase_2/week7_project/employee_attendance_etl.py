import boto3
import pandas as pd
import json
import datetime
from io import StringIO

# --- Config ---
today = datetime.datetime.now().strftime("%Y-%m-%d")
BUCKET_NAME = "lynne-data-engineering-labs"
API_OBJECT_KEY = f"week7/project_employee_etl/raw/employees/{today}/employees.json"
CSV_OBJECT_KEY = f"week7/project_employee_etl/raw/attendance/{today}/attendance.csv"
OUTPUT_KEY = f"week7/project_employee_etl/combined/{today}/employee_attendance.csv"

s3 = boto3.client("s3")

# --- Extract ---
def fetch_api_json():
    response = s3.get_object(Bucket=BUCKET_NAME, Key=API_OBJECT_KEY)
    content = response["Body"].read().decode("utf-8")
    data = json.loads(content)
    employees = pd.DataFrame(data)
    print(f"Fetched {len(employees)} employees from API JSON data.")
    return employees

def fetch_csv():
    response = s3.get_object(Bucket=BUCKET_NAME, Key=CSV_OBJECT_KEY)
    csv_content = response["Body"].read().decode("utf-8")
    df = pd.read_csv(StringIO(csv_content))
    print(f"Fetched {len(df)} attendance records from CSV data.")
    return df

# --- Transform ---
def transform_data(employees, attendance):
    # Rename columns for consistency
    employees = employees.rename(columns={
        "id": "employee_id",
        "firstName": "first_name",
        "lastName": "last_name",
        "jobTitle": "job_title",
        "jobDepartment": "job_department"
    })

    # Clean employee fields
    employees["employee_id"] = employees["employee_id"].astype(str)
    employees["first_name"] = employees["first_name"].fillna("Unknown").astype(str)
    employees["last_name"] = employees["last_name"].fillna("Unknown").astype(str)
    employees["job_title"] = employees["job_title"].fillna("Unknown").astype(str)
    employees["job_department"] = employees["job_department"].fillna("Unknown").astype(str)

    # Clean attendance fields
    attendance["employee_id"] = attendance["employee_id"].astype(str)
    attendance["date"] = pd.to_datetime(attendance["date"], errors="coerce")
    attendance["check_in"] = pd.to_datetime(attendance["check_in"], errors="coerce")
    attendance["check_out"] = pd.to_datetime(attendance["check_out"], errors="coerce")

    # hours_worked calculation
    attendance["hours_worked"] = (
        (attendance["check_out"] - attendance["check_in"]).dt.total_seconds() / 3600
    ).fillna(0).round(2)

    # status calculation based on hours worked
    def get_status(hours):
        if hours == 0:
            return "Absent"
        elif hours <= 4:
            return "Half Day"
        else:
            return "Present"

    attendance["status"] = attendance["hours_worked"].apply(get_status)

    # Convertion of check_in/check_out back to time only
    attendance["check_in"] = attendance["check_in"].dt.time
    attendance["check_out"] = attendance["check_out"].dt.time

    # Add month and year columns
    attendance["month"] = attendance["date"].dt.strftime("%b")
    attendance["year"] = attendance["date"].dt.year

    # Join employees + attendance
    combined = pd.merge(employees, attendance, on="employee_id", how="left")

    # Reorder columns for Athena
    combined = combined[[
        "employee_id", "first_name", "last_name", "email", "job_title", "job_department",
        "date", "check_in", "check_out", "hours_worked", "status", "month", "year"
    ]]

    print(f"Combined dataset has {len(combined)} records.")
    return combined

# --- Load ---
def save_to_s3(df):
    csv_buffer = StringIO()
    df.to_csv(csv_buffer, index=False)
    s3.put_object(
        Bucket=BUCKET_NAME,
        Key=OUTPUT_KEY,
        Body=csv_buffer.getvalue(),
        ContentType="text/csv"
    )
    print(f"Combined dataset saved to s3://{BUCKET_NAME}/{OUTPUT_KEY}")

# --- Main ---
def main():
    print("========== ETL Process Starts ==========")
    try:
        employees = fetch_api_json()
        attendance = fetch_csv()
        combined = transform_data(employees, attendance)
        save_to_s3(combined)
        print(combined.info())
        print(combined.head())
        print("========== ETL process completed successfully ==========")
    except Exception as e:
        print(f"ETL process failed: {e}")

if __name__ == "__main__":
    main()
