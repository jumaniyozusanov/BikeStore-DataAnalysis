   -- TASK 3
---•	vw_StoreSalesSummary: Revenue, #Orders, AOV per store

-- revenue / orders / AOV per store average order value

CREATE VIEW vw_StoreSalesSummary
AS 
 SELECT O.store_id,
 COUNT( DISTINCT O.ORDER_ID) AS NUM_OF_ORDERS,
 SUM(OI.quantity*OI.list_price*(1-OI.discount)) AS TOTAL_REVENUE,
 
 CASE 
	WHEN COUNT(DISTINCT O.order_id) = 0 THEN 0
	 ELSE SUM(OI.quantity*OI.list_price*(1-Oi.discount))*1.0/COUNT(DISTINCT O.order_id)
	 END  AS OAV_PER_STORE

 FROM orders O
	JOIN order_items OI 
		ON O.order_id = OI.order_id
	GROUP BY  O.store_id

---•	vw_TopSellingProducts: Rank products by total sales

CREATE VIEW vw_TopSellingProduct
AS 

SELECT 
		OI.product_id,
		P.product_name,
		SUM(OI.quantity*OI.list_price*(1-OI.discount)) AS TOTAL_SALES ,
		DENSE_RANK() OVER (
			ORDER BY SUM(OI.quantity*OI.list_price*(1-OI.discount))  DESC
			) AS ProductRANK
FROM products P
 JOIN order_items OI 
	ON P.product_id = OI.product_id
GROUP BY OI.product_id, product_name	


-- •	vw_InventoryStatus: Items running low on stock

create view vw_InventoryStatus
as
select 
		p.product_id, 
		product_name,
		COALESCE(SUM(s.quantity),0) AS Total_quantity,
		case
			when COALESCE(SUM(s.quantity),0) = 0 then 'OutOfStock'
			when SUM(quantity) <50 then 'LowStatus'
			else 'HighStatus' 
		end as Status, 
		ROW_NUMBER() over (
			order by COALESCE(SUM(s.quantity),0) asc
			) as RowNumber
from products p

left join stocks s
	on p.product_id = s.product_id
group by p.product_id, product_name


-- •	vw_StaffPerformance: Orders and revenue handled per staff
create view vw_StaffPerformance
as
select 
		S.staff_id, first_name, 
		COUNT(DISTINCT O.order_id) AS NumOrders, 
		COALESCE(SUM(OI.quantity * OI.list_price * (1 - OI.discount)), 0) AS Revenue,
		case 
			when COUNT(DISTINCT O.order_id) = 0 then 'Employee didn`t work'
			when COUNT(DISTINCT O.order_id) <100 then 'LowPerformance'
			else 'SatisfiedPerformance'
		end as StatusPerformance,
		DENSE_RANK() over (
			order by COUNT(DISTINCT O.order_id) desc
			) as StaffRank 
from staffs S
left join orders O
	on S.staff_id = O.staff_id
left join  order_items OI
	on O.order_id = OI.order_id
group by S.staff_id, first_name

-- •	vw_RegionalTrends: Revenue by city or region


create view vw_RegionalTrends
as
select 
		city, 
		COALESCE(SUM(oi.quantity*oi.list_price*(1-oi.discount)), 0) as Regional_Revenue, 
		DENSE_RANK() over (order by SUM(quantity*list_price*(1-discount) ) desc) As CityRank
from orders O
join customers C 
	on O.customer_id =C.customer_id
join order_items OI 
	on O.order_id=OI.order_id
	Group by C.city
	


	-- •	vw_SalesByCategory: Sales volume and margin by product category

	create view vw_SalesByCategory
	as
	select C.category_id, 
			C.category_name, 
			SUM(oi.quantity) As Sales_volume, 
			SUM(oi.quantity*oi.list_price*(1-oi.discount)) as Net_Sales,
			DENSE_RANK() over (
				order by SUM(oi.quantity*oi.list_price*(1-oi.discount)) desc 
					) as Rank_category
	from products P
	join order_items OI
		on P.product_id = OI.product_id
	join categories C 
		on P.category_id = C.category_id
	group by C.category_id,C.category_name
	

	-- vw_SalesByBrand but grouped by brand instead.
	CREATE VIEW vw_SalesByBrand
AS
SELECT 
    B.brand_id,
    B.brand_name,
	 SUM(OI.quantity) as Units_Sold,
    SUM(OI.quantity * OI.list_price * (1 - OI.discount)) AS Revenue,
    COUNT(DISTINCT O.order_id) AS Num_Orders,
    DENSE_RANK() OVER (ORDER BY SUM(OI.quantity * OI.list_price * (1 - OI.discount)) DESC) AS BrandRank
FROM products P
JOIN brands B ON P.brand_id = B.brand_id
JOIN order_items OI ON P.product_id = OI.product_id
JOIN orders O ON O.order_id = OI.order_id
GROUP BY B.brand_id, B.brand_name;

create view vw_Customer_spending 
as
select SUM(OI.quantity* OI.list_price*(1-coalesce(discount,0))) * 1.0 /
		count(distinct O.customer_id) as avg_customer_spending

	from orders o
	join order_items oi
		on o.order_id = oi.order_id

