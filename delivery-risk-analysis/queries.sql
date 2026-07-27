CREATE DATABASE olist;
USE olist;
SHOW TABLES;
SELECT 'customers' AS table_name, COUNT(*) AS total_rows FROM olist.customers
UNION ALL
SELECT 'orders', COUNT(*) FROM olist.orders
UNION ALL
SELECT 'order_items', COUNT(*) FROM olist.order_items
UNION ALL
SELECT 'sellers', COUNT(*) FROM olist.sellers
UNION ALL
SELECT 'payments', COUNT(*) FROM olist.order_payments
UNION ALL
SELECT 'products', COUNT(*) FROM olist.products
UNION ALL
SELECT 'product_category_name_translation', COUNT(*) FROM olist.product_category
UNION ALL
SELECT 'order_reviews', COUNT(*) FROM olist.olist_order_reviews;


# Q1: What's the overall relationship between delivery delay and review score?
SELECT
    CASE
        WHEN DATEDIFF(o.order_delivered_customer_date, o.order_estimated_delivery_date) <= -7 THEN 'Very Early (7+ days)'
        WHEN DATEDIFF(o.order_delivered_customer_date, o.order_estimated_delivery_date) BETWEEN -6 AND -1 THEN 'Early'
        WHEN DATEDIFF(o.order_delivered_customer_date, o.order_estimated_delivery_date) = 0 THEN 'On Time'
        WHEN DATEDIFF(o.order_delivered_customer_date, o.order_estimated_delivery_date) BETWEEN 1 AND 7 THEN 'Late (1-7 days)'
        ELSE 'Very Late (7+ days)'
    END AS delivery_bucket,
    ROUND(AVG(r.review_score), 2) AS avg_review_score,
    COUNT(*) AS order_count
FROM olist.orders o
JOIN olist.olist_order_reviews r ON o.order_id = r.order_id
WHERE o.order_delivered_customer_date IS NOT NULL
GROUP BY delivery_bucket
ORDER BY avg_review_score DESC;
# Answer: does later delivery correlate with lower review scores, and by how much.

  
# Q2: Which sellers have the worst late-delivery rate?
SELECT
    oi.seller_id,
    COUNT(*) AS total_orders,
    SUM(CASE WHEN DATEDIFF(o.order_delivered_customer_date, o.order_estimated_delivery_date) > 0 THEN 1 ELSE 0 END) AS late_orders,
    ROUND(SUM(CASE WHEN DATEDIFF(o.order_delivered_customer_date, o.order_estimated_delivery_date) > 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS late_pct
FROM olist.orders o
JOIN olist.order_items oi ON o.order_id = oi.order_id
WHERE o.order_delivered_customer_date IS NOT NULL
GROUP BY oi.seller_id
HAVING total_orders >= 20
ORDER BY late_pct DESC
LIMIT 15;
# Answers: which sellers (with meaningful order volume) are the biggest delivery-risk contributors.


# Q3: Do late-delivering sellers also get worse reviews?
SELECT
    oi.seller_id,
    COUNT(*) AS total_orders,
    ROUND(AVG(r.review_score), 2) AS avg_review_score,
    ROUND(AVG(DATEDIFF(o.order_delivered_customer_date, o.order_estimated_delivery_date)), 1) AS avg_delay_days
FROM olist.orders o
JOIN olist.order_items oi ON o.order_id = oi.order_id
JOIN olist.olist_order_reviews r ON o.order_id = r.order_id
WHERE o.order_delivered_customer_date IS NOT NULL
GROUP BY oi.seller_id
HAVING total_orders >= 20
ORDER BY avg_review_score ASC
LIMIT 15;
# Answers: confirms whether the worst-reviewed sellers are also the ones delivering late — ties Q1 and Q2 together.


# Q4: How much revenue is tied to orders from high-risk (frequently late) sellers?
SELECT
    oi.seller_id,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.price), 2) AS total_revenue,
    ROUND(SUM(CASE WHEN DATEDIFF(o.order_delivered_customer_date, o.order_estimated_delivery_date) > 0 THEN oi.price ELSE 0 END), 2) AS revenue_from_late_orders
FROM olist.orders o
JOIN olist.order_items oi ON o.order_id = oi.order_id
WHERE o.order_delivered_customer_date IS NOT NULL
GROUP BY oi.seller_id
HAVING total_orders >= 20
ORDER BY revenue_from_late_orders DESC
LIMIT 15;
# Answers: quantifies the financial exposure — this is what turns a finding into a business recommendation ("this seller is putting ₹X in revenue at reputational risk").


# Q5: Which product categories have the most delivery problems?
SELECT
    p.product_category_name,
    COUNT(*) AS total_orders,
    ROUND(AVG(DATEDIFF(o.order_delivered_customer_date, o.order_estimated_delivery_date)), 1) AS avg_delay_days,
    ROUND(AVG(r.review_score), 2) AS avg_review_score
FROM olist.orders o
JOIN olist.order_items oi ON o.order_id = oi.order_id
JOIN olist.products p ON oi.product_id = p.product_id
JOIN olist.olist_order_reviews r ON o.order_id = r.order_id
WHERE o.order_delivered_customer_date IS NOT NULL
GROUP BY p.product_category_name
HAVING total_orders >= 50
ORDER BY avg_delay_days DESC
LIMIT 15;
# Answers: whether the delivery problem is category-specific (e.g. furniture takes longer than electronics) — useful for a "where to focus operationally" recommendation.
