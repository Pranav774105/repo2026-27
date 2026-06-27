create database MySQL_Tasks;

use MySQL_Tasks;

show tables;


#1. Total Sales
SELECT SUM(TotalAmount) AS TotalSales
FROM Orders;

#2. Top 5 Highest Orders
SELECT *
FROM Orders
ORDER BY TotalAmount DESC
LIMIT 5;

#3. Orders Per City
SELECT City, COUNT(*) AS TotalOrders
FROM Orders
GROUP BY City;

#4. Category-wise Revenue
SELECT Category,
       SUM(TotalAmount) AS Revenue
FROM Orders
GROUP BY Category;

#5. Average Order Value
SELECT AVG(TotalAmount) AS AverageOrderValue
FROM Orders;

#6. Delivered Orders
SELECT *
FROM Orders
WHERE OrderStatus = 'Delivered';

#7. Orders Above Average Sales
SELECT *
FROM Orders
WHERE TotalAmount >
(
    SELECT AVG(TotalAmount)
    FROM Orders
);

#8. Most Popular Payment Mode
SELECT PaymentMode,
       COUNT(*) AS UsageCount
FROM Orders
GROUP BY PaymentMode
ORDER BY UsageCount DESC
LIMIT 1;

#9. Monthly Revenue
SELECT MONTH(OrderDate) AS MonthNo,
       SUM(TotalAmount) AS Revenue
FROM Orders
GROUP BY MONTH(OrderDate)
ORDER BY MonthNo;

#10. Top Spending Customers
SELECT CustomerName,
       SUM(TotalAmount) AS TotalSpent
FROM Orders
GROUP BY CustomerName
ORDER BY TotalSpent DESC
LIMIT 10;

#11. Customer Order Count
SELECT CustomerName,
       COUNT(*) AS OrderCount
FROM Orders
GROUP BY CustomerName
ORDER BY OrderCount DESC;

#12. Highest Revenue City
SELECT City,
       SUM(TotalAmount) AS Revenue
FROM Orders
GROUP BY City
ORDER BY Revenue DESC
LIMIT 1;

#13. Category with Maximum Orders
SELECT Category,
       COUNT(*) AS TotalOrders
FROM Orders
GROUP BY Category
ORDER BY TotalOrders DESC
LIMIT 1;

#14. Revenue Contribution %
SELECT Category,
       ROUND(
           SUM(TotalAmount) * 100 /
           (SELECT SUM(TotalAmount) FROM Orders),
           2
       ) AS RevenuePercentage
FROM Orders
GROUP BY Category;

#15. Customers with More Than 5 Orders
SELECT CustomerName,
       COUNT(*) AS OrderCount
FROM Orders
GROUP BY CustomerName
HAVING COUNT(*) > 5;

#16. Second Highest Order Amount
SELECT MAX(TotalAmount) AS SecondHighestAmount
FROM Orders
WHERE TotalAmount <
(
    SELECT MAX(TotalAmount)
    FROM Orders
);

#17. Running Total Sales
SELECT OrderDate,
       TotalAmount,
       SUM(TotalAmount)
       OVER(ORDER BY OrderDate)
       AS RunningTotal
FROM Orders;

#18. Rank Customers by Spending
SELECT CustomerName,
       SUM(TotalAmount) AS TotalSpent,
       RANK() OVER(
           ORDER BY SUM(TotalAmount) DESC
       ) AS CustomerRank
FROM Orders
GROUP BY CustomerName;

#19. Latest Order of Each Customer
SELECT *
FROM Orders o
WHERE OrderDate =
(
    SELECT MAX(OrderDate)
    FROM Orders
    WHERE CustomerName = o.CustomerName
);

#20. City-wise Top Customer
WITH CustomerSales AS
(
    SELECT City,
           CustomerName,
           SUM(TotalAmount) AS TotalSpent,
           RANK() OVER(
               PARTITION BY City
               ORDER BY SUM(TotalAmount) DESC
           ) AS rnk
    FROM Orders
    GROUP BY City, CustomerName
)
SELECT *
FROM CustomerSales
WHERE rnk = 1;

#Advanced Interview Questions
#21. Customers Who Never Cancelled
SELECT DISTINCT CustomerName
FROM Orders
WHERE CustomerName NOT IN
(
    SELECT CustomerName
    FROM Orders
    WHERE OrderStatus = 'Cancelled'
);

#22. Month-over-Month Sales Growth
WITH MonthlySales AS
(
    SELECT MONTH(OrderDate) AS MonthNo,
           SUM(TotalAmount) AS Revenue
    FROM Orders
    GROUP BY MONTH(OrderDate)
)
SELECT MonthNo,
       Revenue,
       LAG(Revenue) OVER(ORDER BY MonthNo) AS PreviousMonth,
       Revenue -
       LAG(Revenue) OVER(ORDER BY MonthNo) AS Growth
FROM MonthlySales;

#23. Category with Highest Average Order Value
SELECT Category,
       AVG(TotalAmount) AS AvgOrderValue
FROM Orders
GROUP BY Category
ORDER BY AvgOrderValue DESC
LIMIT 1;

#24. Customers Spending Above City Average
WITH CustomerSales AS
(
    SELECT City,
           CustomerName,
           SUM(TotalAmount) AS TotalSpent
    FROM Orders
    GROUP BY City, CustomerName
)
SELECT *
FROM CustomerSales cs
WHERE TotalSpent >
(
    SELECT AVG(TotalSpent)
    FROM CustomerSales
    WHERE City = cs.City
);

#25. Top 3 Customers in Each City
WITH CustomerSales AS
(
    SELECT City,
           CustomerName,
           SUM(TotalAmount) AS TotalSpent,
           DENSE_RANK() OVER
           (
               PARTITION BY City
               ORDER BY SUM(TotalAmount) DESC
           ) AS Ranking
    FROM Orders
    GROUP BY City, CustomerName
)
SELECT *
FROM CustomerSales
WHERE Ranking <= 3;