# DBMS Experiment 8 – Banking Transactions and Transaction Management

## Aim

To implement banking-style transactions using `BEGIN`, `COMMIT`, `ROLLBACK`, and `SAVEPOINT`, simulate partial failures, and demonstrate transaction isolation levels and concurrency anomalies using two sessions.

## Overview

This experiment demonstrates transaction management in a banking database system using MySQL.

It simulates money transfers between bank accounts and demonstrates how transactions maintain database consistency using transaction control statements.

It also explores different transaction isolation levels and their role in handling concurrent database operations.

## Technologies Used

- **Database:** MySQL
- **Language:** SQL
- **Storage Engine:** InnoDB
- **Concepts:** Transactions, ACID Properties, COMMIT, ROLLBACK, SAVEPOINT, Isolation Levels, Concurrency Control

## Database Structure

The experiment uses the following table:

### Bank_Account

| Column Name | Data Type | Description |
|---|---|---|
| Account_ID | INT | Unique account identifier (Primary Key) |
| Account_Holder | VARCHAR(50) | Name of the account holder |
| Balance | DECIMAL(10,2) | Current account balance |

## Sample Data

The database is initialized with three bank accounts:

| Account_ID | Account_Holder | Balance |
|---|---|---:|
| 101 | Rahul Sharma | 50000.00 |
| 102 | Priya Singh | 30000.00 |
| 103 | Amit Kumar | 40000.00 |

## SQL Concepts Implemented

### 1. BEGIN / START TRANSACTION

Starts a new transaction.

```sql
START TRANSACTION;
```

It allows multiple SQL operations to be executed as a single logical unit.

### 2. COMMIT

Permanently saves all changes made during the transaction.

```sql
COMMIT;
```

### 3. ROLLBACK

Cancels all changes made during the current transaction that have not been committed.

```sql
ROLLBACK;
```

### 4. SAVEPOINT

Creates a checkpoint inside a transaction.

```sql
SAVEPOINT transfer_point;
```

It allows partial rollback without cancelling the entire transaction.

### 5. ROLLBACK TO SAVEPOINT

Rolls back the transaction to a previously created savepoint.

```sql
ROLLBACK TO transfer_point;
```

## Transaction Operations Performed

The experiment demonstrates the following operations:

| Experiment | Operation | Purpose |
|---|---|---|
| 1 | BEGIN and COMMIT | Successful transfer of ₹5,000 |
| 2 | ROLLBACK | Cancelling a ₹10,000 transfer |
| 3 | SAVEPOINT | Partial rollback of a transaction |
| 4 | Multiple SAVEPOINT operations | Rolling back one operation and completing another transfer |
| 5 | READ COMMITTED | Testing transaction isolation |
| 6 | REPEATABLE READ | Testing repeatable read isolation |
| 7 | SERIALIZABLE | Testing serializable isolation |
| 8 | Concurrent transactions | Understanding transaction interactions between sessions |

## Transaction Isolation Levels

The experiment covers three transaction isolation levels:

### 1. READ COMMITTED

- A transaction can read only committed data.
- Prevents dirty reads.
- Non-repeatable reads may occur.

### 2. REPEATABLE READ

- Ensures that repeated consistent reads within a transaction return the same snapshot.
- Prevents dirty reads and non-repeatable reads in MySQL InnoDB.
- Phantom-read behavior is also controlled by InnoDB's locking and snapshot mechanisms.

### 3. SERIALIZABLE

- Provides the strictest isolation level among the three tested.
- Transactions behave as though they are executed serially.
- May introduce additional locking and waiting.

## Two-Session Concurrency Testing

To observe concurrency behavior, open two separate MySQL sessions or connections.

- **Session 1:** Execute a transaction that updates an account balance.
- **Session 2:** Execute a SELECT or UPDATE operation on the same account while Session 1 is active.
- Observe whether the second session reads committed data, waits for a lock, or sees a different result depending on the isolation level.

The isolation-level SELECT statements in the main SQL script are individual tests. Actual concurrency anomalies require coordinating operations between the two sessions.

## ACID Properties

The experiment demonstrates the four ACID properties of database transactions:

| Property | Description |
|---|---|
| Atomicity | A transaction is completed entirely or rolled back |
| Consistency | Database constraints and rules are maintained |
| Isolation | Concurrent transactions are controlled |
| Durability | Committed changes are permanently stored |

## How to Run the Project

### Requirements

- MySQL 8.0 or later
- MySQL Workbench / phpMyAdmin / DBeaver
- Two MySQL sessions for concurrency testing

### Execution Steps

1. Open MySQL Workbench.
2. Connect to your MySQL server.
3. Select the database where you want to execute the experiment.
4. Open `experiment_8.sql`.
5. Execute the SQL statements in sequence.
6. Observe the results of COMMIT, ROLLBACK, and SAVEPOINT operations.
7. Execute the isolation-level tests.
8. Use two separate connections for actual concurrency testing.

**Important:** The script drops the existing `Bank_Account` table before recreating it. Do not execute it if you need to preserve an existing table with that name.

## Expected Outcome

- Successful creation of the Bank_Account table.
- Successful insertion of sample banking records.
- Demonstration of successful transactions using COMMIT.
- Demonstration of transaction cancellation using ROLLBACK.
- Demonstration of partial rollback using SAVEPOINT.
- Understanding of READ COMMITTED, REPEATABLE READ, and SERIALIZABLE isolation levels.
- Understanding of transaction behavior under concurrent execution.

## Repository Structure

```text
DBMS-Experiment-8/
│
├── README.md
└── experiment_8.sql
```

## Conclusion

This experiment demonstrates transaction management in a banking database using SQL transaction control statements.

It explains how BEGIN, COMMIT, ROLLBACK, and SAVEPOINT help manage successful and partially failed transactions. It also provides an understanding of transaction isolation levels and concurrency control mechanisms used to maintain database consistency and reliability.

---

**Subject:** Database Management Systems (DBMS)  
**Experiment:** 08  
**Language:** SQL  
**Database:** MySQL  
**Storage Engine:** InnoDB
