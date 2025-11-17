# Northwind Traders Sales Analytics using Advanced SQL
This project focuses on analyzing the Northwind Traders business database using SQL to uncover insights about sales performance, customer behavior, employee productivity, product trends, and supplier contributions.
By applying SQL queries on the Northwind dataset, the project reveals meaningful business patterns, relationships, and trends across key operational areas.

The Northwind Traders database includes multiple interconnected tables representing a complete retail business model. Key tables used in this analysis include:

- `Orders`: – Contains order-level details such as order ID, order date, customer, and employee.
- `Order Details`: – Line-item information for each order, including product, quantity, and unit price.
- `Customers`: – Customer information such as company name, location, and contact details.
- `Products`: – Product catalog containing names, categories, suppliers, and pricing.
- `Categories`: – Product categories (e.g., Beverages, Condiments, Seafood).
- `Suppliers`: – Information about companies supplying products.
- `Employees`: – Employees responsible for handling orders.
- `Shippers`: – Shipping companies used to transport orders.
- `Region, Territories, EmployeeTerritories` – Geographic and mapping data for regional sales analysis.

## SQL Queries and Outputs

Here are the SQL queries along with their outputs:


1.**List each category and the total sales amount generated from that category.**

```sql 
select a.CategoryName,round(sum(c.UnitPrice*c.Quantity),2) as total_sales_amount
 from northwind.Categories a 
 JOIN northwind.Products b on a.CategoryID=b.CategoryID
 JOIN northwind.`Order Details` c on b.ProductID=c.ProductID
 group by a.CategoryName
 ORDER BY Total_Sales_Amount DESC;
```
-- Output --

<img width="244" height="192" alt="Capture" src="https://github.com/user-attachments/assets/e830e4e0-8064-48d2-a194-a78f1a23cda4" />



2.**Find the top 5 products based on total quantity sold.**

```sql
select b.ProductName,sum(a.quantity) as total_quantity from northwind.`Order Details`a
join northwind.Products b
on a.ProductID=b.ProductID
group by b.ProductName
order by total_quantity desc
limit 5;
```
-- Output --

<img width="258" height="133" alt="Capture" src="https://github.com/user-attachments/assets/4ad89459-c090-4fbf-a695-86f7708ec0ab" />


3.**Show the total number of orders handled by each employee.**

```sql
select b.EmployeeID,concat(b.FirstName,' ',b.LastName) as full_name,
count(distinct a.orderid) as total_orders from northwind.Orders a
join northwind.Employees b
on a.EmployeeID=b.EmployeeID
group by b.EmployeeID,b.FirstName,b.LastName
order by total_orders desc;
```
-- Output --

<img width="312" height="212" alt="Capture" src="https://github.com/user-attachments/assets/1e5bd093-e73a-4a3a-a1e8-328cdcd72e68" />

4.**List customers and their total number of orders.**

```sql
select a.CompanyName,count(distinct b.OrderID) as total_orders from northwind.Customers a
left join northwind.Orders b
on a.CustomerID=b.CustomerID
group by a.CompanyName
order by total_orders desc;
```
-- Output --

<img width="282" height="267" alt="Capture" src="https://github.com/user-attachments/assets/a04f1444-e120-4012-aaf3-86a1db64c5f5" />


5.**Find the average order value per customer.**

```sql
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
```
-- Output --

<img width="313" height="269" alt="Capture" src="https://github.com/user-attachments/assets/cd96a0cc-4bc7-4f1b-a55f-9a430bf277b6" />


6.**Display all orders along with customer name, employee name, and shipper company.**

```sql
select a.OrderID,b.CompanyName as Customer,
concat(c.FirstName,' ',c.LastName) as Employee,
d.CompanyName as Shippers
 from northwind.Orders a
join northwind.Customers b on a.CustomerID=b.CustomerID
join northwind.Employees c on a.EmployeeID=c.EmployeeID
join northwind.Shippers d on a.ShipVia=d.ShipperID
order by a.OrderID;
```
-- Output --

<img width="466" height="266" alt="Capture" src="https://github.com/user-attachments/assets/ed51f8a3-37fd-4b8e-88f5-53b09f10ec7d" />


7.**Find all products whose price is above the average product price.**

```sql
select ProductName,UnitPrice from northwind.Products
where UnitPrice > (select avg(UnitPrice) from northwind.Products)
order by UnitPrice desc;
```
-- Output --

<img width="236" height="228" alt="Capture" src="https://github.com/user-attachments/assets/f080813b-8539-4073-8272-b1ef25629588" />


8.**List customers who have placed more than 10 orders.**

