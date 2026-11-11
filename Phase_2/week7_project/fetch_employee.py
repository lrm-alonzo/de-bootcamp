import json
import requests
import boto3
import datetime

API_URL = "https://dummyjson.com/users?limit=20"
BUCKET_NAME = "lynne-data-engineering-labs"

def fetch_employee():
    response = requests.get(API_URL, timeout=10)
    response.raise_for_status()
    data = response.json()

    # Filter fields
    filtered_users = []
    for user in data.get("users", []):
        filtered_users.append({
            "id": user.get("id"),
            "firstName": user.get("firstName"),
            "lastName": user.get("lastName"),
            "age": user.get("age"),
            "email": user.get("email"),
            "phone": user.get("phone"),
            "jobDepartment": user.get("company", {}).get("department"),
            "jobTitle": user.get("company", {}).get("title")
        })
    return filtered_users

def save_to_s3(data):
    # Generate folder name based on today’s date
    today = datetime.datetime.now().strftime("%Y-%m-%d")
    object_key = f"week7/project_employee_etl/raw/employees/{today}/employees.json"

    s3 = boto3.client("s3")
    s3.put_object(
        Bucket=BUCKET_NAME,
        Key=object_key,
        Body=json.dumps(data, indent=4),
        ContentType="application/json"
    )
    print(f"Data saved to s3://{BUCKET_NAME}/{object_key}")

def main():
    employees = fetch_employee()
    save_to_s3(employees)

if __name__ == "__main__":
    main()
