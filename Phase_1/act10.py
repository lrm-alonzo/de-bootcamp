# ACT 10: API Ping
# Write a script that uses requests.get() on an API URL, checks if status is 200, and prints the JSON.

import json
import requests

url = "https://dog.ceo/api/breeds/image/random"

print("Fetching data...")

try:
    res = requests.get(url, timeout=10)
    
    if res.status_code == 200:
        data = res.json()
        print(json.dumps(data, indent=2)[:500])
    else:
        print(f"Request failed with status: {res.status_code}")
except requests.RequestException as exc:
    print(f"Network error: {exc}")