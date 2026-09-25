#ACT 3

cust_name = "Lynne"
cust_id = "1010"
balance = -100
#is_active = True

if balance > 0:
    is_active = True
else:
    is_active = False

print(f"{cust_name} has ${balance}")
print(f"Customer ID: {cust_id}")
print(f"Is Active: {is_active}")