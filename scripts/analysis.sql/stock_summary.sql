-- ------------------------------------------------------------
-- STOCK CALCULATIONS
-- ------------------------------------------------------------

-- Query 1: Total Stock by Product Across All Stores
SELECT 
    i.product_id,
    p.category,
    SUM(i.inventory_level) AS total_stock
FROM Inventory i
JOIN Products p ON i.product_id = p.product_id
GROUP BY i.product_id, p.category
ORDER BY total_stock DESC;

-- ------------------------------------------------------------

-- Query 2: Stock by Product and Region
SELECT 
    i.region,
    i.product_id,
    p.category,
    SUM(i.inventory_level) AS regional_stock
FROM Inventory i
JOIN Products p ON i.product_id = p.product_id
GROUP BY i.region, i.product_id, p.category
ORDER BY i.region, regional_stock DESC;

-- ------------------------------------------------------------

-- Query 3: Stock by Store (Detailed View)
SELECT 
    i.store_id,
    i.region,
    i.product_id,
    p.category,
    i.date,
    i.inventory_level
FROM Inventory i
JOIN Products p ON i.product_id = p.product_id
ORDER BY i.store_id, i.product_id, i.date DESC;
