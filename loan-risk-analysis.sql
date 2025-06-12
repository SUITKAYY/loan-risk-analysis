-- Loan Risk Analysis Project
-- Author: [Kyrylo Zaiets]
-- Purpose: Analyze loan risk based on synthetic banking data

-- STEP 1: CREATE TABLE

CREATE TABLE loan_data
(
    customer_id int,
    loan_amount DECIMAL(10,2),
    term_month int,
    interest_rate DECIMAL(5,2),
    credit_score int,
    payment_status varchar(20),
    loan_type varchar(20),

    CONSTRAINT PK_customer_customer_id PRIMARY KEY(customer_id)
);

-- STEP 2: INSERT DATA INTO TABLE

INSERT INTO loan_data
VALUES
(1001, 20000, 36, 7.5, 680, 'paid_on_time', 'personal'),
(1002, 15000, 24, 8.2, 590, 'delayed', 'car'),
(1003, 30000, 60, 6.5, 710, 'paid_on_time', 'mortgage'),
(1004, 10000, 12, 12.0, 520, 'default', 'personal');

SELECT * FROM loan_data; -- Just to view the table

-- STEP 3: Assessment of average interest rate per loan_type

SELECT loan_type, AVG(interest_rate) as avg_Rate
FROM loan_data
GROUP BY loan_type;

-- STEP 4: Count risky clients that have low credit score

SELECT COUNT(*) AS risky_clients
FROM loan_data
WHERE credit_score < 600 AND payment_status = 'delayed';

-- STEP 5: Default rate that grouped by loan type

SELECT loan_type , COUNT(CASE WHEN payment_status = 'default' THEN 1 END) * COUNT(*) AS default_rate 
FROM loan_data
GROUP BY loan_type;

-- STEP 6: Assessment of average term for clients with good credit score

SELECT AVG(term_month)
FROM loan_data
WHERE credit_score >= 650;

-- STEP 7: Add a risk flag using CASE logic

SELECT *, CASE WHEN credit_score < 600 AND interest_rate > 10.0 AND term_month > 24 THEN 'High'
               ELSE 'Low'
          END AS risk_flag
FROM loan_data;

ALTER TABLE loan_date RENAME TO loan_data; -- Correction of data name

ALTER TABLE loan_data RENAME COLUMN creadit_score TO credit_score; -- Correction of data's column

-- STEP 8: Create a VIEW to reuse high-risk classification

CREATE VIEW loan_risky_summary AS
SELECT customer_id, credit_score, interest_rate, 
CASE WHEN credit_score < 600 AND interest_rate > 10.0 AND term_month > 24 THEN 'High'
     ELSE 'Low'
     END AS risk_flag 
FROM loan_data;

-- Step 9: Query only high-risk clients

SELECT *
FROM (
    SELECT *, 
           CASE 
               WHEN credit_score < 600 AND interest_rate > 10.0 AND term_month > 24 THEN 'High'
               ELSE 'Low'
           END AS risk_flag
    FROM loan_data
) AS sub
WHERE risk_flag = 'High';

