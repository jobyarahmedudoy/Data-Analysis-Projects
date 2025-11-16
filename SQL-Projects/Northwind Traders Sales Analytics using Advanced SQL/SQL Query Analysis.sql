/*List each category and the total sales amount generated from that category.*/

select a.CategoryName,round(sum(c.UnitPrice*c.Quantity),2) as total_sales_amount
 from northwind.Categories a 
 JOIN northwind.Products b on a.CategoryID=b.CategoryID
 JOIN northwind.`Order Details` c on b.ProductID=c.ProductID
 group by a.CategoryName
 ORDER BY Total_Sales_Amount DESC;

/*Find the top 5 products based on total quantity sold.*/

select b.ProductName,sum(a.quantity) as total_quantity from northwind.`Order Details`a
join northwind.Products b
on a.ProductID=b.ProductID
group by b.ProductName
order by total_quantity desc
limit 5;

/*Show the total number of orders handled by each employee.*/

select b.EmployeeID,concat(b.FirstName,' ',b.LastName) as full_name,
count(distinct a.orderid) as total_orders from northwind.Orders a
join northwind.Employees b
on a.EmployeeID=b.EmployeeID
group by b.EmployeeID,b.FirstName,b.LastName
order by total_orders desc;

/* List customers and their total number of orders.*/

select a.CompanyName,count(distinct b.OrderID) as total_orders from northwind.Customers a
left join northwind.Orders b
on a.CustomerID=b.CustomerID
group by a.CompanyName
order by total_orders desc;

/*Find the average order value per customer.*/

select c.companyname,
round(avg(total_order),2) as Avg_Order_Value from 
(select b.CustomerID,b.Orderid,
SUM(a.UnitPrice*a.Quantity) as total_order 
from northwind.`Order Details` a
join northwind.Orders b on a.Orderid=b.Orderid
group by b.CustomerID,b.Orderid) as order_summary
join Customers c on order_summary.CustomerID=c.CustomerID
group by c.Companyname
order by Avg_Order_Value desc;

/*Display all orders along with customer name, employee name, and shipper company.*/

select a.OrderID,b.CompanyName as Customer,
concat(c.FirstName,' ',c.LastName) as Employee,
d.CompanyName as Shippers
 from northwind.Orders a
join northwind.Customers b on a.CustomerID=b.CustomerID
join northwind.Employees c on a.EmployeeID=c.EmployeeID
join northwind.Shippers d on a.ShipVia=d.ShipperID
order by a.OrderID;

/*Find all products whose price is above the average product price.*/

select ProductName,UnitPrice from northwind.Products
where UnitPrice > (select avg(UnitPrice) from northwind.Products)
order by UnitPrice desc;

/*List customers who have placed more than 10 orders.*/

select a.CompanyName as Customers,count(b.OrderID) as total_Orders from northwind.Customers a
join northwind.Orders b on a.CustomerID=b.CustomerID
group by a.CompanyName 
having count(b.OrderID) > 10
order by total_Orders desc;

/*Show the top 3 customers by total revenue*/

select a.CompanyName as Customers,sum(c.UnitPrice*c.Quantity) as Revenue from northwind.Customers a
join northwind.Orders b on a.CustomerID=b.CustomerID
join northwind.`Order Details` c on b.OrderID=c.OrderID
group by a.CompanyName 
order by Revenue desc
limit 3;

/*Find employees whose total sales are higher than the company average.*/

select a.EmployeeID,concat(a.FirstName,' ',a.LastName) as Employees,
sum(c.UnitPrice*c.Quantity) as total_sales from northwind.Employees a
join northwind.Orders b on a.EmployeeID=b.EmployeeID
join northwind.`Order Details` c on b.OrderID=c.OrderID
group by a.EmployeeID,a.FirstName,a.LastName
having sum(c.UnitPrice*c.Quantity) > (select avg (employee_total) from
(select a.EmployeeID,
sum(c.UnitPrice*c.Quantity) as employee_total from northwind.Employees a
join northwind.Orders b on a.EmployeeID=b.EmployeeID
join northwind.`Order Details` c on b.OrderID=c.OrderID
group by a.EmployeeID ) as avg_sales)
order by a.EmployeeID,total_sales desc;

/*For each category, find the product with the highest unit price.*/

SELECT b.CategoryID,b.CategoryName,a.ProductName,a.UnitPrice FROM northwind.Products a
join northwind.Categories b 
on a.CategoryID=b.CategoryID
where a.UnitPrice = (select max(UnitPrice) 
from Products where CategoryID=a.CategoryID);

/*List suppliers who provide more than 3 different products.*/

SELECT b.SupplierID,b.CompanyName as Suppliers,count(a.ProductID) as Order_Count FROM northwind.Products a
join northwind.Suppliers b on a.SupplierID=b.SupplierID
group by b.SupplierID,b.CompanyName
having count(a.ProductID) >3
order by Order_Count desc;

/*Using a CTE, calculate the monthly sales total and display it in ascending order by month.*/

