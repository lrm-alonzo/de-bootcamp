-- DIM TABLES
INSERT INTO dim_coins (coin_id, symbol, name, image)
SELECT      DISTINCT 
            coin_id, 
            symbol, 
            name,
            image
FROM        raw_coins
ON          CONFLICT (coin_id) DO NOTHING;


--FACT TABLES
INSERT INTO fact_market_data (market_data_id, coin_id, current_price, market_cap, market_cap_rank, fully_diluted_valuation, total_volume, inserted_at, snapshot_date)
SELECT      DISTINCT ON (r.market_data_id, r.coin_id, r.current_price, r.market_cap,
                        r.market_cap_rank, r.fully_diluted_valuation, r.total_volume, r.inserted_at) -- removing duplicate records
            r.market_data_id,
            r.coin_id,
            r.current_price,
            r.market_cap,
            r.market_cap_rank,
            r.fully_diluted_valuation,
            r.total_volume,
            r.inserted_at,
            DATE(r.inserted_at) AS snapshot_date
FROM        raw_market_data r
LEFT JOIN   fact_market_data f
            ON f.market_data_id = r.market_data_id
WHERE       f.market_data_id IS NULL
ORDER BY    r.market_data_id;


INSERT INTO fact_performance (performance_id, coin_id, high_24h, low_24h, price_change_24h, price_change_percentage_24h,
                             market_cap_change_24h, market_cap_change_percentage_24h, inserted_at, snapshot_date)
SELECT      DISTINCT ON (r.performance_id, r.coin_id, r.high_24h, r.low_24h, r.price_change_24h, r.price_change_percentage_24h,
                        r.market_cap_change_24h, r.market_cap_change_percentage_24h, r.inserted_at)
            r.performance_id,
            r.coin_id,
            r.high_24h,
            r.low_24h,
            r.price_change_24h,
            r.price_change_percentage_24h,
            r.market_cap_change_24h,
            r.market_cap_change_percentage_24h,
            r.inserted_at,
            DATE(r.inserted_at) AS snapshot_date
FROM        raw_performance r
LEFT JOIN   fact_performance f
            ON f.performance_id = r.performance_id
WHERE       f.performance_id IS NULL
ORDER BY    r.performance_id;

INSERT INTO fact_supply (supply_id, coin_id, circulating_supply, total_supply, max_supply, inserted_at, snapshot_date)
SELECT      DISTINCT ON (r.supply_id, r.coin_id, r.circulating_supply, r.total_supply, r.max_supply, r.inserted_at)
            r.supply_id,
            r.coin_id,
            r.circulating_supply,
            r.total_supply,
            r.max_supply,
            r.inserted_at,
            DATE(r.inserted_at) AS snapshot_date
FROM        raw_supply r
LEFT JOIN   fact_supply f
            ON f.supply_id = r.supply_id
WHERE       f.supply_id IS NULL
ORDER BY    r.supply_id;

INSERT INTO fact_all_time_data (all_time_data_id, coin_id, ath, ath_change_percentage, ath_date, atl, atl_change_percentage, atl_date, inserted_at, snapshot_date)
SELECT      DISTINCT ON (r.all_time_data_id, r.coin_id, r.ath, r.ath_change_percentage, r.ath_date, r.atl, r.atl_change_percentage, r.atl_date, r.inserted_at)
            r.all_time_data_id,
            r.coin_id,
            r.ath,
            r.ath_change_percentage,
            r.ath_date,
            r.atl,
            r.atl_change_percentage,
            r.atl_date,
            r.inserted_at,
            DATE(r.inserted_at) AS snapshot_date
FROM        raw_all_time_data r
LEFT JOIN   fact_all_time_data f
            ON f.all_time_data_id = r.all_time_data_id
WHERE       f.all_time_data_id IS NULL
ORDER BY    r.all_time_data_id;

INSERT INTO fact_roi (roi_id, coin_id, roi_times, roi_currency, roi_percentage, last_updated_utc, inserted_at, snapshot_date)
SELECT      DISTINCT ON (r.roi_id, r.coin_id, r.roi_times, r.roi_currency, r.roi_percentage, r.last_updated_utc, r.inserted_at)
            r.roi_id,
            r.coin_id,
            r.roi_times,
            r.roi_currency,
            r.roi_percentage,
            r.last_updated_utc,
            r.inserted_at,
            DATE(r.inserted_at) AS snapshot_date
FROM        raw_roi r
LEFT JOIN   fact_roi f
            ON f.roi_id = r.roi_id
WHERE       f.roi_id IS NULL
ORDER BY    r.roi_id;