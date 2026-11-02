/* Creating the Tables*/
Use BankDB;
--1.for branches
--======================================================================================================
IF object_id('bronze.branches','U') is not null
	drop table bronze.branches;
go
Create table bronze.branches(
	branch_id	NVARCHAR(50),
	branch_name	NVARCHAR(50),
	city		NVARCHAR(50),
	state		NVARCHAR(50),
	region		NVARCHAR(50),
	opening_date DATE,	
	employee_count INT,

	CONSTRAINT PK_branches PRIMARY KEY (branch_id)
);
--======================================================================================================
go

--2.for Customers
--======================================================================================================
If Object_id('bronze.customers','U') is not null
	Drop table bronze.customers;
go
Create table bronze.customers(
	customer_id			NVARCHAR(50),
	first_name			NVARCHAR(50),
	last_name			NVARCHAR(50),
	date_of_birth		DATE,
	gender				NVARCHAR(50),
	city				NVARCHAR(50),
	state				NVARCHAR(50),
	customer_since		DATE,
	kyc_status			NVARCHAR(50),
	segment				NVARCHAR(50),
	annual_income		DECIMAL(12,2),
	credit_score		INT,
	is_active			NVARCHAR(50),

	CONSTRAINT PK_customers PRIMARY KEY (customer_id)
);
--======================================================================================================
go

--3.for Accounts
--======================================================================================================
IF Object_id('bronze.accounts','U') is not null
	Drop table bronze.accounts;
go
Create table bronze.accounts(
	account_id			NVARCHAR(50),
	customer_id			NVARCHAR(50),
	branch_id			NVARCHAR(50),
	account_type		NVARCHAR(50),
	open_date			DATE,
	close_date			DATE,
	current_balance		DECIMAL(12,2),
	interest_rate		DECIMAL(12,2),
	overdraft_limit		DECIMAL(12,2),
	status				NVARCHAR(50),

	CONSTRAINT PK_accounts PRIMARY KEY (account_id),

	CONSTRAINT FK_accounts_customers
	FOREIGN KEY (customer_id)
	REFERENCES bronze.customers(customer_id),

	CONSTRAINT FK_accounts_branches
	FOREIGN KEY (branch_id)
	REFERENCES bronze.branches(branch_id)

);
--======================================================================================================
go

--4.for Cards
--======================================================================================================
IF Object_id('bronze.cards','U') is not null
	Drop table bronze.cards;
go

Create table bronze.cards(
	card_id					NVARCHAR(50),
	account_id				NVARCHAR(50),
	card_type				NVARCHAR(50),
	issue_date				DATE,
	expiry_date				DATE,
	credit_limit	        DECIMAL(12,2),
	outstanding_balance		DECIMAL(12,2),
	reward_points			INT,
	is_active				NVARCHAR(50),
	network					NVARCHAR(50),

	CONSTRAINT PK_card PRIMARY KEY (card_id),

	CONSTRAINT FK_cards_accounts
	FOREIGN KEY (account_id)
	REFERENCES bronze.accounts(account_id)
);
--======================================================================================================
go

--5.for Transactions
--======================================================================================================
IF Object_id('bronze.transactions','U') is not null
	Drop table bronze.transactions;
go
Create Table bronze.transactions(
	transaction_id		NVARCHAR(50),
	account_id			NVARCHAR(50),
	transaction_date	DATE,
	transaction_time	TIME,
	transaction_type	NVARCHAR(50),
	amount				DECIMAL(12,2),
	channel				NVARCHAR(50),
	description			NVARCHAR(50),
	balance_after		DECIMAL(12,2),
	status				NVARCHAR(50),

	CONSTRAINT PK_transactions PRIMARY KEY (transaction_id),

	CONSTRAINT FK_transactions_accounts
	FOREIGN KEY (account_id)
	REFERENCES bronze.accounts(account_id)
);
--======================================================================================================
go

--6.for Loans
--======================================================================================================
IF Object_id('bronze.loans','U') is not null
	Drop table bronze.loans;
go
Create table bronze.loans(
	loan_id					NVARCHAR(50),
	customer_id				NVARCHAR(50),
	branch_id				NVARCHAR(50),
	loan_type				NVARCHAR(50),
	principal_amount		DECIMAL(12,2),
	interest_rate			DECIMAL(12,2),
	tenure_months			INT,
	disbursement_date		DATE,
	maturity_date			DATE,
	emi_amount				DECIMAL(12,2),
	outstanding_balance		DECIMAL(12,2),
	loan_status				NVARCHAR(50),
	purpose					NVARCHAR(50),

	CONSTRAINT PK_loans PRIMARY KEY (loan_id),

	CONSTRAINT FK_loans_customers
	FOREIGN KEY (customer_id)
	REFERENCES bronze.customers(customer_id),

	CONSTRAINT FK_loans_branches
	FOREIGN KEY (branch_id)
	REFERENCES bronze.branches(branch_id)

);
--======================================================================================================
go

--7.for Loan Payments
--======================================================================================================
IF Object_id('bronze.loan_payments','U') is not null
	Drop table bronze.loan_payments;
go
Create table bronze.loan_payments(
	payment_id			NVARCHAR(50),
	loan_id				NVARCHAR(50),
	payment_date		DATE,
	scheduled_amount	DECIMAL(12,2),
	paid_amount			DECIMAL(12,2),
	principal_paid		DECIMAL(12,2),
	interest_paid		DECIMAL(12,2),
	penalty				DECIMAL(12,2),
	days_late			INT,
	payment_method		NVARCHAR(50),
	status				NVARCHAR(50),

	CONSTRAINT PK_loan_payments PRIMARY KEY (payment_id),

	CONSTRAINT FK_loanpayments_loans
	FOREIGN KEY (loan_id)
	REFERENCES bronze.loans(loan_id)
);
--======================================================================================================