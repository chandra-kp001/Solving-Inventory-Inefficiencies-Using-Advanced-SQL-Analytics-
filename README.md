# Solving Inventory Inefficiencies Using Advanced SQL Analytics

## Urban Retail Co. – A Data-Driven Inventory Optimization Project

---

##  Introduction
Urban Retail Co. is a mid-sized, fast-growing retail chain operating across physical stores and e-commerce platforms. With over **5,000+ SKUs** across multiple categories and regions, the company faced significant inventory inefficiencies due to manual processes and underutilized data.

This project leverages **advanced SQL analytics** to optimize inventory management, reduce losses, and enable data-driven decision-making.

---

##  Key Challenges
-  Frequent stockouts of fast-moving products
-  Overstocking of slow-moving items
-  Limited visibility into inventory and supplier performance
-  Reactive inventory decisions instead of predictive planning

---

##  Project Objectives
- Detect inventory blind spots
- Automate reorder point calculations
- Identify inefficiencies across SKUs, stores, and regions
- Generate actionable KPIs for operational excellence

---

##  Solution Architecture
A **three-layer SQL analytics pipeline** implemented using **MySQL**:

### 1️ Bronze Layer – Raw Data Ingestion
- Database: `inventory_bronze_layer`
- Table: `raw_inventory_data`
- Scripts:
  - `bronze_ddl.sql`
  - `proc_load_bronze.sql`
- Purpose: Scalable ingestion of raw CSV data using `LOAD DATA INFILE`

---

### 2️ Silver Layer – Normalized Data Model
- Database: `inventory_silver_layer`
- Scripts:
  - `silver_ddl.sql`
  - `proc_load_silver.sql`
- Normalized tables:
  - Products
  - Stores
  - Inventory
  - Sales
  - Orders
  - Weather
  - Forecasts
- Enforced referential integrity with primary & foreign keys

####  Data Quality Checks
- Deduplication using `ROW_NUMBER()` and CTEs
- Standardization and trimming of string fields
- Unique validation of Product & Store identifiers
- Removal of duplicate weather records
- Date consistency checks across datasets

---

### 3️ Analytical Layer – Business Insights
SQL analytics implemented using modern SQL features (CTEs, window functions):

| Script | Description |
|------|------------|
| `stock_summary.sql` | Inventory rollups and under/overstock detection |
| `low_inventory.sql` | Flags low-stock SKUs using 30-day sales history |
| `reorder_point.sql` | Predictive reorder point calculation (7-day demand) |
| `turnover_ratio.sql` | Inventory turnover classification |
| `kpi_summary.sql` | Stockout rate, inventory age, and average stock |

---

---
##  Project Structure
```text
project/
│
├── bronze_ddl.sql
├── proc_load_bronze.sql
│
├── silver_ddl.sql
├── proc_load_silver.sql
│
├── analysis/
│   ├── stock_summary.sql
│   ├── low_inventory.sql
│   ├── reorder_point.sql
│   ├── turnover_ratio.sql
│   └── kpi_summary.sql

```

---

##  Business Impact
-  Real-time low stock alerts
-  Intelligent reorder recommendations
-  Fast vs slow-moving SKU classification
-  Inventory aging insights
-  KPI-driven inventory decisions
-  Reduced holding costs & improved working capital
-  Improved stock availability and customer satisfaction

---

##  Future Scope
- Integration with BI tools (Power BI, Looker, Metabase)
- Automated dashboards for inventory health monitoring
- Predictive demand forecasting extensions
