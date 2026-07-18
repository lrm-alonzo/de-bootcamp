#Data Calculator

# INPUT NAME
name = input("What's your name: ")
print (f"Hi! " + name)

# INITIALIZE LOOP CONTROL
# PUT THE LOOP HERE SO THAT IT WILL START AGAIN TO ASK USER TO INPUT NUMBERS.
proceed = "Y"

# MAIN LOOP
# USED OR STATEMENT SO THAT IT WILL NOT BE CASE SENSITIVE
while proceed.lower() == "y":


    # INPUT NUMBERS AND OPERATOR
    # USED FLOAT SO THAT IF THE USER INPUT WITH DECIMAL IT WILL NOT BE ERROR
    first_num = float(input("Please enter first number: "))
    sec_num = float(input("Please enter second_number: "))
    operator = input("Please enter operator ( + , - , * , /): ")


    # DEFINE THE FUNCTIIONS FOR THE MATHEMATICAL OPERATORS
    def add(first_num,sec_num):
        return first_num + sec_num

    def subtract(first_num,sec_num):
        return first_num - sec_num

    def multiply(first_num,sec_num):
        return first_num * sec_num

    def divide(first_num,sec_num):
        return first_num / sec_num


    # CALL THE CORRECT FUNCTION BASED ON USER INPUT
    # USED STR, SINCE IT CANNOT BE CONCATINATED WITH OTHER TEXT IF THE ANSWERS ARE NOT CONVERTED TO STRING.
    if operator == "+":
        result = add(first_num,sec_num)
        print(f"The sum is: " + str(result))
    elif operator == "-":
        result = subtract(first_num,sec_num)
        print(f"The difference is: " + str(result))
    elif operator == "*":
        result = multiply(first_num,sec_num)
        print(f"The product is: " + str(result))
    elif operator == "/":
        if first_num == 0 or sec_num == 0: # GUARD AGAINST DIVISION BY 0
            print("DO NOT INPUT 0 FOR DIVISION!")
            result = None
        else:
            result = divide(first_num,sec_num)
            print(f"The quotient is: " + str(result))
    else:
        print ("Invalid Operator")
        result = None

    # LOOP TO CONTINUE USING THE RESULT
    con = "Y"
    while con.lower() == "y" and result is not None:

        con = input("Do you want to continue using the answer? (Y or N): ")

        if con.lower() == "y":
            sec_num = float(input("Please enter second number: "))
            operator = input("Please enter operator ( + , - , * , /): ")

            if operator == "+":
                result = add(result, sec_num)
                print(f"The sum is: " + str(result))
            elif operator == "-":
                result = subtract(result, sec_num)
                print(f"The difference is: " + str(result))
            elif operator == "*":
                result = multiply(result, sec_num)
                print(f"The product is: " + str(result))
            elif operator == "/":
                if sec_num == 0:
                    print("ERROR: DO NOT INPUT 0 FOR DIVISION!")
                    result = None
                else:
                    result = divide(result, sec_num)
                    print(f"The quotient is: " + str(result))
            else:
                print("Invalid Operator")
                result = None
    
    # ASK IF USER WANTS TO USE THE CALCULATOR
    # IT WILL AUTOMATICALLY EXIT THE LOOP ONCE THE INPUT FOR THIS IS NOT Y OR y
    proceed = input("Do you still want to use the calculator? (Y or N): ")

print(f"Thank you for using Calculator " + name + "!")