With MonthlySales as
(select date_format(a.Orderdate,'%b') as Month,sum(b.Quantity*b.UnitPrice) as total_sales from northwind.Orders a
join northwind.`Order Details` b on a.OrderID=b.OrderID
group by date_format(a.Orderdate,'%b'),month(a.Orderdate))
select * from MonthlySales
ORDER BY MONTH(STR_TO_DATE(Month, '%b'));

/*Create a CTE to find the top 3 employees by monthly sales using RANK().*/

with MonthlySales as
(select c.EmployeeID,concat(c.FirstName,' ',c.LastName) as Employee,
date_format(a.OrderDate,'%b') as MonthName,sum(b.Quantity*b.UnitPrice) as TotalSales
from northwind.Orders a
join northwind.`Order Details` b on a.OrderID=b.OrderID
join northwind.Employees c on a.EmployeeID=c.EmployeeID
group by c.EmployeeID,date_format(a.OrderDate,'%b'))
select * from 
(select *,RANK() OVER (PARTITION BY MonthName order by TotalSales desc) as Rank
from MonthlySales) ranked
where Rank<=3
order by str_to_date(MonthName,'%b');

/*Use LAG() to show each customer’s previous order value and the difference compared to the current order.*/

with CustomerOrders as
(SELECT a.CustomerID,a.CompanyName as Customer,b.OrderID,b.OrderDate,
sum(c.Quantity*c.UnitPrice) as OrderValue FROM northwind.Customers a
join northwind.Orders b on a.CustomerID=b.CustomerID
join northwind.`Order Details` c on b.OrderID=c.OrderID
group by a.CustomerID,a.CompanyName,b.OrderID,b.OrderDate)
select *,
LAG(OrderValue) OVER (partition by CustomerID order by OrderDate) as PrevOrderValue,
(OrderValue-LAG(OrderValue) OVER (partition by CustomerID order by OrderDate)) as ChangeInValue
from CustomerOrders;

/*Use LEAD() to show next month’s total sales for each month, and calculate sales growth.*/

with MonthlySales as
(select date_format(a.OrderDate,'%b') as Month,
sum(b.Quantity*b.UnitPrice) as TotalSales 
from northwind.Orders a
join northwind.`Order Details`b on a.OrderID=b.OrderID
group by date_format(a.OrderDate,'%b'))
select *,
LEAD(TotalSales) OVER (order by Month(str_to_date(Month,'%b'))) AS NextMonthSales,
CONCAT(ROUND((LEAD(TotalSales) OVER (order by Month(str_to_date(Month,'%b')))-TotalSales)/TotalSales *100,2),'%') as GrowthPercent
from MonthlySales;

/*Create a rolling 3-month average of total sales using a window function.*/

with MonthlySales as
(select date_format(a.OrderDate,'%b') as Month,
sum(b.Quantity*b.UnitPrice) as TotalSales 
from northwind.Orders a
join northwind.`Order Details`b on a.OrderID=b.OrderID
group by date_format(a.OrderDate,'%b'))
select Month,TotalSales,
ROUND(AVG(TotalSales) OVER (order by MONTH(str_to_date(Month,'%b')) 
rows between 2 preceding and current row),2) as Rolling3MonthAvg
FROM MonthlySales;

/*For each product category, use LAG() to find the month-over-month sales growth.*/

with MonthlySalesCategoryWise as
(SELECT a.CategoryID,a.CategoryName,
date_format(d.OrderDate,'%b') as Month,
sum(c.Quantity*c.UnitPrice) as CurrentTotalSales FROM northwind.Categories a
join northwind.Products b on a.CategoryID=b.CategoryID
join northwind.`Order Details` c on b.ProductID=c.ProductID
join northwind.Orders d on c.OrderID=d.OrderID
group by a.CategoryID,a.CategoryName,date_format(d.OrderDate,'%b'))
select CategoryName,Month,CurrentTotalSales,
LAG(CurrentTotalSales) OVER (partition by CategoryName order by MONTH(str_to_date(Month,'%b'))) as PrevMonthSales,
CONCAT(ROUND((CurrentTotalSales - LAG(CurrentTotalSales) OVER (partition by CategoryName order by MONTH(str_to_date(Month,'%b'))))
/
LAG(CurrentTotalSales) OVER (partition by CategoryName order by MONTH(str_to_date(Month,'%b'))) * 100,2),'%')
as MoM_SalesGrowth
from MonthlySalesCategoryWise
order by CategoryName,str_to_date(Month,'%b');

/*Build a query to calculate each customer’s lifetime value (CLV): total revenue, average order value, and number of orders.*/

