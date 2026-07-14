# ACT 8: User Profile
sensor = {
    "id": "T800", 
    "temp": 24.5
}

# 1. Add "battery": 85
sensor["battery"] = 85

# To check if the battery is successfully added in the list
print(sensor)

# 2. Print: "Device T800 is at 24.5"
print(f"Device {sensor["id"]} is at {sensor["temp"]}")