# Delivery Risk Analysis — Olist Marketplace

## Business Question
Does delivery performance actually drive customer satisfaction — and which sellers pose the greatest reputational and financial risk?

## Approach
Analyzed ~99,000 orders from a real Brazilian e-commerce marketplace using SQL (multi-table joins across orders, order items, sellers, and reviews), quantified findings in Excel, and visualized results in an interactive dashboard.

## Key Findings
- Review scores hold steady between early and on-time deliveries (4.31 → 4.03), but collapse to **2.71** once an order is late, and to **1.73** when very late — a drop of over 2 points on a 5-point scale.
- The single largest late-delivery seller had a **48.9% late rate**; several others exceeded 25-30%.
- Revenue tied to late deliveries across the top 10 highest-risk sellers totals **R$180,641**.
- A small group of sellers with the *worst* review scores actually deliver early — pointing to a separate, non-delivery quality issue worth investigating.

## Recommendation
Prioritize operational intervention with the top 10-15 highest-risk sellers by late-delivery rate. Separately, flag consistently low-reviewed but early-delivering sellers for a quality (not logistics) audit.

## Limitations
Findings show correlation, not proven causation. A next step would test whether controlling for product category or seller quality changes the relationship.

## Tools Used
SQL (MySQL) · Excel · Power BI

## Files in This Folder
- 'queries.sql' — all SQL queries used in the analysis
- Full write-up and dashboard screenshots: https://gulnaaz-analytics.notion.site/Project-1-Delivery-Risk-Analysis-Olist-Marketplace-3aa31cdd201d806ba310fcfebdc7eb9f
