-- WEEK 3 Project: Retail DB
--> Find the top 3 customers who generated the highest total revenue this month and fully paid

SELECT		c.customer_id,
			c.first_name || ' ' || c.last_name AS customer_name,
			s.name AS store_name,
			s.store_location,
			count(oi.order_id) AS product_count,
			sum(oi.quantity) AS product_total_quantity,
			o.total_amount,
			p.amount AS total_paid_amount,
			iv.status AS payment_status
FROM		customers c
INNER JOIN	orders o
			ON o.customer_id = c.customer_id
INNER JOIN 	order_items oi
			ON oi.order_id = o.order_id
INNER JOIN	stores s
			ON s.store_id = o.store_id
LEFT JOIN 	payments p
			ON p.order_id = o.order_id
LEFT JOIN	invoices iv
			ON iv.order_id = o.order_id
WHERE 		p.amount IS NOT NULL
			AND iv.status = 'Paid'
GROUP BY 	c.customer_id,
			c.first_name,
			c.last_name,
			s.name,
			s.store_location,
			o.total_amount,
			p.amount,
			iv.status
ORDER BY 	p.amount DESC
LIMIT 		3;