WITH OrderTotals AS (
SELECT b.CustomerID,SUM(c.Quantity * c.UnitPrice) AS OrderTotal
FROM northwind.Orders b
JOIN northwind.`Order Details` c ON b.OrderID = c.OrderID
GROUP BY b.CustomerID, b.OrderID),
CustomerStats AS (
SELECT a.CustomerID,a.CompanyName AS Customer,
SUM(o.OrderTotal) AS TotalRevenue,
ROUND(AVG(o.OrderTotal), 2) AS AvgOrderValue,
COUNT(*) AS NumOfOrders
FROM northwind.Customers a
JOIN OrderTotals o 
ON a.CustomerID = o.CustomerID
GROUP BY a.CustomerID, a.CompanyName)
SELECT * FROM CustomerStats
ORDER BY TotalRevenue DESC;

/*Find the best-performing supplier based on total revenue from their products.*/

select b.SupplierID,b.CompanyName as Supplier,
sum(c.Quantity*c.UnitPrice) as TotalRevenue from northwind.Products a
join northwind.Suppliers b on a.SupplierID=b.SupplierID
join northwind.`Order Details` c on a.ProductID=c.ProductID
group by b.SupplierID,b.CompanyName
order by TotalRevenue desc
limit 1;

/*For each region, identify the top-selling category by total sales amount.*/

With RegionSales as 
(select h.RegionDescription as Region,a.CategoryName as Category,
sum(c.Quantity*c.UnitPrice) as TotalSales
from northwind.Categories a
join northwind.Products b on a.CategoryID=b.CategoryID
join northwind.`Order Details` c on b.ProductID=c.ProductID
join northwind.Orders d on c.OrderID=d.OrderID
join northwind.Employees e on d.EmployeeID=e.EmployeeID
join northwind.EmployeeTerritories f on e.EmployeeID=f.EmployeeID
join northwind.Territories g on f.TerritoryID=g.TerritoryID
join northwind.Region h on g.RegionID=h.RegionID
group by h.RegionDescription,a.CategoryName)
select * from 
(select *,
RANK() over (partition by Region order by TotalSales desc) as Rank
from RegionSales ) as ranked
where Rank=1;

/*Show each employee’s month-over-month sales trend and percentage growth using LAG().*/

With EmployeeGrowth as 
(select concat(c.FirstName,' ',c.LastName) as Employee,
date_format(b.orderdate,'%b') as Month,
sum(a.Quantity*a.UnitPrice) as TotalSales
from northwind.`Order Details` a 
join northwind.Orders b on a.OrderID=b.OrderID
join northwind.Employees c on b.EmployeeID=c.EmployeeID
group by concat(c.FirstName,' ',c.LastName) ,date_format(b.orderdate,'%b'))
select *,
lag(TotalSales) over(partition by Employee order by MONTH(str_to_date(Month,'%b'))) as PrevMonthSales,
CONCAT(ROUND((TotalSales - lag(TotalSales) over(partition by Employee order by MONTH(str_to_date(Month,'%b'))))
/
lag(TotalSales) over(partition by Employee order by MONTH(str_to_date(Month,'%b'))) * 100,2),'%') as Mom_Growth
from EmployeeGrowth
order by Employee,str_to_date(Month,'%b');

/*Calculate the year-over-year total sales growth for the company.*/

With YearlyGrowth as 
(select year(b.orderdate) as Year,
sum(a.Quantity*a.UnitPrice) as TotalSales
from northwind.`Order Details` a 
join northwind.Orders b on a.OrderID=b.OrderID
group by year(b.orderdate)),
GrowthIndicator as 
(select year,TotalSales,
lag(TotalSales) over (order by Year) as PrevYearSales,
ROUND((TotalSales - lag(TotalSales) over (order by Year)) 
/ NULLIF(lag(TotalSales) over (order by Year),0) *100,2) as YoY_Growth
from YearlyGrowth)
select *,
case 
WHEN PrevYearSales IS NULL THEN 'No Previous Data'
WHEN YoY_Growth > 50 THEN 'Excellent Growth'
WHEN YoY_Growth BETWEEN 20 AND 50 THEN 'Good Growth'
WHEN YoY_Growth BETWEEN 0 AND 20 THEN 'Moderate Growth'
WHEN YoY_Growth BETWEEN -20 AND 0 THEN 'Slight Decline'
WHEN YoY_Growth < -20 THEN 'Major Decline'
END AS Growth_Status
from GrowthIndicator;

/*Identify dormant customers who haven’t ordered in the last 6 months.*/

SELECT 
c.CustomerID,c.CompanyName AS Customer,
MAX(o.OrderDate) AS LastOrderDate
FROM northwind.Customers c
LEFT JOIN northwind.Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.CompanyName
HAVING LastOrderDate IS NULL
OR LastOrderDate < NOW() - INTERVAL 6 MONTH
ORDER BY LastOrderDate;

/*Find the first and most recent order date for every customer using window functions.*/

SELECT DISTINCT
    CustomerID,
    MIN(OrderDate) OVER (PARTITION BY CustomerID) AS FirstOrderDate,
    MAX(OrderDate) OVER (PARTITION BY CustomerID) AS MostRecentOrderDate
FROM northwind.Orders
ORDER BY CustomerID;