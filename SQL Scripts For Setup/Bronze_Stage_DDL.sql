USE BankDB;
GO

/*==============================================================
  1. BRANCHES STAGE
==============================================================*/

IF OBJECT_ID('bronze.branches_stage','U') IS NOT NULL
    DROP TABLE bronze.branches_stage;
GO

CREATE TABLE bronze.branches_stage
(
    branch_id       NVARCHAR(50),
    branch_name     NVARCHAR(50),
    city            NVARCHAR(50),
    state           NVARCHAR(50),
    region          NVARCHAR(50),
    opening_date    NVARCHAR(50),
    employee_count  NVARCHAR(50)
);
GO


/*==============================================================
  2. CUSTOMERS STAGE
==============================================================*/

IF OBJECT_ID('bronze.customers_stage','U') IS NOT NULL
    DROP TABLE bronze.customers_stage;
GO

CREATE TABLE bronze.customers_stage
(
    customer_id      NVARCHAR(50),
    first_name       NVARCHAR(50),
    last_name        NVARCHAR(50),
    date_of_birth    NVARCHAR(50),
    gender           NVARCHAR(50),
    city             NVARCHAR(50),
    state            NVARCHAR(50),
    customer_since   NVARCHAR(50),
    kyc_status       NVARCHAR(50),
    segment          NVARCHAR(50),
    annual_income    NVARCHAR(50),
    credit_score     NVARCHAR(50),
    is_active        NVARCHAR(50)
);
GO


/*==============================================================
  3. ACCOUNTS STAGE
==============================================================*/

IF OBJECT_ID('bronze.accounts_stage','U') IS NOT NULL
    DROP TABLE bronze.accounts_stage;
GO

CREATE TABLE bronze.accounts_stage
(
    account_id          NVARCHAR(50),
    customer_id         NVARCHAR(50),
    branch_id           NVARCHAR(50),
    account_type        NVARCHAR(50),
    open_date           NVARCHAR(50),
    close_date          NVARCHAR(50),
    current_balance     NVARCHAR(50),
    interest_rate       NVARCHAR(50),
    overdraft_limit     NVARCHAR(50),
    status              NVARCHAR(50)
);
GO


/*==============================================================
  4. CARDS STAGE
==============================================================*/

IF OBJECT_ID('bronze.cards_stage','U') IS NOT NULL
    DROP TABLE bronze.cards_stage;
GO

CREATE TABLE bronze.cards_stage
(
    card_id                NVARCHAR(50),
    account_id             NVARCHAR(50),
    card_type               NVARCHAR(50),
    issue_date              NVARCHAR(50),
    expiry_date             NVARCHAR(50),
    credit_limit            NVARCHAR(50),
    outstanding_balance     NVARCHAR(50),
    reward_points           NVARCHAR(50),
    is_active               NVARCHAR(50),
    network                 NVARCHAR(50)
);
GO


/*==============================================================
  5. TRANSACTIONS STAGE
==============================================================*/

IF OBJECT_ID('bronze.transactions_stage','U') IS NOT NULL
    DROP TABLE bronze.transactions_stage;
GO

CREATE TABLE bronze.transactions_stage
(
    transaction_id      NVARCHAR(50),
    account_id          NVARCHAR(50),
    transaction_date    NVARCHAR(50),
    transaction_time    NVARCHAR(50),
    transaction_type    NVARCHAR(50),
    amount              NVARCHAR(50),
    channel             NVARCHAR(50),
    description         NVARCHAR(50),
    balance_after       NVARCHAR(50),
    status              NVARCHAR(50)
);
GO


/*==============================================================
  6. LOANS STAGE
==============================================================*/

IF OBJECT_ID('bronze.loans_stage','U') IS NOT NULL
    DROP TABLE bronze.loans_stage;
GO

CREATE TABLE bronze.loans_stage
(
    loan_id                 NVARCHAR(50),
    customer_id             NVARCHAR(50),
    branch_id               NVARCHAR(50),
    loan_type               NVARCHAR(50),
    principal_amount        NVARCHAR(50),
    interest_rate           NVARCHAR(50),
    tenure_months           NVARCHAR(50),
    disbursement_date       NVARCHAR(50),
    maturity_date           NVARCHAR(50),
    emi_amount              NVARCHAR(50),
    outstanding_balance     NVARCHAR(50),
    loan_status             NVARCHAR(50),
    purpose                 NVARCHAR(50)
);
GO


/*==============================================================
  7. LOAN PAYMENTS STAGE
==============================================================*/

IF OBJECT_ID('bronze.loan_payments_stage','U') IS NOT NULL
    DROP TABLE bronze.loan_payments_stage;
GO

CREATE TABLE bronze.loan_payments_stage
(
    payment_id          NVARCHAR(50),
    loan_id              NVARCHAR(50),
    payment_date        NVARCHAR(50),
    scheduled_amount    NVARCHAR(50),
    paid_amount         NVARCHAR(50),
    principal_paid      NVARCHAR(50),
    interest_paid       NVARCHAR(50),
    penalty             NVARCHAR(50),
    days_late           NVARCHAR(50),
    payment_method     NVARCHAR(50),
    status              NVARCHAR(50)
);
GO