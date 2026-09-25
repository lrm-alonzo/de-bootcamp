-- RAW TABLES
CREATE TABLE IF NOT EXISTS raw_coins (
    coin_id TEXT,
    symbol TEXT NOT NULL,
    name TEXT NOT NULL,
    image TEXT,
    inserted_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS raw_market_data (
    market_data_id SERIAL PRIMARY KEY,
    coin_id TEXT,
    current_price NUMERIC,
    market_cap NUMERIC,
    market_cap_rank INT,
    fully_diluted_valuation NUMERIC,
    total_volume NUMERIC,
    inserted_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS raw_performance (
    performance_id SERIAL PRIMARY KEY,
    coin_id TEXT,
    high_24h NUMERIC,
    low_24h NUMERIC,
    price_change_24h NUMERIC,
    price_change_percentage_24h NUMERIC,
    market_cap_change_24h NUMERIC,
    market_cap_change_percentage_24h NUMERIC,
    inserted_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS raw_supply (
    supply_id SERIAL PRIMARY KEY,
    coin_id TEXT,
    circulating_supply NUMERIC,
    total_supply NUMERIC,
    max_supply NUMERIC,
    inserted_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS raw_all_time_data (
    all_time_data_id SERIAL PRIMARY KEY,
    coin_id TEXT,
    ath NUMERIC,
    ath_change_percentage NUMERIC,
    ath_date TIMESTAMP,
    atl NUMERIC,
    atl_change_percentage NUMERIC,
    atl_date TIMESTAMP,
    inserted_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS raw_roi (
    roi_id SERIAL PRIMARY KEY,
    coin_id TEXT,
    roi_times NUMERIC,
    roi_currency VARCHAR(20),
    roi_percentage NUMERIC,
    last_updated_utc TIMESTAMPTZ, --From API
    inserted_at TIMESTAMP DEFAULT NOW()
);


-- DIM TABLES
CREATE TABLE IF NOT EXISTS dim_coins (
    coin_id TEXT PRIMARY KEY,
    symbol TEXT NOT NULL,
    name TEXT NOT NULL,
    image TEXT
);


-- FACT TABLES
CREATE TABLE IF NOT EXISTS fact_market_data (
    fact_market_data_id SERIAL PRIMARY KEY,
    market_data_id INT REFERENCES raw_market_data(market_data_id),
    coin_id TEXT REFERENCES dim_coins(coin_id), -- dim reference
    current_price NUMERIC,
    market_cap NUMERIC,
    market_cap_rank INT,
    fully_diluted_valuation NUMERIC,
    total_volume NUMERIC,
    inserted_at TIMESTAMP,
    snapshot_date DATE
);

CREATE TABLE IF NOT EXISTS fact_performance (
    fact_performance_id SERIAL PRIMARY KEY,
    performance_id INT REFERENCES raw_performance(performance_id),
    coin_id TEXT REFERENCES dim_coins(coin_id),
    high_24h NUMERIC,
    low_24h NUMERIC,
    price_change_24h NUMERIC,
    price_change_percentage_24h NUMERIC,
    market_cap_change_24h NUMERIC,
    market_cap_change_percentage_24h NUMERIC,
    inserted_at TIMESTAMP,
    snapshot_date DATE
);

CREATE TABLE IF NOT EXISTS fact_supply (
    fact_supply_id SERIAL PRIMARY KEY,
    supply_id INT REFERENCES raw_supply(supply_id),
    coin_id TEXT REFERENCES dim_coins(coin_id),
    circulating_supply NUMERIC,
    total_supply NUMERIC,
    max_supply NUMERIC,
    inserted_at TIMESTAMP,
    snapshot_date DATE
);

CREATE TABLE IF NOT EXISTS fact_all_time_data (
    fact_all_time_data_id SERIAL PRIMARY KEY,
    all_time_data_id INT REFERENCES raw_all_time_data(all_time_data_id),
    coin_id TEXT REFERENCES dim_coins(coin_id),
    ath NUMERIC,
    ath_change_percentage NUMERIC,
    ath_date TIMESTAMP,
    atl NUMERIC,
    atl_change_percentage NUMERIC,
    atl_date TIMESTAMP,
    inserted_at TIMESTAMP,
    snapshot_date DATE
);

CREATE TABLE IF NOT EXISTS fact_roi (
    fact_roi_id SERIAL PRIMARY KEY,
    roi_id INT REFERENCES raw_roi(roi_id),
    coin_id TEXT REFERENCES dim_coins(coin_id),
    roi_times NUMERIC,
    roi_currency VARCHAR(20),
    roi_percentage NUMERIC,
    last_updated_utc TIMESTAMPTZ,
    inserted_at TIMESTAMP,
    snapshot_date DATE
);


--INDEXES
CREATE INDEX IF NOT EXISTS idx_raw_market_data_coin_id ON raw_market_data(coin_id);
CREATE INDEX IF NOT EXISTS idx_raw_performance_coin_id ON raw_performance(coin_id);
CREATE INDEX IF NOT EXISTS idx_raw_supply_coin_id ON raw_supply(coin_id);
CREATE INDEX IF NOT EXISTS idx_raw_all_time_data_coin_id ON raw_all_time_data(coin_id);
CREATE INDEX IF NOT EXISTS idx_raw_roi_coin_id ON raw_roi(coin_id);

CREATE INDEX IF NOT EXISTS idx_fact_market_coin_date ON fact_market_data(coin_id, snapshot_date);
CREATE INDEX IF NOT EXISTS idx_fact_performance_coin_date ON fact_performance(coin_id, snapshot_date);
CREATE INDEX IF NOT EXISTS idx_fact_supply_coin_date ON fact_supply(coin_id, snapshot_date);
CREATE INDEX IF NOT EXISTS idx_fact_all_time_coin_date ON fact_all_time_data(coin_id, snapshot_date);
CREATE INDEX IF NOT EXISTS idx_fact_roi_coin_date ON fact_roi(coin_id, snapshot_date);