-- ============================================================
-- Dashboard-ready analytics views
-- ============================================================

DROP VIEW IF EXISTS monthly_revenue_summary;
DROP VIEW IF EXISTS category_revenue_summary;
DROP VIEW IF EXISTS payment_method_summary;
DROP VIEW IF EXISTS monthly_category_revenue;
DROP VIEW IF EXISTS daily_revenue_summary;
DROP VIEW IF EXISTS discount_summary_by_category;
DROP VIEW IF EXISTS data_quality_price_check;

-- 1. Monthly revenue summary
CREATE VIEW monthly_revenue_summary AS
SELECT
    purchase_month,
    COUNT(*) AS transaction_count,
    ROUND(SUM(final_price_rs), 2) AS total_revenue_rs,
    ROUND(AVG(final_price_rs), 2) AS avg_transaction_value_rs,
    ROUND(AVG(discount_pct), 2) AS avg_discount_pct,
    ROUND(SUM(discount_amount), 2) AS total_discount_amount_rs
FROM raw_purchases
GROUP BY purchase_month
ORDER BY purchase_month;


-- 2. Category revenue summary
CREATE VIEW category_revenue_summary AS
SELECT
    category,
    COUNT(*) AS transaction_count,
    ROUND(SUM(final_price_rs), 2) AS total_revenue_rs,
    ROUND(AVG(final_price_rs), 2) AS avg_transaction_value_rs,
    ROUND(AVG(discount_pct), 2) AS avg_discount_pct,
    ROUND(SUM(discount_amount), 2) AS total_discount_amount_rs
FROM raw_purchases
GROUP BY category
ORDER BY total_revenue_rs DESC;


-- 3. Payment method summary
CREATE VIEW payment_method_summary AS
SELECT
    payment_method,
    COUNT(*) AS transaction_count,
    ROUND(
        100.0 * COUNT(*) / SUM(COUNT(*)) OVER (),
        2
    ) AS transaction_share_pct,
    ROUND(SUM(final_price_rs), 2) AS total_revenue_rs,
    ROUND(AVG(final_price_rs), 2) AS avg_transaction_value_rs
FROM raw_purchases
GROUP BY payment_method
ORDER BY transaction_count DESC;


-- 4. Monthly category revenue
CREATE VIEW monthly_category_revenue AS
SELECT
    purchase_month,
    category,
    COUNT(*) AS transaction_count,
    ROUND(SUM(final_price_rs), 2) AS total_revenue_rs,
    ROUND(AVG(final_price_rs), 2) AS avg_transaction_value_rs
FROM raw_purchases
GROUP BY purchase_month, category
ORDER BY purchase_month, total_revenue_rs DESC;


-- 5. Daily revenue summary
CREATE VIEW daily_revenue_summary AS
SELECT
    purchase_date,
    COUNT(*) AS transaction_count,
    ROUND(SUM(final_price_rs), 2) AS total_revenue_rs,
    ROUND(AVG(final_price_rs), 2) AS avg_transaction_value_rs
FROM raw_purchases
GROUP BY purchase_date
ORDER BY purchase_date;


-- 6. Discount summary by category
CREATE VIEW discount_summary_by_category AS
SELECT
    category,
    COUNT(*) AS transaction_count,
    ROUND(AVG(discount_pct), 2) AS avg_discount_pct,
    ROUND(AVG(discount_amount), 2) AS avg_discount_amount_rs,
    ROUND(SUM(discount_amount), 2) AS total_discount_amount_rs,
    ROUND(AVG(final_price_rs), 2) AS avg_final_price_rs
FROM raw_purchases
GROUP BY category
ORDER BY avg_discount_pct DESC;


-- 7. Data quality price check
CREATE VIEW data_quality_price_check AS
SELECT
    COUNT(*) AS total_records,
    COUNT(*) FILTER (
        WHERE ABS(price_difference_rs) <= 1
    ) AS records_with_small_difference,
    COUNT(*) FILTER (
        WHERE ABS(price_difference_rs) > 1
    ) AS records_with_large_difference,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE ABS(price_difference_rs) > 1) / COUNT(*),
        2
    ) AS large_difference_pct,
    ROUND(AVG(price_difference_rs), 2) AS avg_price_difference_rs,
    ROUND(MIN(price_difference_rs), 2) AS min_price_difference_rs,
    ROUND(MAX(price_difference_rs), 2) AS max_price_difference_rs
FROM raw_purchases;