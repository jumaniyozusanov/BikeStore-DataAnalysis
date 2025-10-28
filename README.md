📊 BikeStore – SQL-Powered Retail Performance System
🧠 Project Overview

This project demonstrates a Business Intelligence (BI) workflow using SQL Server, Power BI, and Python.
The goal was to build an automated data analysis system for a fictional bike retail chain — BikeStore — that collects sales, product, and customer data across multiple branches.

Through this project, I designed a complete data pipeline — from raw CSV data to actionable business insights and KPIs — just like in a real-world data analytics environment.

🧩 Tools & Technologies

SQL Server – Data modeling, cleaning, and transformation

Python (Requests, Pandas) – Data extraction and JSON normalization

Power BI – Dashboard creation and KPI visualization

SQL Agent – Automation of ETL and scheduled reports

⚙️ Key Project Steps
1. Data Integration

Loaded .csv files (orders, customers, products, stores, etc.) into SQL Server using BULK INSERT.

Normalized tables, established foreign key relationships, and created a clean schema for analysis.

2. Data Transformation

Cleaned and enriched data using INSERT INTO … SELECT logic.

Calculated metrics such as revenue, profit margin, inventory turnover, and average order value.

3. Analytical Views

Created dynamic and reusable SQL views, including:

vw_StoreSalesSummary – Store-level performance metrics

vw_TopSellingProducts – Ranked product sales

vw_InventoryStatus – Low-stock alerts

vw_StaffPerformance – Staff contribution to sales

vw_SalesByCategory – Revenue by category and margin

4. Stored Procedures

Developed procedures for automated insights:

sp_CalculateStoreKPI

sp_CompareSalesYearOverYear

sp_GenerateRestockList

sp_GetCustomerProfile

5. Automation

Configured a SQL Server Agent Job to automatically refresh data and execute key stored procedures.

Outputs saved to reporting tables for continuous monitoring.

📈 Business KPIs
KPI	Description
Total Revenue	Overall company performance
Average Order Value (AOV)	Measures customer spending behavior
Inventory Turnover	Tracks stock movement efficiency
Revenue by Store	Identifies top/weak-performing branches
Gross Profit by Category	Detects high or low margin products
Staff Revenue Contribution	Measures individual productivity
🧮 Python Integration

Used Python (requests, json, pandas) to connect to a Supabase API, retrieve JSON data, and flatten nested columns dynamically — converting keys into structured columns for analysis.
