# DBMS Experiment 10 – Sales Database Query Optimization and Performance Analysis

## Aim

To create a Sales database containing at least 10,000 records, identify slow SQL queries, analyze their execution plans using EXPLAIN, and optimize queries using indexing and query rewriting techniques.

## Overview

This experiment demonstrates SQL query optimization using a Sales database containing 10,000 records.

It focuses on identifying potentially inefficient queries, analyzing their execution plans, creating indexes, and rewriting queries to improve database performance.

The experiment uses MySQL's `EXPLAIN` command to understand how queries are executed before and after indexing.

## Technologies Used

- **Database:** MySQL
- **Language:** SQL
- **Storage Engine:** InnoDB
- **Concepts:** Query Optimization, Indexing, EXPLAIN, Recursive CTE, Composite Indexing, Query Rewriting, Aggregate Functions

## Database Structure

The experiment uses the following table:

### Sales

| Column Name | Data Type | Description |
|---|---|---|
| Sale_ID | INT | Unique sale identifier (Primary Key) |
| Customer_ID | INT | Customer identifier |
| Customer_Name | VARCHAR(50) | Customer name |
| Product_ID | INT | Product identifier |
| Product_Name | VARCHAR(50) | Product name |
| Category | VARCHAR(30) | Product category |
| Quantity | INT | Quantity purchased |
| Price | DECIMAL(10,2) | Price per unit |
| Total_Amount | DECIMAL(12,2) | Total transaction amount |
| Sale_Date | DATE | Date of sale |
| City | VARCHAR(50) | Customer city |
| Payment_Mode | VARCHAR(20) | Payment method |

## Sample Data Generation

The experiment generates 10,000 sales records using a Recursive Common Table Expression (CTE).

```sql
WITH RECURSIVE Numbers AS (
    SELECT 1 AS n

    UNION ALL

    SELECT n + 1
    FROM Numbers
    WHERE n < 10000
)
```

The generated records contain:

- Customer information
- Product details
- Product categories
- Quantity and pricing
- Sale dates
- City information
- Payment modes

## SQL Concepts Implemented

### 1. Table Creation

Creates the Sales table with appropriate data types and a primary key.

### 2. Recursive CTE

Uses `WITH RECURSIVE` to generate 10,000 records automatically.

### 3. Identifying Slow Queries

Different SQL queries are executed to identify potentially inefficient database operations.

Examples:

- Searching sales by Customer_ID.
- Filtering products by Category.
- Searching sales within a date range.
- Grouping total sales by City.
- Filtering using multiple conditions.

### 4. EXPLAIN Command

The `EXPLAIN` command analyzes how MySQL executes SQL queries.

It provides information about:

- Table access methods.
- Possible indexes.
- Selected indexes.
- Estimated rows examined.
- Query execution strategy.

Example:

```sql
EXPLAIN
SELECT *
FROM Sales
WHERE Customer_ID = 150;
```

### 5. Indexing

The experiment creates the following indexes:

| Index Name | Indexed Column |
|---|---|
| `idx_customer` | Customer_ID |
| `idx_category` | Category |
| `idx_sale_date` | Sale_Date |
| `idx_city` | City |
| `idx_customer_category_date` | Customer_ID, Category, Sale_Date |

### 6. Composite Indexing

A composite index is created using multiple columns:

```sql
CREATE INDEX idx_customer_category_date
ON Sales(Customer_ID, Category, Sale_Date);
```

This index is designed to optimize queries that filter using Customer_ID, Category, and Sale_Date together.

### 7. Query Rewriting

The experiment demonstrates query rewriting techniques, including:

- Selecting only the required columns instead of using `SELECT *`.
- Using appropriate date range conditions.
- Applying aggregate functions.
- Retrieving the top 10 highest-value sales using `LIMIT`.
- Calculating total revenue.

## Before and After Indexing

The experiment compares query execution plans before and after creating indexes.

| Before Indexing | After Indexing |
|---|---|
| Queries may require full table scans | Queries may use available indexes |
| More records may need to be examined | Fewer records may need to be examined |
| No additional secondary indexes | Multiple indexes available |
| Execution plans analyzed using EXPLAIN | Execution plans analyzed again using EXPLAIN |

**Note:** Index creation does not guarantee faster execution for every query. MySQL's optimizer chooses whether to use an index based on estimated cost, selectivity, and available statistics.

## Additional SQL Operations

The experiment also performs:

1. Counting total sales records.
2. Calculating category-wise sales.
3. Calculating total revenue.
4. Retrieving the top 10 highest-value sales.
5. Displaying all indexes using `SHOW INDEX`.
6. Updating table statistics using `ANALYZE TABLE`.

## How to Run the Project

### Requirements

- MySQL 8.0 or later
- MySQL Workbench / phpMyAdmin / DBeaver

### Execution Steps

1. Open MySQL Workbench.
2. Connect to your MySQL server.
3. Select the database in which you want to execute the experiment.
4. Open `experiment_10.sql`.
5. Execute the complete SQL script.
6. Verify that 10,000 records have been inserted.
7. Execute the EXPLAIN queries before indexing.
8. Create the indexes.
9. Execute the EXPLAIN queries again.
10. Compare the execution plans.
11. Review the optimized queries and their outputs.

**Important:** The script drops the existing `Sales` table before recreating it. Do not execute it if you need to preserve an existing table with that name.

## Expected Outcome

- Successful creation of the Sales table.
- Successful generation of 10,000 records.
- Identification of potentially slow SQL queries.
- Analysis of execution plans using EXPLAIN.
- Successful creation of single-column and composite indexes.
- Comparison of query execution plans before and after indexing.
- Understanding of query rewriting and optimization techniques.

## Repository Structure

```text
DBMS-Experiment-10/
│
├── README.md
└── experiment_10.sql
```

## Conclusion

This experiment demonstrates SQL query optimization using a Sales database containing 10,000 records.

It provides practical understanding of identifying inefficient queries, analyzing execution plans using EXPLAIN, creating indexes, implementing composite indexing, and rewriting SQL queries to improve database performance.

---

**Subject:** Database Management Systems (DBMS)  
**Experiment:** 10  
**Language:** SQL  
**Database:** MySQL  
**Storage Engine:** InnoDB
