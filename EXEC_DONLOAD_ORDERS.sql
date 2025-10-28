
-- sp_orders downloding 
CREATE OR ALTER PROCEDURE sp_download_orders
as 
set nocount on;
begin 

if OBJECT_ID('dbo.staging_orders', 'U') is not null
	Drop table  dbo.staging_orders;
	-- creating staging table 
create table dbo.staging_orders (
	order_id INT,
    customer_id INT,
    order_status INT,
    order_date DATE,
    required_date DATE,
    shipped_date DATE NULL,
    store_id INT,
    staff_id INT

);
		-- inserting into staging table 
bulk insert  dbo.staging_orders
	FROM 'C:\Users\Lenovo\Desktop\SQL task\orders.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
	);

with cte as (
	Select *, 
		ROW_NUMBER() over (Partition by order_id order by order_date desc) as rn
	from staging_orders
)
	select * 
		into #clean_staging
	from cte
	where rn = 1;

	-- merging two table 
	Merge dbo.orders as Target 
	using #clean_staging as Source
		on Target.order_id = Source.order_id

	when matched then 
		update set 
			Target.customer_id   = Source.customer_id,
            Target.order_status  = Source.order_status,
            Target.order_date    = Source.order_date,
            Target.required_date = Source.required_date,
            Target.shipped_date  = Source.shipped_date,
            Target.store_id      = Source.store_id,
            Target.staff_id      = Source.staff_id

	when not matched by Target then 
		insert (order_id, customer_id, order_status, order_date,  required_date, shipped_date, store_id, staff_id)
		 values (Source.order_id, Source.customer_id, Source.order_status, Source.order_date, Source.required_date, Source.shipped_date, Source.store_id, Source.staff_id );

end; 

GO
	exec sp_download_orders
	