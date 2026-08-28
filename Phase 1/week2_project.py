# Week 2 Project: Weather Fetcher
# Build an Automated Extract-Load (EL) pipeline.
# Connect to a weather API (e.g., wttr.in), prompt for a city, extract temp/humidity from JSON, and append it to weather.csv.

import csv
import json
import sys
from datetime import datetime
from pathlib import Path

import requests

out_file = Path("weather.csv")

# FUNCTION FOR GETTING THE WEATHER CONDITION
def get_weather(city: str):
    url = f"https://wttr.in/{city}?format=j1"
    try:
        response = requests.get(url, timeout=10)
        response.raise_for_status()
        data = response.json()

        # GET WEATHER CONDITIONS
        current_condition = data["current_condition"][0]
        weather_data = {
            "City": city,
            "Temperature": current_condition.get("temp_C"),
            "Humidity": current_condition.get("humidity"),
            "Condition": current_condition["weatherDesc"][0]["value"],
        }
        
        print(f"City: {city}") 
        print("Temperature:", weather_data["Temperature"])
        print("Humidity: ", weather_data["Humidity"])
        print("Condition:", weather_data["Condition"])

        return weather_data

    except requests.RequestException as exc:
        print(f"Network error: {exc}")
        return None 

# FUNCTION TO APPEND THE OUTPUT FILE
def weather_csv_append(row: dict) -> None:
    if row is None:
        return  # Skip if no data fetched

    # Check if file exists to decide whether to write header
    file_exists = out_file.exists()

    with out_file.open("a", newline="", encoding="utf-8") as a:
        writer = csv.DictWriter(a, fieldnames=["Time Stamp", "City", "Temperature", "Humidity", "Condition"])
        if not file_exists:
            writer.writeheader()
        writer.writerow({"Time Stamp": datetime.now().isoformat(timespec="seconds"), **row})

    print(f"Insert row successfully to {out_file}")

# MAIN EXECUTION
def main_exec():
    city = sys.argv[1] if len(sys.argv) > 1 else input("Enter city: ")
    weather = get_weather(city)
    weather_csv_append(weather)
    
    if weather is not None:  # Only show if data exists
        print(json.dumps(weather, indent=2))
        print(f"Weather Data is saved to {out_file}")  

if __name__ == "__main__":
    main_exec()