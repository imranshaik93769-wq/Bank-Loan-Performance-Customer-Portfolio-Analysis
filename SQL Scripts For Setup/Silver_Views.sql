Use BankDB;
go
/*=============================================================================
Creating Views with silver schema
===============================================================================*/

-------------------------------------------------------------------------------
-- Create branches Table: silver.branches
-------------------------------------------------------------------------------
If OBJECT_ID('silver.branches','U') is not null
	Drop table silver.branches;
go

Create View silver.branches
AS
	Select branch_id,
		branch_name,
		city,
		state,
		region,
		opening_date,
	employee_count
from bronze.branches;
-------------------------------------------------------------------------------
-- Create customers Table: silver.customers
-------------------------------------------------------------------------------
If OBJECT_ID('silver.customers','U') is not null
	Drop table silver.customers;
go

Create View silver.customers
AS
	Select customer_id,
		first_name,
		last_name,
		date_of_birth,
		gender,
		city,
		state,
		customer_since,
		kyc_status,
		segment,
		annual_income,
		credit_score,
		is_active
	from bronze.customers;
-------------------------------------------------------------------------------
-- Create accounts Table: silver.accounts
-------------------------------------------------------------------------------
If OBJECT_ID('silver.accounts','U') is not null
	Drop table silver.accounts;
go

Create View silver.accounts
AS
	Select account_id,
       customer_id,
       branch_id,
       account_type,
       open_date,
       COALESCE(CONVERT(VARCHAR(10), close_date, 120), 'n/a') AS close_date,
       current_balance,
       interest_rate,
       overdraft_limit,
       status
	from bronze.accounts;
-------------------------------------------------------------------------------
-- Create cards Table: silver.cards
-------------------------------------------------------------------------------
If OBJECT_ID('silver.cards','U') is not null
	Drop table silver.cards;
go

Create View silver.cards
AS
	Select * from bronze.cards;
-------------------------------------------------------------------------------
-- Create transcations Table: silver.transactions
-------------------------------------------------------------------------------
If OBJECT_ID('silver.transactions','U') is not null
	Drop table silver.transactions;
go

Create View silver.transactions
AS
	Select * from bronze.transactions;
-------------------------------------------------------------------------------
-- Create loans Table: silver.loans
-------------------------------------------------------------------------------
If OBJECT_ID('silver.loans','U') is not null
	Drop table silver.loans;
go

Create View silver.loans
AS
	Select * from bronze.loans;
-------------------------------------------------------------------------------
-- Create loan_payments Table: silver.loan_payments
-------------------------------------------------------------------------------
If OBJECT_ID('silver.loan_payments','U') is not null
	Drop table silver.loan_payments;
go

Create View silver.loan_payments
AS
	Select * from bronze.loan_payments;
/*===========================================================================*/

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