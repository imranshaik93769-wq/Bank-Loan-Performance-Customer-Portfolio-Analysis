Use BankDB;
go
--Checking the Tables:
------------------------------------------
select * from bronze.branches;
select * from bronze.customers;
select * from bronze.accounts;
select * from bronze.cards;
select * from bronze.transactions;
select * from bronze.loans;
select * from bronze.loan_payments;
------------------------------------------

-- Calculate the No.of Rows in each table:
------------------------------------------
SELECT COUNT(*) AS branches_count
FROM bronze.branches;

SELECT COUNT(*) AS customers_count
FROM bronze.customers;

SELECT COUNT(*) AS accounts_count
FROM bronze.accounts;

SELECT COUNT(*) AS cards_count
FROM bronze.cards;

SELECT COUNT(*) AS transactions_count
FROM bronze.transactions;

SELECT COUNT(*) AS loans_count
FROM bronze.loans;

SELECT COUNT(*) AS loan_payments_count
FROM bronze.loan_payments;

------------------------------------------
--For Checking the Datatypes of Columns in Table
------------------------------------------
SELECT
    COLUMN_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'bronze'
  AND TABLE_NAME = 'branches';
------------------------------------------

--FOR Checking the Duplicate records in Tables
------------------------------------------
--Branches:
select branch_id,
       count(*) as total_count
from bronze.branches
group by branch_id
having count(*)>1;

--Customers:
select customer_id,
       count(*) as total_count
from bronze.customers
group by customer_id
having count(*)>1;

--Accounts:
select account_id,
       count(*) as total_count
from bronze.accounts
group by account_id
having count(*)>1;

--Cards:
select card_id,
       count(*) as total_count
from bronze.cards
group by card_id
having count(*)>1;

--Transactions:
select transaction_id,
       count(*) as total_count
from bronze.transactions
group by transaction_id
having count(*)>1;

--Loans:
select loan_id,
       count(*) as total_count
from bronze.loans
group by loan_id
having count(*)>1;

--Loan_Payments:
select payment_id,
       count(*) as total_count
from bronze.loan_payments
group by payment_id
having count(*)>1;
------------------------------------------


--1
select count(*) as NullsCount
from bronze.branches
where branch_id is null 
      or branch_name is null
      or city is null
      or state is null
      or region is null
      or opening_date is null
      or employee_count is null;

--2
select count(*) as NullsCount
from bronze.customers
where customer_id is null 
      or first_name is null
      or last_name is null
      or date_of_birth is null
      or gender is null
      or  city is null
      or state is null
      or customer_since is null 
      or kyc_status is null
      or segment is null
      or annual_income is null
      or credit_score is null
      or  is_active is null;

--3
select count(*) as NullsCount
from bronze.accounts
where account_id is null 
      or customer_id is null
      or branch_id is null
      or account_type is null
      or open_date is null
      or  close_date is null
      or current_balance is null
      or interest_rate is null 
      or overdraft_limit is null
      or status is null;
-- nulls replaced by 'n/a'
SELECT account_id,
       customer_id,
       branch_id,
       account_type,
       open_date,
       COALESCE(CONVERT(VARCHAR(10), close_date, 120), 'n/a') AS close_date,
       current_balance,
       interest_rate,
       overdraft_limit,
       status
FROM bronze.accounts;

--4
select count(*) as NullsCount
from bronze.cards
Where   card_id is null
        or account_id is null
        or card_type is null
        or issue_date is null
        or expiry_date is null
        or credit_limit is null
        or outstanding_balance is null
        or reward_points is null
        or is_active is null
        or network is null;

--5
SELECT count(*) as NullsCount
FROM bronze.transactions
WHERE transaction_id IS NULL
   OR account_id IS NULL
   OR transaction_date IS NULL
   OR transaction_time IS NULL
   OR transaction_type IS NULL
   OR amount IS NULL
   OR channel IS NULL
   OR description IS NULL
   OR balance_after IS NULL
   OR status IS NULL;

--6
SELECT COUNT(*) as Nullscount
FROM bronze.loans
WHERE loan_id IS NULL
   OR customer_id IS NULL
   OR branch_id IS NULL
   OR loan_type IS NULL
   OR principal_amount IS NULL
   OR interest_rate IS NULL
   OR tenure_months IS NULL
   OR disbursement_date IS NULL
   OR maturity_date IS NULL
   OR emi_amount IS NULL
   OR outstanding_balance IS NULL
   OR loan_status IS NULL
   OR purpose IS NULL;

--7
SELECT COUNT(*) as Nullscount
FROM bronze.loan_payments
WHERE payment_id IS NULL
   OR loan_id IS NULL
   OR payment_date IS NULL
   OR scheduled_amount IS NULL
   OR paid_amount IS NULL
   OR principal_paid IS NULL
   OR interest_paid IS NULL
   OR penalty IS NULL
   OR days_late IS NULL
   OR payment_method IS NULL
   OR status IS NULL;

-------------------------------------------------------------------------------
-- check the View Tables:
-------------------------------------------------------------------------------
select * from silver.branches;
select * from silver.customers;
select * from silver.accounts;
select * from silver.cards;
select * from silver.transactions;
select * from silver.loans;
select * from silver.loan_payments;