-- Creation of External Tables for Raw Data Accessibility in Athena

CREATE EXTERNAL TABLE raw_orders (
    row_id INT,
    order_id STRING,
    order_date STRING,
    ship_date STRING,
    ship_mode STRING,
    customer_id STRING,
    customer_name STRING,
    segment STRING,
    country_region STRING,
    city STRING,
    state_province STRING,
    postal_code STRING,
    region STRING,
    product_id STRING,
    category STRING,
    sub_category STRING,
    product_name STRING,
    sales DOUBLE,
    quantity INT,
    discount DOUBLE,
    profit DOUBLE
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
    "separatorChar" = ",",
    "quoteChar" = "\""
)
LOCATION 's3://lynne-data-engineering-labs/week8-Brightcart/raw/orders/'
TBLPROPERTIES (
    "skip.header.line.count"="1"
);


CREATE EXTERNAL TABLE raw_people (
    regional_manager STRING,
    region STRING
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
    "separatorChar" = ",",
    "quoteChar" = "\""
)
LOCATION 's3://lynne-data-engineering-labs/week8-Brightcart/raw/people/'
TBLPROPERTIES (
    "skip.header.line.count"="1"
);



CREATE EXTERNAL TABLE raw_returns (
    order_id STRING,
    returned STRING
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
    "separatorChar" = ",",
    "quoteChar" = "\""
)
LOCATION 's3://lynne-data-engineering-labs/week8-Brightcart/raw/returns/'
TBLPROPERTIES (
    "skip.header.line.count"="1"
);
