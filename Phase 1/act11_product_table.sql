--ACT 11: Table Creation
-- Write SQL to CREATE TABLE products with id, name, and price. Then INSERT 3 rows.

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY, -- USED SERIAL FOR AUTOMATICALLY GENERATES THE SEQUENCE.
    name VARCHAR(100) NOT NULL, -- USED NOT NULL SO THAT IT WILL NOT INSERT DATA WITHOUT IT.
    category VARCHAR(50) NOT NULL,
    supplier_id INT REFERENCES suppliers(supplier_id),
    price DECIMAL(10, 2) NOT NULL CHECK (price >= 0) -- USED NUMERIC SINCE THE COLUMN IS PRICE,
	--ALSO ADDED THE CHECK CONSTRAINT SO THAT IT WILL REJECT IF THE INSERTED PRICE IS 0 OR LESS THAN. 
);

INSERT INTO products (name, category, supplier_id, price) VALUES
('Laptop', 'Electronics', 1, 40000.00),
('Smartphone', 'Electronics', 2, 55000.00),
('Headphones', 'Electronics', 3, 3000.00),
('Office Chair', 'Furniture', 1, 6500.00),
('Desk Lamp', 'Furniture', 2, 450.00);

SELECT * FROM products;


SELECT		*
FROM 		information_schema.tables c
WHERE 		c.table_schema = 'company_db'
  			AND c.table_name = 'products';