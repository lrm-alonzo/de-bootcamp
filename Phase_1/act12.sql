--ACT 12: Aggregates
--Write a query to find the total sales SUM(amount) grouped by store_location.

SELECT		s.store_id,
			s.name,
			s.store_location,
			sum(o.total_amount) AS total_sales
FROM 		stores s
INNER JOIN	orders o
			ON o.store_id = s.store_id
GROUP BY	s.store_id,
            s.name,
            s.store_location;