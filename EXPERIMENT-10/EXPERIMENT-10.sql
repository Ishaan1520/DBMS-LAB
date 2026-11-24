-- ============================================================
-- DBMS EXPERIMENT - 10
-- Sales Database: Query Optimization and Performance Analysis
-- Database: MySQL 8.0+
-- ============================================================

-- 1. CREATE SALES TABLE

DROP TABLE IF EXISTS Sales;

CREATE TABLE Sales (
    Sale_ID INT PRIMARY KEY,
    Customer_ID INT,
    Customer_Name VARCHAR(50),
    Product_ID INT,
    Product_Name VARCHAR(50),
    Category VARCHAR(30),
    Quantity INT,
    Price DECIMAL(10,2),
    Total_Amount DECIMAL(12,2),
    Sale_Date DATE,
    City VARCHAR(50),
    Payment_Mode VARCHAR(20)
) ENGINE = InnoDB;


-- ============================================================
-- 2. GENERATE AND INSERT 10,000 RECORDS
-- ============================================================

SET SESSION cte_max_recursion_depth = 10000;

INSERT INTO Sales (
    Sale_ID,
    Customer_ID,
    Customer_Name,
    Product_ID,
    Product_Name,
    Category,
    Quantity,
    Price,
    Total_Amount,
    Sale_Date,
    City,
    Payment_Mode
)
WITH RECURSIVE Numbers AS (
    SELECT 1 AS n

    UNION ALL

    SELECT n + 1
    FROM Numbers
    WHERE n < 10000
)

SELECT
    n,
    100 + (n % 500),
    CONCAT('Customer_', n % 500),
    1000 + (n % 100),
    CONCAT('Product_', n % 100),

    CASE
        WHEN n % 4 = 0 THEN 'Electronics'
        WHEN n % 4 = 1 THEN 'Clothing'
        WHEN n % 4 = 2 THEN 'Furniture'
        ELSE 'Grocery'
    END,

    (n % 10) + 1,
    100 + (n % 900),
    ((n % 10) + 1) * (100 + (n % 900)),

    DATE_ADD('2026-01-01', INTERVAL (n % 365) DAY),

    CASE
        WHEN n % 4 = 0 THEN 'Lucknow'
        WHEN n % 4 = 1 THEN 'Delhi'
        WHEN n % 4 = 2 THEN 'Kanpur'
        ELSE 'Mumbai'
    END,

    CASE
        WHEN n % 3 = 0 THEN 'UPI'
        WHEN n % 3 = 1 THEN 'Cash'
        ELSE 'Card'
    END

FROM Numbers;


-- ============================================================
-- 3. VERIFY TOTAL RECORDS
-- ============================================================

SELECT COUNT(*) AS Total_Records
FROM Sales;

SELECT *
FROM Sales;


-- ============================================================
-- 4. IDENTIFY SLOW QUERIES BEFORE INDEXING
-- ============================================================

-- Query 1: Search by Customer ID

EXPLAIN
SELECT *
FROM Sales
WHERE Customer_ID = 150;

SELECT *
FROM Sales
WHERE Customer_ID = 150;


-- Query 2: Search by Category

EXPLAIN
SELECT *
FROM Sales
WHERE Category = 'Electronics';

SELECT *
FROM Sales
WHERE Category = 'Electronics';


-- Query 3: Search by Sale Date

EXPLAIN
SELECT *
FROM Sales
WHERE Sale_Date BETWEEN '2026-03-01' AND '2026-06-30';

SELECT *
FROM Sales
WHERE Sale_Date BETWEEN '2026-03-01' AND '2026-06-30';


-- Query 4: Group Sales by City

EXPLAIN
SELECT
    City,
    SUM(Total_Amount) AS Total_Sales
FROM Sales
GROUP BY City;

SELECT
    City,
    SUM(Total_Amount) AS Total_Sales
FROM Sales
GROUP BY City;


-- Query 5: Multiple Conditions

EXPLAIN
SELECT *
FROM Sales
WHERE Customer_ID = 150
AND Category = 'Electronics'
AND Sale_Date >= '2026-03-01';

SELECT *
FROM Sales
WHERE Customer_ID = 150
AND Category = 'Electronics'
AND Sale_Date >= '2026-03-01';


-- ============================================================
-- 5. CREATE INDEXES FOR QUERY OPTIMIZATION
-- ============================================================

CREATE INDEX idx_customer
ON Sales(Customer_ID);

CREATE INDEX idx_category
ON Sales(Category);

CREATE INDEX idx_sale_date
ON Sales(Sale_Date);

CREATE INDEX idx_city
ON Sales(City);


-- Composite Index

CREATE INDEX idx_customer_category_date
ON Sales(Customer_ID, Category, Sale_Date);


-- ============================================================
-- 6. ANALYZE QUERY EXECUTION AFTER INDEXING
-- ============================================================

-- Query 1: Customer ID

EXPLAIN
SELECT *
FROM Sales
WHERE Customer_ID = 150;


-- Query 2: Category

EXPLAIN
SELECT *
FROM Sales
WHERE Category = 'Electronics';


-- Query 3: Sale Date

EXPLAIN
SELECT *
FROM Sales
WHERE Sale_Date BETWEEN '2026-03-01' AND '2026-06-30';


-- Query 4: Group by City

EXPLAIN
SELECT
    City,
    SUM(Total_Amount) AS Total_Sales
FROM Sales
GROUP BY City;


-- Query 5: Multiple Conditions

EXPLAIN
SELECT *
FROM Sales
WHERE Customer_ID = 150
AND Category = 'Electronics'
AND Sale_Date >= '2026-03-01';


-- ============================================================
-- 7. QUERY REWRITING AND OPTIMIZATION
-- ============================================================

-- Optimized Query 1:
-- Retrieve only required columns instead of SELECT *

SELECT
    Sale_ID,
    Customer_ID,
    Total_Amount
FROM Sales
WHERE Customer_ID = 150;


-- Optimized Query 2:
-- Calculate category-wise sales

SELECT
    Category,
    SUM(Total_Amount) AS Category_Sales
FROM Sales
GROUP BY Category;


-- Optimized Query 3:
-- Use a date range with explicit boundaries

SELECT
    Sale_ID,
    Product_Name,
    Total_Amount
FROM Sales
WHERE Sale_Date >= '2026-03-01'
AND Sale_Date < '2026-07-01';


-- Optimized Query 4:
-- Retrieve Top 10 highest-value sales

SELECT
    Sale_ID,
    Customer_Name,
    Total_Amount
FROM Sales
ORDER BY Total_Amount DESC
LIMIT 10;


-- Optimized Query 5:
-- Calculate total revenue

SELECT
    SUM(Total_Amount) AS Total_Revenue
FROM Sales;


-- ============================================================
-- 8. DISPLAY INDEX INFORMATION
-- ============================================================

SHOW INDEX FROM Sales;


-- ============================================================
-- 9. UPDATE TABLE STATISTICS
-- ============================================================

ANALYZE TABLE Sales;


-- ============================================================
-- END OF EXPERIMENT 10
-- ============================================================
