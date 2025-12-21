-- ------------------------------------------------------------
-- REORDER POINT ESTIMATION
-- Formula: ROP = Avg Daily Demand × Lead Time
-- ------------------------------------------------------------
-- Lead Time is assumed to be 7 days
-- Safety Stock buffer of +10 units shown as optional

-- Step 1: Determine the latest 30-day window based on Sales data
WITH DateRange AS (
    SELECT 
        DATE_SUB(MAX(date), INTERVAL 30 DAY) AS start_date,
        MAX(date) AS end_date
    FROM Sales
),

-- Step 2: Calculate average daily sales for each product-store-region
AvgDailySales AS (
    SELECT 
        s.store_id,
        s.region,
        s.product_id,
        AVG(s.units_sold) AS avg_daily_sales
    FROM Sales s
    JOIN DateRange d 
        ON s.date BETWEEN d.start_date AND d.end_date
    GROUP BY 
        s.store_id,
        s.region,
        s.product_id
)

-- Step 3: Compute reorder point and reorder point with safety stock
SELECT 
    ads.store_id,
    ads.region,
    ads.product_id,
    p.category,
    ROUND(ads.avg_daily_sales, 2) AS avg_daily_sales,
    ROUND(ads.avg_daily_sales * 7) AS reorder_point,
    ROUND((ads.avg_daily_sales * 7) + 10) AS reorder_point_with_safety
FROM AvgDailySales ads
JOIN Products p ON ads.product_id = p.product_id
ORDER BY reorder_point DESC;
