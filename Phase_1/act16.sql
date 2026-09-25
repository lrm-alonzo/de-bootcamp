-- ACT 16: Query Doctor
-- Rewrite a slow query: remove SELECT *, add a WHERE filter, and identify two columns that should be indexed.



--Before

SELECT		*
FROM		orders o
INNER JOIN	customers c
			ON c.customer_id = o.customer_id;

--Index
CREATE INDEX IF NOT EXISTS idx_orders_order_date ON orders(order_date);
CREATE INDEX IF NOT EXISTS idx_orders_customer_id ON orders(customer_id);

--After
SELECT 		o.order_id,
			o.customer_id,
			c.first_name || c.last_name customer_name,
			o.order_date,
			o.total_amount
FROM		orders o
INNER JOIN 	customers c
			ON c.customer_id = o.customer_id
WHERE		o.order_date >= date '08-05-2026'
			AND o.total_amount >= 50000;