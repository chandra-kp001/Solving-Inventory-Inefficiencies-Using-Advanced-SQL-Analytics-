
--  STEP 1: Create Database

CREATE DATABASE IF NOT EXISTS inventory_bronze_layer;

USE inventory_bronze_layer;


--  STEP 2: Create Raw Data Table (Same Structure as CSV)

DROP TABLE IF EXISTS raw_inventory_data;

CREATE TABLE raw_inventory_data (
  `Date` DATE,
  `Store_ID` VARCHAR(10),
  `Product_ID` VARCHAR(15),
  `Category` VARCHAR(50),
  `Region` VARCHAR(50),
  `Inventory_Level` INT,
  `Units_Sold` INT,
  `Units_Ordered` INT,
  `Demand_Forecast` FLOAT,
  `Price` DECIMAL(10,2),
  `Discount` DECIMAL(5,2),
  `Weather_Condition` VARCHAR(50),
  `Holiday_Promotion` BOOLEAN,
  `Competitor_Pricing` DECIMAL(10,2),
  `Seasonality` VARCHAR(50)
);