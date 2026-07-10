name = input("What's your name?:")

print ("Hello " + name + "! Welcome to the Data Engineering Bootcamp!")
print ("This is a basic calculator that can perform addition, subtraction, multiplication, and division.")

first_number = float(input("Please enter first number:"))
second_number = float(input("Please enter second number:"))
operation = input("Please enter operation (+, -, *, /):")

if operation == "+":
    answer = first_number + second_number
    print ("The answer is: " + str(answer))
    print ("Thank you for using the calculator!")

if operation == "-":
    answer = first_number - second_number
    print ("The answer is: " + str(answer))
    print ("Thank you for using the calculator!")

if operation == "*":
    answer = first_number * second_number
    print ("The answer is: " + str(answer))
    print ("Thank you for using the calculator!")

if operation == "/":
    answer = first_number / second_number
    print ("The answer is: " + str(answer))
    print ("Thank you for using the calculator!")