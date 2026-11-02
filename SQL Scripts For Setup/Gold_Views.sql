USE BankDB;
GO

/*=============================================================================
  GOLD LAYER using Star Schema
=============================================================================*/

-- 1.Customer Demesion Table View
-------------------------------------------------------------------------------
IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
    DROP VIEW gold.dim_customers;
GO

CREATE VIEW gold.dim_customers as
SELECT 
    customer_id,
    CONCAT(first_name, ' ', last_name) as customer_name,
    gender,
    city,
    state,
    date_of_birth,
    DATEDIFF(YEAR, date_of_birth, GETDATE()) as age,
    customer_since,
    kyc_status,
    segment,
    annual_income,
    credit_score,
    is_active
FROM silver.customers;
go


-- 2. TRANSACTIONS FACT Transactions and Customer & Branch Details
-------------------------------------------------------------------------------
IF OBJECT_ID('gold.fact_transactions', 'V') IS NOT NULL
    DROP VIEW gold.fact_transactions;
GO

CREATE VIEW gold.fact_transactions as
SELECT 
    t.transaction_id,
    t.account_id,
    a.customer_id,
    a.branch_id,
    t.transaction_date,
    t.transaction_time,
    t.transaction_type,
    t.amount,
    t.channel,
    t.description,
    t.balance_after,
    t.status
FROM silver.transactions t
JOIN silver.accounts a 
    ON t.account_id = a.account_id;
GO


-- 3. LOAN PAYMENTS FACT Payments and Loan Details
-------------------------------------------------------------------------------
IF OBJECT_ID('gold.fact_loan_payments', 'V') IS NOT NULL
    DROP VIEW gold.fact_loan_payments;
GO

CREATE VIEW gold.fact_loan_payments as
SELECT 
    p.payment_id,
    p.loan_id,
    l.customer_id,
    l.branch_id,
    l.loan_type,
    p.payment_date,
    p.scheduled_amount,
    p.paid_amount,
    p.principal_paid,
    p.interest_paid,
    p.penalty,
    p.days_late,
    p.payment_method,
    p.status as payment_status,
    l.loan_status
FROM silver.loan_payments p
JOIN silver.loans l 
    ON p.loan_id = l.loan_id;
GO


-- 4.Branch Summary Table using Silver.branches and Silevr.Accounts
-------------------------------------------------------------------------------
IF OBJECT_ID('gold.branch_summary', 'V') IS NOT NULL
    DROP VIEW gold.branch_summary;
GO

CREATE VIEW gold.branch_summary as
SELECT 
    b.branch_id,
    b.branch_name,
    b.city,
    b.state,
    b.region,
    b.employee_count,
    COUNT(DISTINCT a.account_id) as total_accounts,
    SUM(a.current_balance) as total_branch_balance
FROM silver.branches as b
LEFT JOIN silver.accounts as a 
    ON b.branch_id = a.branch_id
GROUP BY 
    b.branch_id,
    b.branch_name,
    b.city,
    b.state,
    b.region,
    b.employee_count;
go


Select * from gold.dim_customers;
select * from gold.fact_transactions;
select * from gold.fact_loan_payments;
select * from gold.branch_summary;


