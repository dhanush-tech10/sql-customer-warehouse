-- Star schema for a small customer sales warehouse (SQLite syntax; easy to port to SQL Server)

DROP TABLE IF EXISTS fact_sales;
DROP TABLE IF EXISTS dim_customer;
DROP TABLE IF EXISTS dim_product;
DROP TABLE IF EXISTS dim_date;

CREATE TABLE dim_customer (
    customer_key INTEGER PRIMARY KEY,
    name         TEXT NOT NULL,
    city         TEXT NOT NULL,
    segment      TEXT NOT NULL            -- Retail / Corporate
);

CREATE TABLE dim_product (
    product_key  INTEGER PRIMARY KEY,
    name         TEXT NOT NULL,
    category     TEXT NOT NULL,
    unit_price   REAL NOT NULL
);

CREATE TABLE dim_date (
    date_key     INTEGER PRIMARY KEY,     -- yyyymmdd
    full_date    TEXT NOT NULL,
    year         INTEGER NOT NULL,
    quarter      INTEGER NOT NULL,
    month        INTEGER NOT NULL
);

CREATE TABLE fact_sales (
    sale_id      INTEGER PRIMARY KEY,
    customer_key INTEGER NOT NULL REFERENCES dim_customer(customer_key),
    product_key  INTEGER NOT NULL REFERENCES dim_product(product_key),
    date_key     INTEGER NOT NULL REFERENCES dim_date(date_key),
    quantity     INTEGER NOT NULL,
    amount       REAL NOT NULL
);

CREATE INDEX idx_fact_customer ON fact_sales(customer_key);
CREATE INDEX idx_fact_product  ON fact_sales(product_key);
CREATE INDEX idx_fact_date     ON fact_sales(date_key);
