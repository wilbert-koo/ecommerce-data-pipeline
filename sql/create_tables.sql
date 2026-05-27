DROP TABLE IF EXISTS raw_purchases;

CREATE TABLE raw_purchases (
    user_id VARCHAR(50),
    product_id VARCHAR(50),
    category VARCHAR(100),
    price_rs NUMERIC(10, 2),
    discount_pct NUMERIC(5, 2),
    discount_amount NUMERIC(10, 2),
    final_price_rs NUMERIC(10, 2),
    payment_method VARCHAR(50),
    purchase_date DATE,
    purchase_month VARCHAR(7)
);