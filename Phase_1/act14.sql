-- ACT 14: CTE Builder
-- Write a CTE that finds all orders > 50,000, then query from that CTE.


WITH top_orders AS (
    SELECT o.customer_id, o.total_amount
    FROM orders o
    INNER JOIN invoices i ON i.order_id = o.order_id
    WHERE o.total_amount >= 50000
      AND i.status = 'Paid'
)
SELECT t.customer_id,
       c.first_name || ' ' || c.last_name AS name,
       t.total_amount
FROM top_orders t
INNER JOIN customers c ON c.customer_id = t.customer_id;