```sql
select a.CompanyName as Customers,count(b.OrderID) as total_Orders from northwind.Customers a
join northwind.Orders b on a.CustomerID=b.CustomerID
group by a.CompanyName 
having count(b.OrderID) > 10
order by total_Orders desc;
```
-- Output --

<img width="283" height="267" alt="Capture" src="https://github.com/user-attachments/assets/e409dd5a-f39f-4f92-a2e8-a4f7ffda7776" />


9.**Show the top 3 customers by total revenue .**

```sql
select a.CompanyName as Customers,sum(c.UnitPrice*c.Quantity) as Revenue from northwind.Customers a
join northwind.Orders b on a.CustomerID=b.CustomerID
join northwind.`Order Details` c on b.OrderID=c.OrderID
group by a.CompanyName 
order by Revenue desc
limit 3;
```
-- Output --

<img width="237" height="88" alt="Capture" src="https://github.com/user-attachments/assets/353002c6-8f34-4b0b-94b5-ca28f9883aec" />


10.**Find employees whose total sales are higher than the company average.**

```sql
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
```
-- Output --

<img width="330" height="111" alt="image" src="https://github.com/user-attachments/assets/b0ab1738-7af6-43cf-a9a0-034e9cff17b4" />


11.**For each category, find the product with the highest unit price.**

```sql
SELECT b.CategoryID,b.CategoryName,a.ProductName,a.UnitPrice FROM northwind.Products a
join northwind.Categories b 
on a.CategoryID=b.CategoryID
where a.UnitPrice = (select max(UnitPrice) 
from Products where CategoryID=a.CategoryID);
```
-- Output --

<img width="441" height="190" alt="Capture" src="https://github.com/user-attachments/assets/db5144c5-2e77-4346-bb8e-f3d8c9b0ef0b" />


12.**List suppliers who provide more than 3 different products.**

```sql
SELECT b.SupplierID,b.CompanyName as Suppliers,count(a.ProductID) as Order_Count FROM northwind.Products a
join northwind.Suppliers b on a.SupplierID=b.SupplierID
group by b.SupplierID,b.CompanyName
having count(a.ProductID) >3
order by Order_Count desc;
```
-- Output --

<img width="398" height="110" alt="Capture" src="https://github.com/user-attachments/assets/4ecf930d-f3bf-4e2d-95fa-fcad5b5f711c" />


13.**Using a CTE, calculate the monthly sales total and display it in ascending order by month.**

```sql 
With MonthlySales as
(select date_format(a.Orderdate,'%b') as Month,sum(b.Quantity*b.UnitPrice) as total_sales from northwind.Orders a
join northwind.`Order Details` b on a.OrderID=b.OrderID
group by date_format(a.Orderdate,'%b'),month(a.Orderdate))
select * from MonthlySales
ORDER BY MONTH(STR_TO_DATE(Month, '%b'));
```
-- Output --

<img width="158" height="271" alt="Capture" src="https://github.com/user-attachments/assets/9fabcf94-f7d1-4ea9-9a58-dccb8ce5b80a" />


14.**Create a CTE to find the top 3 employees by monthly sales using RANK().**

```sql
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
```
-- Output --

<img width="449" height="272" alt="Capture" src="https://github.com/user-attachments/assets/7a9841b8-b495-4c1b-b0fd-2bfa616c2ce9" />


15.**Use LAG() to show each customer’s previous order value and the difference compared to the current order.**

```sql
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
```
-- Output --

<img width="861" height="267" alt="Capture" src="https://github.com/user-attachments/assets/78d8034d-ac45-4bab-b52e-0fe46c1b4806" />


16.**Use LEAD() to show next month’s total sales for each month, and calculate sales growth.**

```sql
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
```
-- Output --

<img width="385" height="266" alt="Capture" src="https://github.com/user-attachments/assets/b704571e-f9ac-4055-9df7-9024de315489" />


17.**Create a rolling 3-month average of total sales using a window function.**

```sql
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
```
-- Output --

<img width="284" height="264" alt="Capture" src="https://github.com/user-attachments/assets/738d8460-c46a-42de-acda-2dc583964ec3" />


18.**For each product category, use LAG() to find the month-over-month sales growth.**

```sql
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
```
-- Output --

<img width="535" height="276" alt="Capture" src="https://github.com/user-attachments/assets/eadf30ea-5638-4179-bb76-03805ce6e0ba" />


19.**Build a query to calculate each customer’s lifetime value (CLV): total revenue, average order value, and number of orders.**

```sql
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
```
-- Output --

<img width="603" height="267" alt="Capture" src="https://github.com/user-attachments/assets/04f55950-dd3c-4b14-a597-77708836bdf7" />


