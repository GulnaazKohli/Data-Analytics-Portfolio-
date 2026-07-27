# Telco Customer Churn Analysis

## Business Question
Which customers are at highest risk of churning, what's driving it, and how much revenue is at stake?

## Approach
Analyzed 7,032 customers using SQL (segmentation across contract type, tenure, payment method, and support services), quantified financial exposure in Excel, and built an interactive dashboard to support prioritization.

## Key Findings
- Month-to-month customers churn at **42.7%**, versus 11.3% (one-year) and 2.8% (two-year contracts).
- Highest-risk segment: month-to-month + electronic check payment churns at **53.7%**.
- Churn is **53.3%** in a customer's first 6 months, dropping to 9.5% after 4+ years — a distinct early-tenure risk window.
- Customers with both tech support and online security churn at just **9.0%**, versus **49.0%** with neither.
- Actual customer-stated churn reasons point to fixable causes: support attitude, competitor speed/data, network reliability — not just price.
- **Monthly revenue at risk: $120,847.** Retaining 20% of at-risk customers would save an estimated **$290,033 annually**.

## Recommendation
Prioritize retention outreach toward month-to-month, electronic-check-paying customers in their first 6 months. Bundle tech support and security into onboarding. Route competitor- and support-related complaints to product and service-quality teams.

## Limitations
These are observed correlations, not causal proof. A next step would be testing whether a targeted retention offer actually reduces churn in this segment.

## Tools Used
SQL (MySQL) · Excel · interactive dashboard

## Files in This Folder
- [queries.sql](./queries.sql) — all SQL queries used in the analysis
- Full write-up and dashboard screenshots: https://gulnaaz-analytics.notion.site/Project-2-Telco-Customer-Churn-Analysis-3aa31cdd201d8088b6a0dde79dd74758
