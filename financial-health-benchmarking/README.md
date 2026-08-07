# Project 3: TCS vs Infosys vs Wipro — Financial Health Benchmark

**Live Dashboard:** https://xbobnjrw6mrbhrac2plcgd.streamlit.app

## Business Question
Over the last 5 years (FY2021–FY2025), which of India's top 3 IT services companies has converted revenue growth into the strongest financial health — and what's driving the difference?

## Key Findings

- **TCS pulled decisively ahead on capital efficiency.** TCS's ROE climbed from 37.7% in FY2021 to 51.5% in FY2025 — a 14-point rise — while maintaining the lowest debt-to-equity of the three (~0.10x). This means TCS is generating steadily more profit per rupee of shareholder capital, without taking on more leverage to do it.

- **Infosys stayed strong but plateaued.** ROE moved in a tighter band (25.4% → 27.9%), actually dipping slightly after FY2023 as margins compressed from 28% to 24% operating margin over the period.

- **Wipro's growth stalled and its financial health weakened.** Revenue growth flattened after FY2023 (₹90,488 Cr → ₹89,088 Cr, effectively flat over 2 years), ROE *fell* from 19.8% to 16.1%, and debt-to-equity rose from 0.19x to 0.23x — the only one of the three trending the wrong way on leverage while growth stagnated.

- **Currency effects matter more than headline growth suggests.** A meaningful part of FY2023's reported revenue jump across all three companies reflects INR depreciation (~74 to ~80 INR/USD that year) rather than real business growth — the workbook includes a USD-adjusted revenue column to separate currency effects from genuine growth.

## Methodology
- Financial data manually sourced from screener.in (consolidated figures, FY2021–FY2025)
- ROE and Debt-to-Equity calculated from Balance Sheet data (Net Profit / Total Equity; Borrowings / Total Equity) rather than taken as pre-computed figures, to keep the calculation transparent and auditable
- SQL (MySQL) used for YoY growth, cross-company ranking by year, and 5-year growth comparisons
- Currency-adjusted revenue growth calculated using RBI FY-average USD/INR reference rates

## Tech Stack
- **Excel** — data structuring, ratio calculations, currency-adjustment layer
- **SQL (MySQL Workbench)** — YoY growth, ranking, and comparative queries
- **Python (Pandas, Plotly, Streamlit)** — interactive live dashboard

## How to Run Locally
pip install -r requirements.txt
streamlit run app.py

## Files
- `tcs_infosys_wipro_financials.xlsx` — full data + calculations
- `app.py` — Streamlit dashboard
- SQL queries — see `queries.sql`
