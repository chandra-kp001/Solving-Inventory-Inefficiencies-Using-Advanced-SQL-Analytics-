
-- STEP 1: Load raw data into the Bronze Layer table from CSV

-- NOTE:
-- Ensure the CSV file path is correct and accessible from MySQL server.
-- You may need to set: SET GLOBAL local_infile = 1;
-- Also check 'secure_file_priv' system variable in MySQL configuration.

-- Replace the file path below with your actual CSV file path

LOAD DATA INFILE '/Users/sachinchauhan/Desktop/sql_inventory_project/Solving-Inventory-Inefficiencies-using-Advanced-SQL-Analytics-/dataset/inventory_forecasting_clean.csv'
INTO TABLE inventory_bronze_layer.raw_inventory_data
FIELDS TERMINATED BY ','                      -- CSV column separator
ENCLOSED BY '"'                               -- Handle quoted strings
LINES TERMINATED BY '\n'                      -- Line ending style
IGNORE 1 LINES                                -- Skip the header row
(Date, Store_ID, Product_ID, Category, Region, 
 Inventory_Level, Units_Sold, Units_Ordered, 
 Demand_Forecast, Price, Discount, Weather_Condition, 
 Holiday_Promotion, Competitor_Pricing, Seasonality);


-- STEP 2: Define a stored procedure to load data from the Bronze Layer
--         into the main transactional table in the analytics database

-- Since the procedure contains multiple SQL statements, we must change
-- the default statement delimiter (which is ';') to something else.
-- We use '$$' temporarily so MySQL can parse the full procedure properly.

DELIMITER $$

USE inventory_analytics_urbanco $$

DROP PROCEDURE IF EXISTS load_bronze_to_inventory $$

CREATE PROCEDURE load_bronze_to_inventory()
BEGIN
    -- This procedure moves data from the raw staging table
    -- into the cleaned inventory_transactions table
    INSERT INTO inventory_transactions (
        Date, Store_ID, Product_ID, Inventory_Level, Units_Sold, Units_Ordered,
        Demand_Forecast, Price, Discount, Weather_Condition,
        Holiday_Promotion, Competitor_Pricing, Seasonality
    )
    SELECT
        Date, Store_ID, Product_ID, Inventory_Level, Units_Sold, Units_Ordered,
        Demand_Forecast, Price, Discount, Weather_Condition,
        Holiday_Promotion, Competitor_Pricing, Seasonality
    FROM inventory_bronze_layer.raw_inventory_data;
END $$

-- After defining the procedure, we reset the delimiter back to ';'
-- so that normal SQL statements continue to work as expected.

DELIMITER ;
