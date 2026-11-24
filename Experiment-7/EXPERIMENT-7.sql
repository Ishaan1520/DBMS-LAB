-- DBMS Experiment 7
-- Normalization of a denormalized Sales table from UNF to 1NF, 3NF and BCNF
-- Dialect: MySQL 8.0+
--
-- Run this script in a database/schema where you have CREATE, INSERT, DROP,
-- and SELECT privileges. The DROP statements make the script rerunnable.

-- ------------------------------------------------------------
-- 1. Clean up objects from an earlier run (child tables first)
-- ------------------------------------------------------------

DROP TABLE IF EXISTS Sale_Details;
DROP TABLE IF EXISTS Sales;
DROP TABLE IF EXISTS Salesperson;
DROP TABLE IF EXISTS Product;
DROP TABLE IF EXISTS Customer;
DROP TABLE IF EXISTS Sales_1NF;
DROP TABLE IF EXISTS Sales_UNF;

-- ------------------------------------------------------------
-- 2. UNF: original denormalized sales table
-- ------------------------------------------------------------

CREATE TABLE Sales_UNF (
    Sale_ID INT,
    Customer_ID INT,
    Customer_Name VARCHAR(50),
    Customer_City VARCHAR(50),
    Product_ID INT,
    Product_Name VARCHAR(50),
    Quantity INT,
    Salesperson_ID INT,
    Salesperson_Name VARCHAR(50)
);

INSERT INTO Sales_UNF (
    Sale_ID, Customer_ID, Customer_Name, Customer_City,
    Product_ID, Product_Name, Quantity,
    Salesperson_ID, Salesperson_Name
)
VALUES
    (1, 101, 'Rahul Sharma', 'Lucknow', 201, 'Laptop',   2, 301, 'Amit Kumar'),
    (2, 102, 'Priya Singh',  'Kanpur',  202, 'Mouse',    3, 302, 'Neha Gupta'),
    (3, 103, 'Arjun Verma',  'Delhi',   203, 'Keyboard', 1, 303, 'Rohit Singh'),
    (4, 104, 'Sneha Gupta',  'Lucknow', 204, 'Monitor',  2, 301, 'Amit Kumar'),
    (5, 105, 'Vivek Sharma', 'Kanpur',  205, 'Printer',  1, 302, 'Neha Gupta');

-- View the UNF data.
SELECT * FROM Sales_UNF;

-- ------------------------------------------------------------
-- 3. 1NF: atomic values and a composite primary key
-- ------------------------------------------------------------

CREATE TABLE Sales_1NF (
    Sale_ID INT,
    Customer_ID INT,
    Customer_Name VARCHAR(50),
    Customer_City VARCHAR(50),
    Product_ID INT,
    Product_Name VARCHAR(50),
    Quantity INT,
    Salesperson_ID INT,
    Salesperson_Name VARCHAR(50),
    PRIMARY KEY (Sale_ID, Product_ID)
);

INSERT INTO Sales_1NF (
    Sale_ID, Customer_ID, Customer_Name, Customer_City,
    Product_ID, Product_Name, Quantity,
    Salesperson_ID, Salesperson_Name
)
SELECT
    Sale_ID, Customer_ID, Customer_Name, Customer_City,
    Product_ID, Product_Name, Quantity,
    Salesperson_ID, Salesperson_Name
FROM Sales_UNF;

SELECT * FROM Sales_1NF;

-- ------------------------------------------------------------
-- 4. Decomposition into normalized relations (3NF / BCNF)
-- ------------------------------------------------------------

CREATE TABLE Customer (
    Customer_ID INT PRIMARY KEY,
    Customer_Name VARCHAR(50),
    Customer_City VARCHAR(50)
);

CREATE TABLE Product (
    Product_ID INT PRIMARY KEY,
    Product_Name VARCHAR(50)
);

CREATE TABLE Salesperson (
    Salesperson_ID INT PRIMARY KEY,
    Salesperson_Name VARCHAR(50)
);