20.**Find the best-performing supplier based on total revenue from their products.**

```sql
select b.SupplierID,b.CompanyName as Supplier,
sum(c.Quantity*c.UnitPrice) as TotalRevenue from northwind.Products a
join northwind.Suppliers b on a.SupplierID=b.SupplierID
join northwind.`Order Details` c on a.ProductID=c.ProductID
group by b.SupplierID,b.CompanyName
order by TotalRevenue desc
limit 1;
```
-- Output --

<img width="357" height="52" alt="Capture" src="https://github.com/user-attachments/assets/5b958edc-c42c-46ad-b17f-2d83e7e88041" />


21.**For each region, identify the top-selling category by total sales amount.**

```sql
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
```
-- Output --

<img width="506" height="110" alt="Capture" src="https://github.com/user-attachments/assets/e1b01d5a-0e20-4b58-a349-4f42c1a23319" />


22.**Show each employee’s month-over-month sales trend and percentage growth using LAG().**

```sql
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
```
-- Output --

<img width="471" height="279" alt="Capture" src="https://github.com/user-attachments/assets/f6aad59f-a31a-4907-9515-980c7532b672" />


23.**Calculate the year-over-year total sales growth for the company.**

```sql
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
```
-- Output --

<img width="478" height="89" alt="Capture" src="https://github.com/user-attachments/assets/a791ad84-9d39-4ffe-ae4c-81cddedb8d8a" />


24.**Identify dormant customers who haven’t ordered in the last 6 months.**

```sql
SELECT 
c.CustomerID,c.CompanyName AS Customer,
MAX(o.OrderDate) AS LastOrderDate
FROM northwind.Customers c
LEFT JOIN northwind.Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.CompanyName
HAVING LastOrderDate IS NULL
OR LastOrderDate < NOW() - INTERVAL 6 MONTH
ORDER BY LastOrderDate;
```
-- Output --

<img width="474" height="272" alt="Capture" src="https://github.com/user-attachments/assets/53f75b1a-7113-4018-a28e-bea7abc4485d" />


25.**Find the first and most recent order date for every customer using window functions.**

```sql
SELECT DISTINCT
    CustomerID,
    MIN(OrderDate) OVER (PARTITION BY CustomerID) AS FirstOrderDate,
    MAX(OrderDate) OVER (PARTITION BY CustomerID) AS MostRecentOrderDate
FROM northwind.Orders
ORDER BY CustomerID;
```
-- Output --

<img width="399" height="264" alt="Capture" src="https://github.com/user-attachments/assets/7012e901-4c75-4051-b7b9-967b7f495e09" />


**Customer Value Analysis Using RFM**

```sql
WITH CustomerRFM AS (
    SELECT 
        c.CustomerID,
        c.CompanyName AS Customer,
        
        DATEDIFF(
            (SELECT MAX(OrderDate) FROM northwind.Orders),
            MAX(o.OrderDate)
        ) AS Recency,
        COUNT(DISTINCT o.OrderID) AS Frequency,
        SUM(od.Quantity * od.UnitPrice) AS Monetary
    FROM northwind.Customers c
    JOIN northwind.Orders o ON c.CustomerID = o.CustomerID
    JOIN northwind.`Order Details` od ON o.OrderID = od.OrderID
    GROUP BY c.CustomerID, c.CompanyName
),
Scores AS (
    SELECT *,
        NTILE(5) OVER (ORDER BY Recency DESC) AS R_Score,
        NTILE(5) OVER (ORDER BY Frequency ASC) AS F_Score,
        NTILE(5) OVER (ORDER BY Monetary ASC) AS M_Score
    FROM CustomerRFM
)
SELECT *,
       CONCAT(R_Score, F_Score, M_Score) AS RFM_Score,
       CASE 
            WHEN R_Score >= 4 AND F_Score >= 4 AND M_Score >= 4 THEN 'High-Value (Champions)'
            WHEN R_Score >= 3 AND F_Score >= 3 AND M_Score >= 3 THEN 'Loyal Customers'
            WHEN R_Score <= 2 AND F_Score >= 4 AND M_Score >= 4 THEN 'Potential Loyalist'
            WHEN R_Score >= 4 AND F_Score <= 2 THEN 'New Customers'
            WHEN R_Score <= 2 AND F_Score <= 2 THEN 'At Risk / Lost'
            ELSE 'Others'
       END AS Segment
FROM Scores
ORDER BY Segment, Monetary DESC;
```
-- Output --

<img width="930" height="269" alt="Capture" src="https://github.com/user-attachments/assets/3b6e157c-0ff7-4b90-8356-839cd018ad3a" />


