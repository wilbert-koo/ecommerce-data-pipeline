-- ============================================================
-- E-commerce Purchase Analytics Queries
-- ============================================================

-- 1. Total transaction summary
-- Shows overall revenue, transaction count, average order value,
-- average discount, and total discount amount.

SELECT
    COUNT(*) AS total_transactions,
    ROUND(SUM(final_price_rs), 2) AS total_revenue_rs,
    ROUND(AVG(final_price_rs), 2) AS avg_transaction_value_rs,
    ROUND(AVG(discount_pct), 2) AS avg_discount_pct,
    ROUND(SUM(discount_amount), 2) AS total_discount_amount_rs
FROM raw_purchases;


-- 2. Monthly revenue trend
-- Shows revenue and transaction volume by month.

SELECT
    purchase_month,
    COUNT(*) AS transaction_count,
    ROUND(SUM(final_price_rs), 2) AS monthly_revenue_rs,
    ROUND(AVG(final_price_rs), 2) AS avg_transaction_value_rs
FROM raw_purchases
GROUP BY purchase_month
ORDER BY purchase_month;


-- 3. Revenue by product category
-- Identifies which categories generate the most revenue.

SELECT
    category,
    COUNT(*) AS transaction_count,
    ROUND(SUM(final_price_rs), 2) AS total_revenue_rs,
    ROUND(AVG(final_price_rs), 2) AS avg_transaction_value_rs,
    ROUND(AVG(discount_pct), 2) AS avg_discount_pct
FROM raw_purchases
GROUP BY category
ORDER BY total_revenue_rs DESC;


-- 4. Payment method distribution
-- Shows usage and revenue contribution by payment method.

SELECT
    payment_method,
    COUNT(*) AS transaction_count,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS transaction_share_pct,
    ROUND(SUM(final_price_rs), 2) AS total_revenue_rs,
    ROUND(AVG(final_price_rs), 2) AS avg_transaction_value_rs
FROM raw_purchases
GROUP BY payment_method
ORDER BY transaction_count DESC;


-- 5. Average discount by category
-- Shows which product categories receive the highest discounts.

SELECT
    category,
    COUNT(*) AS transaction_count,
    ROUND(AVG(discount_pct), 2) AS avg_discount_pct,
    ROUND(AVG(discount_amount), 2) AS avg_discount_amount_rs,
    ROUND(SUM(discount_amount), 2) AS total_discount_amount_rs
FROM raw_purchases
GROUP BY category
ORDER BY avg_discount_pct DESC;


-- 6. Highest revenue days
-- Identifies days with the highest purchase revenue.

SELECT
    purchase_date,
    COUNT(*) AS transaction_count,
    ROUND(SUM(final_price_rs), 2) AS daily_revenue_rs,
    ROUND(AVG(final_price_rs), 2) AS avg_transaction_value_rs
FROM raw_purchases
GROUP BY purchase_date
ORDER BY daily_revenue_rs DESC
LIMIT 10;


-- 7. Monthly category revenue
-- Useful for dashboard trend analysis by category.

SELECT
    purchase_month,
    category,
    COUNT(*) AS transaction_count,
    ROUND(SUM(final_price_rs), 2) AS monthly_category_revenue_rs
FROM raw_purchases
GROUP BY purchase_month, category
ORDER BY purchase_month, monthly_category_revenue_rs DESC;


-- 8. Data quality check: price consistency
-- Compares final_price_rs against the expected final price calculated
-- from price_rs and discount_pct.

SELECT
    COUNT(*) AS total_records,
    COUNT(*) FILTER (WHERE ABS(price_difference_rs) <= 1) AS records_with_small_difference,
    COUNT(*) FILTER (WHERE ABS(price_difference_rs) > 1) AS records_with_large_difference,
    ROUND(AVG(price_difference_rs), 2) AS avg_price_difference_rs,
    ROUND(MIN(price_difference_rs), 2) AS min_price_difference_rs,
    ROUND(MAX(price_difference_rs), 2) AS max_price_difference_rs
FROM raw_purchases;


-- 9. Large price discrepancy examples
-- Shows sample transactions where the listed final price differs
-- significantly from the expected discounted price.

SELECT
    user_id,
    product_id,
    category,
    price_rs,
    discount_pct,
    expected_final_price_rs,
    final_price_rs,
    price_difference_rs,
    payment_method,
    purchase_date
FROM raw_purchases
WHERE ABS(price_difference_rs) > 100
ORDER BY ABS(price_difference_rs) DESC
LIMIT 20;


-- 10. Monthly payment method trend
-- Shows how payment method usage changes over time.

SELECT
    purchase_month,
    payment_method,
    COUNT(*) AS transaction_count,
    ROUND(SUM(final_price_rs), 2) AS total_revenue_rs
FROM raw_purchases
GROUP BY purchase_month, payment_method
ORDER BY purchase_month, transaction_count DESC;