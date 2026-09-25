-- TOP 5 HIGHEST PRICED CRYPTO CURRENCY FOR THE MONTH OF SEPTEMBER

SELECT		fmd.coin_id,
       		dc.symbol,
       		dc.name,
       		MAX(fmd.current_price) AS max_price
FROM 		fact_market_data fmd
INNER JOIN 	dim_coins dc
			ON fmd.coin_id = dc.coin_id
WHERE 		DATE_TRUNC('month', snapshot_date) = DATE '2026-09-01'
GROUP BY 	fmd.coin_id, dc.symbol, dc.name
ORDER BY 	max_price DESC
LIMIT 5;