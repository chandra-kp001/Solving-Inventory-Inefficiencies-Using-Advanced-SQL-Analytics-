-- ------------------------------------------------------------
-- Products Table Insert
-- Only insert one row per unique Product ID using ROW_NUMBER
-- ------------------------------------------------------------
INSERT INTO Products (product_id, category, price, seasonality)
SELECT product_id, category, price, seasonality
FROM (
    SELECT 
        TRIM(`Product ID`) AS product_id,
        `Category` AS category,
        `Price` AS price,
        `Seasonality` AS seasonality,
        ROW_NUMBER() OVER (
            PARTITION BY TRIM(`Product ID`) 
            ORDER BY `Date`
        ) AS rn
    FROM inventory_bronze_layer.raw_inventory_data
) AS RankedProducts
WHERE rn = 1;


-- ------------------------------------------------------------
-- Stores Table Insert
-- Insert all unique (Store ID, Region) combinations
-- ------------------------------------------------------------
INSERT INTO Stores (store_id, region)
SELECT DISTINCT
    TRIM(`Store ID`), 
    `Region`
FROM inventory_bronze_layer.raw_inventory_data;


-- ------------------------------------------------------------
-- Inventory Table Insert
-- Includes store_id and region to support composite key FK
-- ------------------------------------------------------------
INSERT INTO Inventory (store_id, region, product_id, date, inventory_level)
SELECT 
    TRIM(`Store ID`), 
    `Region`,
    TRIM(`Product ID`), 
    `Date`, 
    `Inventory Level`
FROM inventory_bronze_layer.raw_inventory_data;


-- ------------------------------------------------------------
-- Sales Table Insert
-- Holiday/Promotion is cast to BIT (0 or 1 using CASE)
-- ------------------------------------------------------------
INSERT INTO Sales (
    store_id, region, product_id, date, 
    units_sold, discount, holiday_promotion, competitor_pricing
)
SELECT 
    TRIM(`Store ID`), 
    `Region`,
    TRIM(`Product ID`), 
    `Date`, 
    `Units Sold`, 
    `Discount`, 
    CASE 
        WHEN `Holiday/Promotion` IN ('1', 1, 'true', 'TRUE') THEN 1
        ELSE 0
    END AS holiday_promotion,
    `Competitor Pricing`
FROM inventory_bronze_layer.raw_inventory_data;


-- ------------------------------------------------------------
-- Orders Table Insert
-- ------------------------------------------------------------
INSERT INTO Orders (store_id, region, product_id, date, units_ordered)
SELECT 
    TRIM(`Store ID`), 
    `Region`,
    TRIM(`Product ID`), 
    `Date`, 
    `Units Ordered`
FROM inventory_bronze_layer.raw_inventory_data;


-- ------------------------------------------------------------
-- Weather Table Insert
-- Use ROW_NUMBER to deduplicate weather per store/date
-- ------------------------------------------------------------
INSERT INTO Weather (store_id, region, date, condition)
SELECT store_id, region, weather_date, condition
FROM (
    SELECT 
        TRIM(`Store ID`) AS store_id,
        `Region` AS region,
        `Date` AS weather_date,
        `Weather Condition` AS condition,
        ROW_NUMBER() OVER (
            PARTITION BY TRIM(`Store ID`), `Region`, `Date`
            ORDER BY `Weather Condition`
        ) AS rn
    FROM inventory_bronze_layer.raw_inventory_data
) AS RankedWeather
WHERE rn = 1;


-- ------------------------------------------------------------
-- Forecasts Table Insert
-- ------------------------------------------------------------
INSERT INTO Forecasts (store_id, region, product_id, date, demand_forecast)
SELECT 
    TRIM(`Store ID`), 
    `Region`,
    TRIM(`Product ID`), 
    `Date`, 
    `Demand Forecast`
FROM inventory_bronze_layer.raw_inventory_data;
