# ACT 9: Log Writer
# Open a file named users.csv in Append mode. Write a string "1,Alice,Engineer\n" to it.

from pathlib import Path

# Initialize the file name
file_name = Path("users_act9.csv")

with open(file_name,"a",encoding="utf-8") as f:
    f.write("1,Alice,Engineer\n")

print(f"Insert row successfully to {file_name}")