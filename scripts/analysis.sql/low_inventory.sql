-- ------------------------------------------------------------
-- LOW INVENTORY DETECTION
-- Logic: Flag items where latest inventory < 7-day reorder point
-- Reorder Point = 7-day supply based on last 30 days average daily sales
-- ------------------------------------------------------------

-- STEP 1: Calculate latest inventory per product-store-region
WITH LatestInventory AS (
    SELECT 
        store_id,
        region,
        product_id,
        inventory_level,
        date,
        ROW_NUMBER() OVER (
            PARTITION BY store_id, region, product_id 
            ORDER BY date DESC
        ) AS rn
    FROM Inventory
),

-- STEP 2: Determine the max date from Sales, and derive 30-day window
DateRange AS (
    SELECT 
        DATE_SUB(MAX(date), INTERVAL 30 DAY) AS start_date,
        MAX(date) AS end_date
    FROM Sales
),

-- STEP 3: Compute average daily sales per product-store over last 30 days
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
        s.store_id, s.region, s.product_id
),

-- STEP 4: Multiply avg daily sales by 7 to get reorder point
ReorderPoints AS (
    SELECT 
        store_id,
        region,
        product_id,
        ROUND(avg_daily_sales * 7) AS reorder_point
    FROM AvgDailySales
)

-- STEP 5: Join latest inventory with reorder point and return low-stock items
SELECT 
    li.store_id,
    li.region,
    li.product_id,
    p.category,
    li.inventory_level,
    rp.reorder_point,
    li.date AS inventory_date
FROM LatestInventory li
JOIN ReorderPoints rp 
  ON li.store_id = rp.store_id
 AND li.region = rp.region
 AND li.product_id = rp.product_id
JOIN Products p 
  ON li.product_id = p.product_id
WHERE 
    li.rn = 1                                -- Only latest record
    AND li.inventory_level < rp.reorder_point
ORDER BY 
    li.inventory_level ASC;
