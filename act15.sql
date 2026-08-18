-- ACT 15: Top Sellers
-- Use ROW_NUMBER() to assign a top 3 ranking to salesmen based on their total revenue.

WITH employee_details AS (
	SELECT		o.employee_id,
				o.order_id,
				o.store_id,
				e.first_name || ' ' || e.last_name AS employee_name
	FROM		orders o
	INNER JOIN 	employees e
				ON e.employee_id = o.employee_id
),
employee_rev AS (
	SELECT 		ed.employee_id,
				ed.employee_name,
				sum(r.amount) sales_amount
	FROM		employee_details ed
	INNER JOIN	revenues r
				ON r.order_id = ed.order_id 
				AND ed.store_id = ed.store_id		
	GROUP BY 	ed.employee_id,
				ed.employee_name
),
top_employee AS (
SELECT			er.employee_id,
				er.employee_name,
				er.sales_amount,
				ROW_NUMBER () OVER (ORDER BY sales_amount desc) rank
FROM			employee_rev er
LIMIT 			3
)
SELECT 			te.employee_id,
				te.employee_name,
				te.sales_amount,
				te.rank
FROM			top_employee te
ORDER BY		rank;

