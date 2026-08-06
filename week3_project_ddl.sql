-- Table Creation Flow

--> Table: Departments
CREATE TABLE departments (
    department_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

--> Table: Stores
CREATE TABLE stores (
    store_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    store_location VARCHAR(200)
);

--> Table: Employees
CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    store_id INT REFERENCES stores(store_id),
    department_id INT REFERENCES departments(department_id),
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    position VARCHAR(50),
    email VARCHAR(100),
    phone_number VARCHAR(15),
    salary DECIMAL(10, 2)
);

--> Table: Customers
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100),
    phone_number VARCHAR(15) NOT NULL
);

--> Table: Suppliers
CREATE TABLE suppliers (
    supplier_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    contact_email VARCHAR(100),
    contact_phone VARCHAR(15) NOT NULL
);

--> Table: Products
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    supplier_id INT REFERENCES suppliers(supplier_id),
    price DECIMAL(10, 2) NOT NULL CHECK (price >= 0)
);

--> Table: Inventory
CREATE TABLE inventory (
    inventory_id SERIAL PRIMARY KEY,
    product_id INT REFERENCES products(product_id),
    store_id INT REFERENCES stores(store_id),
    quantity INT,
    reorder_flag BOOLEAN DEFAULT FALSE,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

--> Table: Orders
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    store_id INT REFERENCES stores(store_id),
    employee_id INT REFERENCES employees(employee_id),
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10, 2)
);

--> Table: Order Items
CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    product_id INT REFERENCES products(product_id),
    quantity INT,
    unit_price DECIMAL(10, 2)
);

--> Table: Invoices
CREATE TABLE invoices (
    invoice_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    issue_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    due_date TIMESTAMP,
    status VARCHAR(20) DEFAULT 'Pending'
);

--> Table: Payments
CREATE TABLE payments (
    payment_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    invoice_id INT REFERENCES invoices(invoice_id),
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    amount DECIMAL(10, 2),
    method VARCHAR(50),
    reference_number VARCHAR(100) --> e.g., transaction ID, check number, etc.
);

--> Table: Revenues
CREATE TABLE revenues (
    revenue_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    payment_id INT REFERENCES payments(payment_id),
    store_id INT REFERENCES stores(store_id),
    source VARCHAR(50), --> e.g., 'product sale', 'service fee'
    amount DECIMAL(10, 2),
    revenue_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

--> Table: Attendance
CREATE TABLE attendance (
    attendance_id SERIAL PRIMARY KEY,
    employee_id INT REFERENCES employees(employee_id),
    date DATE NOT NULL,
    check_in TIMESTAMP,
    check_out TIMESTAMP,
    hours_worked DECIMAL(5, 2),
    status VARCHAR(20) --> e.g., 'Present', 'Absent', 'On Leave'
);

--> Table: Payroll
CREATE TABLE payroll (
    payroll_id SERIAL PRIMARY KEY,
    employee_id INT REFERENCES employees(employee_id),
    month_year VARCHAR(7) NOT NULL, --> format: 'MM/YYYY'
    gross_salary DECIMAL(10, 2),
    deductions DECIMAL(10, 2),
    net_salary DECIMAL(10, 2),
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

--> Table: Expenses
CREATE TABLE expenses (
    expense_id SERIAL PRIMARY KEY,
    department_id INT REFERENCES departments(department_id),
    store_id INT REFERENCES stores(store_id),
    category VARCHAR(50), --> e.g., 'rent', 'utilities', 'supplies', 'salaries', 'marketing'
    description VARCHAR(255),
    amount DECIMAL(10, 2),
    expense_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

--> Table: Budget
CREATE TABLE budget (
    budget_id SERIAL PRIMARY KEY,
    department_id INT REFERENCES departments(department_id),
    store_id INT REFERENCES stores(store_id),
    year INT NOT NULL, --> format: 'YYYY'
    allocated_amount DECIMAL(10, 2) NOT NULL,
    spent_amount DECIMAL(10, 2) DEFAULT 0
);