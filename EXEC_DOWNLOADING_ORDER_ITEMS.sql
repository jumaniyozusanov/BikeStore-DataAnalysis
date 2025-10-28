-- sp_downloding_order_items 

CREATE OR ALTER PROCEDURE sp_downloading_order_items 
as
set nocount on;

begin 

if OBJECT_ID('dbo.staging_order_items', 'U') is not null
	drop table dbo.staging_order_items;

	create table dbo.staging_order_items (
	order_id int ,
	item_id int ,
	product_id int , 
	quantity int,  
	list_price decimal(10,2),  
	discount decimal(10,2)
	);

	Bulk insert dbo.staging_order_items 
	from 'C:\Users\Lenovo\Desktop\SQL task\order_items.csv'
	with (
	    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK

	);
with cte as (
	select *,
			ROW_NUMBER() OVER (Partition by item_id order by order_id desc) as rn 
	from dbo.staging_order_items
)
	select * 
		into #clean_staging_oi
	from  cte
	where rn = 1;


	Merge dbo.order_items as Target 
	using  #clean_staging_oi as Source 
		on Target.item_id = Source.item_id
	when matched then 
		update set 
			Target.order_id = Source.order_id,
			Target.product_id = Source.product_id,
			Target.quantity = Source.quantity,
			Target.list_price = Source.list_price,
			Target.discount = Source.discount

	when not matched by Target then
		insert  (
			order_id,
			item_id,
			product_id, 
			quantity,  
			list_price,  
			discount )		
		values (
			Source.order_id,
			Source.item_id,
			Source.product_id,
			Source.quantity,
			Source.list_price,
			Source.discount		
		);

end; 
GO 
exec sp_downloading_order_items
