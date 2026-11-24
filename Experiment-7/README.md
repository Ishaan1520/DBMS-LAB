# DBMS Experiment 7 – Normalization of Sales Table

## Aim

To normalize a denormalized Sales table from Unnormalized Form (UNF) to First Normal Form (1NF), Third Normal Form (3NF), and Boyce-Codd Normal Form (BCNF), and to verify lossless join and dependency preservation.

## Overview

This experiment demonstrates the process of database normalization using a Sales table containing customer, product, salesperson, and sales information.

The original denormalized table is decomposed into multiple related tables to reduce data redundancy and improve data consistency.

## Technologies Used

- **Database:** MySQL
- **Language:** SQL
- **Concepts:** Database Normalization, Primary Keys, Foreign Keys, Joins, Functional Dependencies

## Database Tables

The experiment creates the following tables:

| Table Name | Description |
|---|---|
| `Sales_UNF` | Original denormalized Sales table |
| `Sales_1NF` | Sales table converted into First Normal Form |
| `Customer` | Stores customer information |
| `Product` | Stores product information |
| `Salesperson` | Stores salesperson information |
| `Sales` | Stores sale-related information |
| `Sale_Details` | Stores product and quantity details for each sale |

## Normalization Process

### 1. Unnormalized Form (UNF)

The original Sales table contains the following attributes:

- Sale_ID
- Customer_ID
- Customer_Name
- Customer_City
- Product_ID
- Product_Name
- Quantity
- Salesperson_ID
- Salesperson_Name

### 2. First Normal Form (1NF)

The table is converted into 1NF by ensuring atomic values and defining a composite primary key:

`PRIMARY KEY (Sale_ID, Product_ID)`

### 3. Third Normal Form (3NF)

The original table is decomposed into separate tables:

- Customer
- Product
- Salesperson
- Sales
- Sale_Details

This decomposition separates customer, product, salesperson, and transaction details.

### 4. Boyce-Codd Normal Form (BCNF)

The decomposed relations use their respective candidate keys as determinants for the functional dependencies represented in the design.

Primary keys and foreign keys are used to maintain data integrity and relationships between tables.

## Functional Dependencies

The following functional dependencies are represented:

- `Customer_ID → Customer_Name, Customer_City`
- `Product_ID → Product_Name`
- `Salesperson_ID → Salesperson_Name`
- `Sale_ID → Customer_ID, Salesperson_ID`
- `(Sale_ID, Product_ID) → Quantity`

## SQL Operations Performed

The SQL script includes:

1. Creating the original UNF table.
2. Inserting sample sales records.
3. Converting the table into 1NF.
4. Creating normalized tables.
5. Defining primary key and foreign key constraints.
6. Inserting distinct records into normalized tables.
7. Retrieving records using SELECT statements.
8. Joining normalized tables to reconstruct the original sales information.
9. Performing verification queries.

## Sample Data

The experiment uses five sample sales records:

| Sale_ID | Customer | Product | Quantity | Salesperson |
|---|---|---|---|---|
| 1 | Rahul Sharma | Laptop | 2 | Amit Kumar |
| 2 | Priya Singh | Mouse | 3 | Neha Gupta |
| 3 | Arjun Verma | Keyboard | 1 | Rohit Singh |
| 4 | Sneha Gupta | Monitor | 2 | Amit Kumar |
| 5 | Vivek Sharma | Printer | 1 | Neha Gupta |

## How to Run the Project

### Requirements

- MySQL 8.0 or later
- MySQL Workbench / phpMyAdmin / DBeaver

### Execution Steps

1. Open MySQL Workbench.
2. Select your database.
3. Open the `experiment_7.sql` file.
4. Execute the complete SQL script.
5. View the output of the SELECT and JOIN queries.
6. Verify the records in the normalized tables.

**Note:** The script contains DROP TABLE statements to allow rerunning the experiment. Ensure that you do not have existing tables with these names that you need to preserve.

## Repository Structure

```text
DBMS-Experiment-7/
│
├── README.md
└── experiment_7.sql
```

## Expected Outcome

- Successful creation of the UNF and 1NF tables.
- Successful decomposition into normalized relations.
- Proper implementation of primary and foreign key constraints.
- Successful retrieval of data using JOIN operations.
- Verification of the reconstructed sales records.

## Conclusion

The experiment demonstrates the normalization of a denormalized Sales table into structured relational tables. It helps understand 1NF, 3NF, BCNF, functional dependencies, primary keys, foreign keys, and the reconstruction of data using JOIN operations.

---

**Subject:** Database Management Systems (DBMS)  
**Experiment:** 07  
**Language:** SQL  
**Database:** MySQL
