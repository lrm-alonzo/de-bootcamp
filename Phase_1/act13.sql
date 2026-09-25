--ACT 13: The Stitch
--Join a customers table to an orders table to print the customer name and their order date.

SELECT		c.first_name || ' ' || c.last_name AS customer_name,
			o.order_date
FROM 		customers c
INNER JOIN	orders o
			ON o.customer_id = c.customer_id
--WHERE		order_id = 1
;