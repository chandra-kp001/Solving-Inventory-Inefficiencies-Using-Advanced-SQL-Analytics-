-- ------------------------------------------------------------
-- INVENTORY KPI SUMMARY
-- Includes stockout rate, average inventory, and inventory age
-- ------------------------------------------------------------

-- CTE 1: Count total days and stockout days per product-store-region
WITH InventoryStatus AS (
    SELECT 
        product_id,
        store_id,
        region,
        COUNT(*) AS total_days,
        SUM(CASE WHEN inventory_level = 0 THEN 1 ELSE 0 END) AS stockout_days
    FROM Inventory
    GROUP BY product_id, store_id, region
),

-- CTE 2: Average inventory level
AvgInventory AS (
    SELECT 
        product_id,
        store_id,
        region,
        AVG(inventory_level) AS avg_inventory
    FROM Inventory
    GROUP BY product_id, store_id, region
),

-- CTE 3: Inventory age (span of days tracked)
InventoryAge AS (
    SELECT 
        product_id,
        store_id,
        region,
        DATEDIFF(MAX(date), MIN(date)) AS inventory_span_days,
        AVG(inventory_level) AS avg_inventory_age
    FROM Inventory
    GROUP BY product_id, store_id, region
)

-- Final SELECT: Combine all KPIs
SELECT 
    s.product_id,
    p.category,
    s.store_id,
    s.region,

    -- Stockout Rate (%)
    ROUND(100.0 * s.stockout_days / NULLIF(s.total_days, 0), 2) AS stockout_rate_percent,

    -- Average Inventory Level
    ROUND(a.avg_inventory, 2) AS avg_inventory_level,

    -- Inventory Age Metrics
    ia.inventory_span_days AS inventory_days_tracked,
    ROUND(ia.avg_inventory_age, 2) AS avg_inventory_age

FROM InventoryStatus s
JOIN AvgInventory a 
    ON s.product_id = a.product_id AND s.store_id = a.store_id AND s.region = a.region
JOIN InventoryAge ia 
    ON s.product_id = ia.product_id AND s.store_id = ia.store_id AND s.region = ia.region
JOIN Products p 
    ON s.product_id = p.product_id
ORDER BY stockout_rate_percent DESC;
