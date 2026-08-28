# ACT 10: API Ping
# Write a script that uses requests.get() on an API URL, checks if status is 200, and prints the JSON.

import json
import requests

url = "https://dog.ceo/api/breeds/image/random"


try:

    response = requests.get(url, timeout=10)
    status_code = response.status_code
    data = response.json()

    if status_code == 200:
        print(json.dumps(data, indent=2)[:500])
    else:
        print(f"Request failed with status: {status_code}")

except requests.RequestException as exc:
    print(f"Network error: {exc}")