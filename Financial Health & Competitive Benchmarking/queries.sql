CREATE DATABASE IF NOT EXISTS it_services_benchmark;
USE it_services_benchmark;

CREATE TABLE financials (
    id INT AUTO_INCREMENT PRIMARY KEY,
    company VARCHAR(20),
    year VARCHAR(10),
    revenue DECIMAL(12,2),
    net_profit DECIMAL(12,2),
    operating_margin DECIMAL(6,4),
    equity_capital DECIMAL(12,2),
    reserves DECIMAL(12,2),
    borrowings DECIMAL(12,2),
    eps DECIMAL(8,2),
    roce DECIMAL(6,4)
);

INSERT INTO financials (company, year, revenue, net_profit, operating_margin, equity_capital, reserves, borrowings, eps, roce) VALUES
('TCS', 'FY2021', 164177, 32562, 0.28, 370, 86063, 7795, 87.67, 0.47),
('TCS', 'FY2022', 191754, 38449, 0.28, 366, 88773, 7818, 104.75, 0.49),
('TCS', 'FY2023', 225458, 42303, 0.26, 366, 90058, 7688, 115.19, 0.54),
('TCS', 'FY2024', 240893, 46099, 0.27, 362, 90127, 8021, 126.88, 0.59),
('TCS', 'FY2025', 255324, 48797, 0.26, 362, 94394, 9392, 134.20, 0.64),
('Infosys', 'FY2021', 100472, 19423, 0.28, 2124, 74227, 5325, 45.42, 0.32),
('Infosys', 'FY2022', 121641, 22146, 0.26, 2098, 73252, 5474, 52.56, 0.35),
('Infosys', 'FY2023', 146767, 24108, 0.24, 2069, 73338, 8299, 58.08, 0.37),
('Infosys', 'FY2024', 153670, 26248, 0.24, 2071, 86045, 8359, 63.20, 0.40),
('Infosys', 'FY2025', 162990, 26750, 0.24, 2073, 93745, 8227, 64.32, 0.40),
('Wipro', 'FY2021', 61935, 10868, 0.24, 1096, 53805, 10451, 9.85, 0.20),
('Wipro', 'FY2022', 79312, 12243, 0.21, 1096, 64307, 17593, 11.15, 0.22),
('Wipro', 'FY2023', 90488, 11366, 0.19, 1098, 76570, 17467, 10.34, 0.21),
('Wipro', 'FY2024', 89760, 11112, 0.19, 1045, 73488, 16465, 10.57, 0.18),
('Wipro', 'FY2025', 89088, 13218, 0.20, 2094, 80270, 19204, 12.54, 0.17);

-- Derived: total equity, ROE, debt-to-equity (calculated, not hardcoded)
SELECT
    company, year, revenue, net_profit,
    (equity_capital + reserves) AS total_equity,
    ROUND(net_profit / (equity_capital + reserves) * 100, 2) AS roe_pct,
    ROUND(borrowings / (equity_capital + reserves), 4) AS debt_to_equity,
    ROUND(net_profit / revenue * 100, 2) AS net_margin_pct
FROM financials
ORDER BY company, year;

-- YoY Revenue Growth
SELECT
    company, year, revenue,
    LAG(revenue) OVER (PARTITION BY company ORDER BY year) AS prev_revenue,
    ROUND((revenue - LAG(revenue) OVER (PARTITION BY company ORDER BY year))
        / LAG(revenue) OVER (PARTITION BY company ORDER BY year) * 100, 2) AS yoy_growth_pct
FROM financials
ORDER BY company, year;

-- Rank by ROE per year
SELECT company, year,
    ROUND(net_profit / (equity_capital + reserves) * 100, 2) AS roe_pct,
    RANK() OVER (PARTITION BY year ORDER BY net_profit / (equity_capital + reserves) DESC) AS roe_rank
FROM financials
ORDER BY year, roe_rank;

-- 5-year revenue vs profit growth (who converts growth into profit best)
SELECT
    company,
    MIN(CASE WHEN year='FY2021' THEN revenue END) AS rev_fy21,
    MAX(CASE WHEN year='FY2025' THEN revenue END) AS rev_fy25,
    ROUND((MAX(CASE WHEN year='FY2025' THEN revenue END) - MIN(CASE WHEN year='FY2021' THEN revenue END))
        / MIN(CASE WHEN year='FY2021' THEN revenue END) * 100, 2) AS revenue_growth_5yr_pct,
    MIN(CASE WHEN year='FY2021' THEN net_profit END) AS profit_fy21,
    MAX(CASE WHEN year='FY2025' THEN net_profit END) AS profit_fy25,
    ROUND((MAX(CASE WHEN year='FY2025' THEN net_profit END) - MIN(CASE WHEN year='FY2021' THEN net_profit END))
        / MIN(CASE WHEN year='FY2021' THEN net_profit END) * 100, 2) AS profit_growth_5yr_pct
FROM financials
GROUP BY company;
