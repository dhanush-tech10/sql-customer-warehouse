"""Create warehouse.db from schema.sql, load sample data, then run every query in queries.sql."""
import random
import re
import sqlite3
from datetime import date, timedelta

random.seed(7)
conn = sqlite3.connect("warehouse.db")
conn.executescript(open("schema.sql").read())

customers = [
    ("Ravi Kumar", "Hyderabad", "Retail"), ("Anitha Reddy", "Guntur", "Retail"),
    ("Suresh Traders", "Vijayawada", "Corporate"), ("Meena Iyer", "Hyderabad", "Retail"),
    ("TechNova Pvt Ltd", "Hyderabad", "Corporate"), ("Kiran Babu", "Guntur", "Retail"),
    ("Lakshmi Stores", "Warangal", "Corporate"), ("Pavan Kalyan", "Vijayawada", "Retail"),
]
products = [
    ("Laptop", "Electronics", 55000), ("Headphones", "Electronics", 2500),
    ("Notebook", "Stationery", 60), ("Pen Pack", "Stationery", 120),
    ("Backpack", "Accessories", 1800), ("Water Bottle", "Accessories", 450),
]
conn.executemany("INSERT INTO dim_customer(name, city, segment) VALUES (?,?,?)", customers)
conn.executemany("INSERT INTO dim_product(name, category, unit_price) VALUES (?,?,?)", products)

d = date(2025, 1, 1)
while d <= date(2025, 12, 31):
    conn.execute("INSERT INTO dim_date VALUES (?,?,?,?,?)",
                 (int(d.strftime("%Y%m%d")), d.isoformat(), d.year, (d.month - 1) // 3 + 1, d.month))
    d += timedelta(days=1)

for _ in range(500):
    c = random.randint(1, len(customers))
    p = random.randint(1, len(products))
    qty = random.randint(1, 4)
    dt = date(2025, 1, 1) + timedelta(days=random.randint(0, 364))
    price = products[p - 1][2]
    conn.execute("INSERT INTO fact_sales(customer_key, product_key, date_key, quantity, amount) VALUES (?,?,?,?,?)",
                 (c, p, int(dt.strftime("%Y%m%d")), qty, qty * price))
conn.commit()

# Run each named query and print the result
blocks = re.split(r"-- name: ", open("queries.sql").read())[1:]
for block in blocks:
    title, sql = block.split("\n", 1)
    cur = conn.execute(sql)
    cols = [c[0] for c in cur.description]
    print(f"\n=== {title} ===")
    print(" | ".join(cols))
    for row in cur.fetchall()[:12]:
        print(" | ".join(str(v) for v in row))
conn.close()
