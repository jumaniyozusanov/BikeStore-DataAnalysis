	--Business KPIs 

	create proc sp_busines_KPI
	AS
	Begin 
SELECT 'Total revenue' AS KPI,
       CAST(SUM(TOTAL_REVENUE) AS DECIMAL(18,2)) AS Value,
       'Company-wide performance' AS Business_Insight
FROM vw_StoreSalesSummary

UNION ALL

SELECT 'Average Order Value',
       CAST(avg_customer_spending AS DECIMAL(18,2)),
       'Customer spending behavior'
FROM vw_Customer_spending

UNION ALL

SELECT 'Inventory Turnover',
       CAST(SUM(oi.quantity * oi.list_price * (1 - oi.discount)) / NULLIF(AVG(s.quantity), 0) AS DECIMAL(18,2)),
       'Efficiency of stock flow'
FROM order_items oi
JOIN stocks s ON oi.product_id = s.product_id

UNION ALL

SELECT 'Top Store Revenue',
       MAX(TOTAL_REVENUE),
       'Identifies top branch'
FROM vw_StoreSalesSummary

UNION ALL

SELECT 'Lowest Store Revenue',
       MIN(TOTAL_REVENUE),
       'Identifies weak branch'
FROM vw_StoreSalesSummary

UNION ALL

SELECT 'Top Category: ' + category_name,
       Net_Sales,
       'High margin area'
FROM (
    SELECT TOP 1 category_name, Net_Sales
    FROM vw_SalesByCategory
    ORDER BY Net_Sales DESC
) HighSales

UNION ALL

SELECT 'Low Category: ' + category_name,
       Net_Sales,
       'Low margin area'
FROM (
    SELECT TOP 1 category_name, Net_Sales
    FROM vw_SalesByCategory
    ORDER BY Net_Sales ASC
) LowSales

UNION ALL

SELECT 'Top Brand: ' + brand_name,
       Revenue,
       'High Vendor Effectiveness'
FROM (
    SELECT TOP 1 brand_name, Revenue
    FROM vw_SalesByBrand
    ORDER BY Revenue DESC
) HighBrand

UNION ALL

SELECT 'Low Brand: ' + brand_name,
       Revenue,
       'Low Vendor Effectiveness'
FROM (
    SELECT TOP 1 brand_name, Revenue
    FROM vw_SalesByBrand
    ORDER BY Revenue ASC
) LowBrand


union all

	-- Staff Revenue Contribution	Productivity tracking
-- Staff Revenue Contribution (Productivity tracking)
SELECT 'Top Staff: ' + first_name AS KPI,
       Revenue,
       'Top Revenue Contributor - Productivity tracking' AS Business_Insight
FROM (
    SELECT TOP 1 first_name, Revenue
    FROM vw_StaffPerformance
    ORDER BY Revenue DESC
) TopStaff

UNION ALL

SELECT 'Low Staff: ' + first_name,
       Revenue,
       'Lowest Revenue Contributor - Productivity tracking'
FROM (
    SELECT TOP 1 first_name, Revenue
    FROM vw_StaffPerformance
    ORDER BY Revenue ASC
) LowStaff;
End;
Exec sp_busines_KPI
