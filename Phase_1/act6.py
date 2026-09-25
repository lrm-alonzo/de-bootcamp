# ACT 6: Functionize It
# Create functions for add, subtract, multiply, and divide. Then call them from a simple calculator menu.

first_num = int(input("Please enter first number: "))
sec_num = int(input("Please enter second_number: "))
operator = input("Please enter operator ( + , - , * , /): ")

# DEFINING THE FUNCTIIONS FOR THE MATHEMATICAL OPERATORS
def add(first_num,sec_num):
    return first_num + sec_num

def subtract(first_num,sec_num):
    return first_num - sec_num

def multiply(first_num,sec_num):
    return first_num * sec_num

def divide(first_num,sec_num):
    return first_num / sec_num

# CALL THE CORRECT FUNCTION BASED ON USER INPUT
if operator == "+":
    print(f"The sum is: " + str(add(first_num,sec_num)))
elif operator == "-":
    print(f"The difference is: " + str(subtract(first_num,sec_num)))
elif operator == "*":
    print(f"The product is: " + str(multiply(first_num,sec_num)))
elif operator == "/":
    print(f"The difference is: " + str(divide(first_num,sec_num)))
else:
    print ("Invalid Operator")

print("Thank you for using Calculator!")