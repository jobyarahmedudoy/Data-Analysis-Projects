# Maven Analytics Data Drill-Turning Bullish

```sql
CREATE VIEW SPY_MA AS
WITH MA AS (
SELECT DATE,[CLOSE],
AVG([CLOSE]) OVER (ORDER BY DATE ROWS BETWEEN 49 PRECEDING AND CURRENT ROW) AS MA50,
AVG([CLOSE])  OVER (ORDER BY DATE ROWS BETWEEN 199 PRECEDING AND CURRENT ROW) AS MA200
FROM SPY_CLOSE_PRICE_5Y)
SELECT DATE,[CLOSE],MA50,MA200,
CASE
WHEN MA50 IS NULL OR MA200 IS NULL THEN 0
WHEN MA50>MA200 AND LAG(MA50) OVER (ORDER BY DATE) <= LAG(MA200) OVER (ORDER BY DATE) THEN 1
ELSE 0
END AS GOLDEN_CROSS
FROM MA;
```

-- Output --  
<img width="545" height="401" alt="Output full data" src="https://github.com/user-attachments/assets/314f26a1-e125-4380-89b2-6dba5093395a" />



```sql
SELECT TOP 1 DATE, [CLOSE]
FROM SPY_MA
WHERE GOLDEN_CROSS = 1
ORDER BY DATE DESC;
```
-- Output --  

<img width="220" height="70" alt="Final Output" src="https://github.com/user-attachments/assets/f1c28576-b52a-4d0b-97c2-c107674e116f" />


-- Excel Output--

<img width="1335" height="633" alt="Capture (3)" src="https://github.com/user-attachments/assets/03fd8e25-006a-4072-83cb-efea3d39f6eb" />