CREATE TABLE Sales (
    Sale_ID INT PRIMARY KEY,
    Customer_ID INT,
    Salesperson_ID INT,
    CONSTRAINT fk_sales_customer
        FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID),
    CONSTRAINT fk_sales_salesperson
        FOREIGN KEY (Salesperson_ID) REFERENCES Salesperson(Salesperson_ID)
);

CREATE TABLE Sale_Details (
    Sale_ID INT,
    Product_ID INT,
    Quantity INT,
    PRIMARY KEY (Sale_ID, Product_ID),
    CONSTRAINT fk_details_sales
        FOREIGN KEY (Sale_ID) REFERENCES Sales(Sale_ID),
    CONSTRAINT fk_details_product
        FOREIGN KEY (Product_ID) REFERENCES Product(Product_ID)
);

-- Populate each entity relation with distinct records.
INSERT INTO Customer (Customer_ID, Customer_Name, Customer_City)
SELECT DISTINCT Customer_ID, Customer_Name, Customer_City
FROM Sales_1NF;

INSERT INTO Product (Product_ID, Product_Name)
SELECT DISTINCT Product_ID, Product_Name
FROM Sales_1NF;

INSERT INTO Salesperson (Salesperson_ID, Salesperson_Name)
SELECT DISTINCT Salesperson_ID, Salesperson_Name
FROM Sales_1NF;

INSERT INTO Sales (Sale_ID, Customer_ID, Salesperson_ID)
SELECT DISTINCT Sale_ID, Customer_ID, Salesperson_ID
FROM Sales_1NF;

INSERT INTO Sale_Details (Sale_ID, Product_ID, Quantity)
SELECT Sale_ID, Product_ID, Quantity
FROM Sales_1NF;

-- View the normalized relations.
SELECT * FROM Customer;
SELECT * FROM Product;
SELECT * FROM Salesperson;
SELECT * FROM Sales;
SELECT * FROM Sale_Details;

-- ------------------------------------------------------------
-- 5. Reconstruct the sales information using joins
-- ------------------------------------------------------------

SELECT
    S.Sale_ID,
    C.Customer_Name,
    C.Customer_City,
    P.Product_Name,
    SD.Quantity,
    SP.Salesperson_Name
FROM Sales AS S
JOIN Customer AS C
    ON S.Customer_ID = C.Customer_ID
JOIN Salesperson AS SP
    ON S.Salesperson_ID = SP.Salesperson_ID
JOIN Sale_Details AS SD
    ON S.Sale_ID = SD.Sale_ID
JOIN Product AS P
    ON SD.Product_ID = P.Product_ID
ORDER BY S.Sale_ID, SD.Product_ID;

-- ------------------------------------------------------------
-- 6. Verification queries
-- ------------------------------------------------------------

-- Reconstruct the key sales attributes.
SELECT
    S.Sale_ID,
    S.Customer_ID,
    S.Salesperson_ID,
    SD.Product_ID,
    SD.Quantity
FROM Sales AS S
JOIN Sale_Details AS SD
    ON S.Sale_ID = SD.Sale_ID
ORDER BY S.Sale_ID, SD.Product_ID;

-- Check that sales have a customer reference.
SELECT Sale_ID, Customer_ID, Salesperson_ID
FROM Sales
WHERE Customer_ID IS NOT NULL;

-- Check that sale details have a product reference.
SELECT SD.Sale_ID, SD.Product_ID, SD.Quantity
FROM Sale_Details AS SD
WHERE SD.Product_ID IS NOT NULL;

-- Compare row counts before and after decomposition.
SELECT
    (SELECT COUNT(*) FROM Sales_1NF) AS rows_in_1nf,
    (SELECT COUNT(*)
     FROM Sales AS S
     JOIN Sale_Details AS SD ON S.Sale_ID = SD.Sale_ID) AS rows_after_join;
