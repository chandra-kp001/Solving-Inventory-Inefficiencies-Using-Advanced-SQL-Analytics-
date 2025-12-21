-- Use the target database
CREATE DATABASE IF NOT EXISTS inventory_silver_layer;
USE inventory_silver_layer;

-- ------------------------------------------------------------
-- DROP existing tables if they exist (in correct dependency order)
-- ------------------------------------------------------------
DROP TABLE IF EXISTS Forecasts;
DROP TABLE IF EXISTS Weather;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Sales;
DROP TABLE IF EXISTS Inventory;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Stores;

-- ------------------------------------------------------------
-- CREATE new normalized Silver Layer tables
-- ------------------------------------------------------------

-- Stores table (composite key)
CREATE TABLE Stores (
    store_id VARCHAR(10),
    region VARCHAR(100),
    PRIMARY KEY (store_id, region)
);

-- Products table
CREATE TABLE Products (
    product_id VARCHAR(20) PRIMARY KEY,
    category VARCHAR(100),
    price DECIMAL(10, 2),
    seasonality VARCHAR(50)
);

-- Inventory table
CREATE TABLE Inventory (
    inventory_id INT AUTO_INCREMENT PRIMARY KEY,
    store_id VARCHAR(10),
    region VARCHAR(100),
    product_id VARCHAR(20),
    date DATE,
    inventory_level INT,
    FOREIGN KEY (store_id, region) REFERENCES Stores(store_id, region),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- Sales table
CREATE TABLE Sales (
    sale_id INT AUTO_INCREMENT PRIMARY KEY,
    store_id VARCHAR(10),
    region VARCHAR(100),
    product_id VARCHAR(20),
    date DATE,
    units_sold INT,
    discount DECIMAL(5, 2),
    holiday_promotion BOOLEAN,
    competitor_pricing DECIMAL(10, 2),
    FOREIGN KEY (store_id, region) REFERENCES Stores(store_id, region),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- Orders table
CREATE TABLE Orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    store_id VARCHAR(10),
    region VARCHAR(100),
    product_id VARCHAR(20),
    date DATE,
    units_ordered INT,
    FOREIGN KEY (store_id, region) REFERENCES Stores(store_id, region),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- Weather table
CREATE TABLE Weather (
    store_id VARCHAR(10),
    region VARCHAR(100),
    date DATE,
    condition VARCHAR(50),
    PRIMARY KEY (store_id, region, date),
    FOREIGN KEY (store_id, region) REFERENCES Stores(store_id, region)
);

-- Forecasts table
CREATE TABLE Forecasts (
    forecast_id INT AUTO_INCREMENT PRIMARY KEY,
    store_id VARCHAR(10),
    region VARCHAR(100),
    product_id VARCHAR(20),
    date DATE,
    demand_forecast FLOAT,
    FOREIGN KEY (store_id, region) REFERENCES Stores(store_id, region),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

