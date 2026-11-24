-- ============================================================
-- DBMS EXPERIMENT - 8
-- Banking Transactions and Transaction Isolation
-- Database: MySQL 8.0+
-- ============================================================

-- 1. CREATE BANK ACCOUNT TABLE

DROP TABLE IF EXISTS Bank_Account;

CREATE TABLE Bank_Account (
    Account_ID INT PRIMARY KEY,
    Account_Holder VARCHAR(50),
    Balance DECIMAL(10,2)
) ENGINE = InnoDB;


-- 2. INSERT SAMPLE DATA

INSERT INTO Bank_Account
VALUES
(101, 'Rahul Sharma', 50000.00),
(102, 'Priya Singh', 30000.00),
(103, 'Amit Kumar', 40000.00);

SELECT * FROM Bank_Account;


-- ============================================================
-- 3. TRANSACTION USING BEGIN AND COMMIT
-- ============================================================

START TRANSACTION;

UPDATE Bank_Account
SET Balance = Balance - 5000
WHERE Account_ID = 101;

UPDATE Bank_Account
SET Balance = Balance + 5000
WHERE Account_ID = 102;

COMMIT;

SELECT * FROM Bank_Account;


-- ============================================================
-- 4. TRANSACTION USING ROLLBACK
-- ============================================================

START TRANSACTION;

UPDATE Bank_Account
SET Balance = Balance - 10000
WHERE Account_ID = 101;

UPDATE Bank_Account
SET Balance = Balance + 10000
WHERE Account_ID = 103;

ROLLBACK;

SELECT * FROM Bank_Account;


-- ============================================================
-- 5. TRANSACTION USING SAVEPOINT
-- ============================================================

START TRANSACTION;

UPDATE Bank_Account
SET Balance = Balance - 3000
WHERE Account_ID = 101;

SAVEPOINT transfer_point;

UPDATE Bank_Account
SET Balance = Balance + 3000
WHERE Account_ID = 102;

ROLLBACK TO transfer_point;

COMMIT;

SELECT * FROM Bank_Account;


-- ============================================================
-- 6. PARTIAL ROLLBACK USING SAVEPOINT
-- ============================================================

START TRANSACTION;

UPDATE Bank_Account
SET Balance = Balance - 2000
WHERE Account_ID = 101;

SAVEPOINT before_second_transfer;

UPDATE Bank_Account
SET Balance = Balance + 2000
WHERE Account_ID = 102;

ROLLBACK TO before_second_transfer;

UPDATE Bank_Account
SET Balance = Balance + 2000
WHERE Account_ID = 103;

COMMIT;

SELECT * FROM Bank_Account;


-- ============================================================
-- 7. TRANSACTION ISOLATION LEVEL: READ COMMITTED
-- ============================================================

SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

START TRANSACTION;

SELECT *
FROM Bank_Account
WHERE Account_ID = 101;

COMMIT;


-- ============================================================
-- 8. TRANSACTION ISOLATION LEVEL: REPEATABLE READ
-- ============================================================

SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

START TRANSACTION;

SELECT *
FROM Bank_Account
WHERE Account_ID = 101;

COMMIT;


-- ============================================================
-- 9. TRANSACTION ISOLATION LEVEL: SERIALIZABLE
-- ============================================================

SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;

START TRANSACTION;

SELECT *
FROM Bank_Account
WHERE Account_ID = 101;

COMMIT;


-- ============================================================
-- 10. TRANSACTION WITH READ COMMITTED
-- ============================================================

SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

START TRANSACTION;

SELECT Balance
FROM Bank_Account
WHERE Account_ID = 101;

UPDATE Bank_Account
SET Balance = Balance - 5000
WHERE Account_ID = 101;

COMMIT;


-- ============================================================
-- 11. SECOND TRANSACTION WITH READ COMMITTED
-- ============================================================

SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

START TRANSACTION;

SELECT Balance
FROM Bank_Account
WHERE Account_ID = 101;

UPDATE Bank_Account
SET Balance = Balance - 3000
WHERE Account_ID = 101;

COMMIT;


-- ============================================================
-- 12. FINAL ACCOUNT BALANCE
-- ============================================================

SELECT *
FROM Bank_Account
WHERE Account_ID = 101;

-- ============================================================
-- END OF EXPERIMENT 8
-- ============================================================
