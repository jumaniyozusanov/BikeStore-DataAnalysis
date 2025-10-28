create proc sp_CalculateStoreKPI

as 
begin 
-- 
select SUM(oi.quantity*oi.list_price*(1-oi.discount)) as Tolal_Revenue, 
		COUNT(distinct o.order_id) as Total_Orders,
		SUM(oi.quantity) Tolal_sales_volume,
		SUM(oi.quantity*oi.list_price*(1-oi.discount))* 1.00/ 
				nullif(COUNT(distinct o.order_id),0) as AOV_reveue 
	from  order_items OI
	join orders O
		ON OI.order_id = O.order_id
	Group by O.store_id


 SELECT 
        s.staff_id, 
		s.first_name +' ' + s.last_name as fullname,
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS Total_Revenue,
        COUNT(DISTINCT o.order_id) AS Total_Orders,
        SUM(oi.quantity) AS Total_Sales_Volume,
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) * 1.0 / 
			NULLIF(COUNT(DISTINCT o.order_id), 0) AS AOV_Revenue
    
	FROM Staffs S
    	left join orders O		
			ON s.staff_id = o.staff_id 
		left join order_items oi 
			ON o.order_id = oi.order_id
		
    GROUP BY s.staff_id, s.first_name +' '+ s.last_name
	ORDER BY s.staff_id
end;


 
 
 
 --•	sp_GenerateRestockList: Output low-stock items per store
 create proc sp_GenerateRestockList
 	@Threshold int =10
as

begin
 select st.store_id,
		s.store_name,
		p.product_id, 
		p.product_name, 
		st.quantity,
		c.category_name,
		CASE 
            WHEN st.quantity = 0 THEN 'Out of Stock'
            WHEN st.quantity < @Threshold THEN 'Low'
            ELSE 'Sufficient'
        END AS stock_status
from stocks st

join products p 
	on st.product_id = p.product_id
join stores s
	on st.store_id = s.store_id
join categories c 
	on p.category_id = c.category_id

where st.quantity < 10 --@Threshold
order by s.store_id
end;




create proc sp_CompareSalesYearOverYear
@Year1 int,
@Year2 int
as 
begin 
;with SalesByYear as (
 select		
		Year(o.order_date) as SalesYear, 
		SUM(oi.quantity*oi.list_price*(1-coalesce(oi.discount,0))) as Total_Revenue
 from  orders o 

 join order_items oi 
	on	o.order_id = oi.order_id
where YEAR(order_date) in (@Year1, @Year2)
group by YEAR(o.order_date)
) 

select 
	@Year1 as Year1,
	SUM(Case when SalesYear= @Year1 then Total_Revenue Else 0 End ) as Revenue_year1,

	@Year2 as Year2,
	SUM(Case when SalesYear =@Year2 then Total_Revenue Else 0 End) as Revenue_year2,

	( (SUM(Case when SalesYear= @Year1 then Total_Revenue Else 0 End )-SUM(Case when SalesYear =@Year2 then Total_Revenue  Else 0 End))*1.0/

	Nullif(SUM(Case when SalesYear =@Year2 then Total_Revenue Else 0  End),0))*100 as GrowthPercent
from SalesByYear;
END;




-- • sp_GetCustomerProfile: Returns total spend, orders, and most bought items





CREATE PROCEDURE sp_GetCustomerProfile
    @CustomerID INT
AS
BEGIN
 
    SELECT 
        c.customer_id,
        c.first_name + ' ' + c.last_name AS CustomerName,
        SUM(oi.quantity * oi.list_price * (1 - coalesce(oi.discount,0))) AS TotalSpend,
        COUNT(DISTINCT o.order_id) AS TotalOrders
    FROM customers c
    LEFT JOIN  orders o 
		ON c.customer_id = o.customer_id
    LEFT JOIN order_items oi 
		ON o.order_id = oi.order_id
    WHERE c.customer_id = @CustomerID
    GROUP BY c.customer_id, c.first_name, c.last_name;

    -- Most bought items (Top 3)
    SELECT TOP 3
        p.product_id,
        p.product_name,
        SUM(oi.quantity) AS TotalQuantity
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    WHERE o.customer_id = @CustomerID
    GROUP BY p.product_id, p.product_name
    ORDER BY SUM(oi.quantity) DESC;

END;



