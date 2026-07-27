CREATE DATABASE telco_churn;
USE telco_churn;
SHOW tables;
SELECT COUNT(*) FROM telco_customer_churn;
SELECT * FROM telco_customer_churn LIMIT 10;
DESCRIBE telco_customer_churn;


# Q1: Churn rate by contract type
SELECT
    `Contract`,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN `Churn Label` = 'Yes' THEN 1 ELSE 0 END) AS churned,
    ROUND(SUM(CASE WHEN `Churn Label` = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS churn_rate_pct
FROM telco_customer_churn
GROUP BY `Contract`
ORDER BY churn_rate_pct DESC;


Q2: Revenue at risk by contract type
SELECT
    `Contract`,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN `Churn Label` = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(SUM(CASE WHEN `Churn Label` = 'Yes' THEN `Monthly Charges` ELSE 0 END), 2) AS revenue_lost_monthly
FROM telco_customer_churn
GROUP BY `Contract`
ORDER BY revenue_lost_monthly DESC;


Q3: Cross-segment — contract × payment method
SELECT
    `Contract`,
    `Payment Method`,
    COUNT(*) AS total_customers,
    ROUND(SUM(CASE WHEN `Churn Label` = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS churn_rate_pct
FROM telco_customer_churn
GROUP BY `Contract`, `Payment Method`
HAVING total_customers >= 30
ORDER BY churn_rate_pct DESC
LIMIT 15;


Q4: Tenure buckets vs churn
SELECT
    CASE
        WHEN `Tenure Months` <= 6 THEN '0-6 months'
        WHEN `Tenure Months` <= 12 THEN '7-12 months'
        WHEN `Tenure Months` <= 24 THEN '1-2 years'
        WHEN `Tenure Months` <= 48 THEN '2-4 years'
        ELSE '4+ years'
    END AS tenure_bucket,
    COUNT(*) AS total_customers,
    ROUND(SUM(CASE WHEN `Churn Label` = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS churn_rate_pct
FROM telco_customer_churn
GROUP BY tenure_bucket
ORDER BY MIN(`Tenure Months`);


Q5: Add-on services vs churn
SELECT
    `Tech Support`,
    `Online Security`,
    COUNT(*) AS total_customers,
    ROUND(SUM(CASE WHEN `Churn Label` = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS churn_rate_pct
FROM telco_customer_churn
GROUP BY `Tech Support`, `Online Security`
ORDER BY churn_rate_pct DESC;


Q6: Cost-benefit projection
SELECT
    ROUND(SUM(CASE WHEN `Contract` = 'Month-to-month' AND `Churn Label` = 'Yes' THEN `Monthly Charges` ELSE 0 END), 2) AS monthly_revenue_at_risk,
    ROUND(SUM(CASE WHEN `Contract` = 'Month-to-month' AND `Churn Label` = 'Yes' THEN `Monthly Charges` ELSE 0 END) * 0.20, 2) AS estimated_savings_at_20pct_retention
FROM telco_customer_churn;


Q7: actual stated churn reasons
SELECT
    `Churn Reason`,
    COUNT(*) AS customer_count,
    ROUND(AVG(`Monthly Charges`), 2) AS avg_monthly_charges,
    ROUND(AVG(CLTV), 2) AS avg_cltv
FROM telco_customer_churn
WHERE `Churn Label` = 'Yes' AND `Churn Reason` IS NOT NULL AND `Churn Reason` != ''
GROUP BY `Churn Reason`
ORDER BY customer_count DESC
LIMIT 15;
