create table customers (customer_id int primary key,  first_name VARCHAR(50),  last_name VARCHAR(50),  phone varchar(50),  email VARCHAR(100),  street VARCHAR(50),  city VARCHAR(50),  state VARCHAR(50),  zip_code varchar(10) );

BULK INSERT  customers 
from 'C:\Users\Lenovo\Desktop\Project\customers.csv'
with ( firstrow = 2,
fieldterminator = ',',
rowterminator = '\n');


create table stores (store_id INT primary key,  store_name VARCHAR(100),  phone VARCHAR(50),  email VARCHAR(50),  street VARCHAR(50), city VARCHAR(50),  state VARCHAR(50),  zip_code varchar(10));

BULK INSERT  stores 
from 'C:\Users\Lenovo\Desktop\Project\stores.csv'
with ( firstrow = 2,
fieldterminator = ',',
rowterminator = '\n');


create table staffs ( staff_id int primary key,  first_name VARCHAR(50),   last_name VARCHAR(50),  email VARCHAR(50),  phone VARCHAR(50),  active int, store_id int foreign key references stores(store_id) ,   manager_id int null foreign key references staffs (staff_id));


BULK INSERT  staffs
from 'C:\Users\Lenovo\Desktop\Project\staffs.csv'
with ( firstrow = 2,
fieldterminator = ',',
rowterminator = '\n',
keepnulls);

create table orders (order_id int primary key,   customer_id int foreign key references customers(customer_id),  order_status int,  order_date date,  required_date date,   shipped_date date	null,  store_id int foreign key references stores(store_id),  staff_id int foreign key references staffs(staff_id)); 

BULK INSERT  orders
from 'C:\Users\Lenovo\Desktop\Project\orders.csv'
with ( firstrow = 2,
fieldterminator = ',',
rowterminator = '\n',
keepnulls);

create table brands (brand_id int primary key, brand_name VARCHAR(50));

BULK INSERT  brands
from 'C:\Users\Lenovo\Desktop\Project\brands.csv'
with ( firstrow = 2,
fieldterminator = ',',
rowterminator = '\n');

create table categories (category_id int primary key,  category_name VARCHAR(100));

BULK INSERT  categories 
from 'C:\Users\Lenovo\Desktop\Project\categories.csv'
with ( firstrow = 2,
fieldterminator = ',',
rowterminator = '\n');

create table products (product_id int primary key,   product_name VARCHAR(225),  brand_id int foreign key references brands (brand_id),   category_id int,  model_year int,  list_price decimal(10,2),
foreign key (category_id) references categories(category_id));

BULK INSERT  products 
from 'C:\Users\Lenovo\Desktop\Project\products.csv'
with ( firstrow = 2,
fieldterminator = ',',
rowterminator = '\n');

create table stocks (store_id int  foreign key references stores (store_id), product_id int foreign key references products (product_id),   quantity int, primary key (store_id, product_id));

BULK INSERT  stocks
from 'C:\Users\Lenovo\Desktop\Project\stocks.csv'
with ( firstrow = 2,
fieldterminator = ',',
rowterminator = '\n');
--A composite key is a primary key made up of two or more columns.
create table order_items (order_id int foreign key references orders(order_id),  item_id int,  product_id int foreign key references products (product_id),  quantity int,   list_price decimal(10,2),  discount decimal(10,2),  primary key (order_id, item_id));

BULK INSERT  order_items 
from 'C:\Users\Lenovo\Desktop\Project\order_items.csv'
with ( firstrow = 2,
fieldterminator = ',',
rowterminator = '\n');

create table customer_orders (OrderID int foreign key references orders(order_id) ,	CustomerID int foreign key references customers(customer_id),	Product varchar(50),	Quantity decimal(10,2),	Price decimal(10,2)
)

bulk insert customer_orders 
from 'C:\Users\Lenovo\Desktop\Project\customer_orders.csv'
with (
		Firstrow =  2,
		rowterminator = '\n',
		fieldterminator = ','
);


