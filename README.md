# Customer Sales Data Warehouse (SQL)

A small **star schema** data warehouse with sample data and analytical SQL queries.

## Schema
- `fact_sales` – one row per sale (quantity, amount)
- `dim_customer`, `dim_product`, `dim_date` – descriptive dimensions

Fact tables hold the numbers you measure. Dimension tables hold the labels you group and filter by. Joining a fact to its dimensions is how reports like "revenue by category per month" are built.

## Queries in `queries.sql`
Joins and aggregation, `LIMIT`, window functions (`RANK() OVER (PARTITION BY ...)`, running total with `SUM() OVER`), a CTE, and `NOT EXISTS`.

## Run it
Only needs Python 3 (uses the built-in `sqlite3`):

```bash
python build_warehouse.py
```

This builds `warehouse.db`, loads about 500 generated sales, and prints every query result.

## Running on SQL Server
The schema is plain SQL. To port it, change `INTEGER PRIMARY KEY` to `INT IDENTITY(1,1) PRIMARY KEY`, `TEXT` to `VARCHAR`, and `LIMIT 5` to `TOP 5`.
