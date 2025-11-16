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
