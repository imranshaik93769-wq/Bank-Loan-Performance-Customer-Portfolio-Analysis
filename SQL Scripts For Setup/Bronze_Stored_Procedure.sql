USE BankDB;
GO

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN

    DECLARE @start_time DATETIME,@end_time DATETIME,@batch_start_time DATETIME,@batch_end_time DATETIME

        SET @batch_start_time=GETDATE();

        ----------------------------------------------------------------------------------------------------------------------------------------
        PRINT '-------------------------------'
        PRINT'Loading bronze Layer'
        PRINT'--------------------------------'
        -----------------------------------------------
        PRINT'--------------------------------'
        PRINT'Loading Bank Tables'
        PRINT'--------------------------------'
      /*==============================================================
          DELETE EXISTING DATA
          Child Tables First -> Parent Tables
        ==============================================================*/

        PRINT'Deleting Existing Data From Bronze Tables'

        DELETE FROM bronze.loan_payments;
        DELETE FROM bronze.transactions;
        DELETE FROM bronze.cards;
        DELETE FROM bronze.loans;
        DELETE FROM bronze.accounts;
        DELETE FROM bronze.customers;
        DELETE FROM bronze.branches;

        PRINT'Existing Data Deleted Successfully'
        PRINT'================================================================================================================================'
        /*==============================================================
          1. BRANCHES
        ==============================================================*/

        SET @start_time=GETDATE();

        PRINT'Branches:'
        PRINT'Deleting Data From Table: bronze.branches_stage'

        TRUNCATE TABLE bronze.branches_stage;

        PRINT'Bulk Insert Into bronze.branches_stage:'

        BULK INSERT bronze.branches_stage
        FROM 'C:\Users\imran\OneDrive\Desktop\Projects\My projects\Not Completed Projects\Bank Loan Project\Datasets\branches.csv'
        WITH(
                FIRSTROW=2,
                FIELDTERMINATOR=',',
                ROWTERMINATOR='0x0A',
                CODEPAGE='65001',
                TABLOCK
        );

        PRINT'Bulk Insert Completed'

        PRINT'Inserting Data Into bronze.branches:'

        INSERT INTO bronze.branches
        (
            branch_id,
            branch_name,
            city,
            state,
            region,
            opening_date,
            employee_count
        )
        SELECT
            branch_id,
            branch_name,
            city,
            state,
            region,
            TRY_CONVERT(DATE, opening_date, 105),
            TRY_CONVERT(INT, TRIM(REPLACE(employee_count, CHAR(13), '')))
        FROM bronze.branches_stage;

        TRUNCATE TABLE bronze.branches_stage;

        SET @end_time=GETDATE();

        PRINT'Branches Loaded Successfully'
        PRINT'LOAD DURATION:' + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR) + 'Sec'
        PRINT'================================================================================================================================'
        /*==============================================================
          2. CUSTOMERS
        ==============================================================*/

        SET @start_time=GETDATE();

        PRINT'Customers:'
        PRINT'Deleting Data From Table: bronze.customers_stage'

        TRUNCATE TABLE bronze.customers_stage;

        PRINT'Bulk Insert Into bronze.customers_stage:'

        BULK INSERT bronze.customers_stage
        FROM 'C:\Users\imran\OneDrive\Desktop\Projects\My projects\Not Completed Projects\Bank Loan Project\Datasets\customers.csv'
        WITH(
                FIRSTROW=2,
                FIELDTERMINATOR=',',
                ROWTERMINATOR='0x0A',
                CODEPAGE='65001',
                TABLOCK
        );

        PRINT'Bulk Insert Completed'

        PRINT'Inserting Data Into bronze.customers:'

        INSERT INTO bronze.customers
        (
            customer_id,
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
        )
        SELECT
            customer_id,
            first_name,
            last_name,
            TRY_CONVERT(DATE, date_of_birth, 105),
            gender,
            city,
            state,
            TRY_CONVERT(DATE, customer_since, 105),
            kyc_status,
            segment,
            TRY_CONVERT(DECIMAL(12,2), annual_income),
            TRY_CONVERT(INT, credit_score),
            is_active
        FROM bronze.customers_stage;

        TRUNCATE TABLE bronze.customers_stage;

        SET @end_time=GETDATE();

        PRINT'Customers Loaded Successfully'
        PRINT'LOAD DURATION:' + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR) + 'Sec'
        PRINT'================================================================================================================================'
        /*==============================================================
          3. ACCOUNTS
        ==============================================================*/

        SET @start_time=GETDATE();

        PRINT'Accounts:'
        PRINT'Deleting Data From Table: bronze.accounts_stage'

        TRUNCATE TABLE bronze.accounts_stage;

        PRINT'Bulk Insert Into bronze.accounts_stage:'

        BULK INSERT bronze.accounts_stage
        FROM 'C:\Users\imran\OneDrive\Desktop\Projects\My projects\Not Completed Projects\Bank Loan Project\Datasets\accounts.csv'
        WITH(
                FIRSTROW=2,
                FIELDTERMINATOR=',',
                ROWTERMINATOR='0x0A',
                CODEPAGE='65001',
                TABLOCK
        );

        PRINT'Bulk Insert Completed'

        PRINT'Inserting Data Into bronze.accounts:'

        INSERT INTO bronze.accounts
        (
            account_id,
            customer_id,
            branch_id,
            account_type,
            open_date,
            close_date,
            current_balance,
            interest_rate,
            overdraft_limit,
            status
        )
        SELECT
            account_id,
            customer_id,
            branch_id,
            account_type,
            TRY_CONVERT(DATE, open_date, 105),
            TRY_CONVERT(DATE, close_date, 105),
            TRY_CONVERT(DECIMAL(12,2), current_balance),
            TRY_CONVERT(DECIMAL(12,2), interest_rate),
            TRY_CONVERT(DECIMAL(12,2), overdraft_limit),
            status
        FROM bronze.accounts_stage;

        TRUNCATE TABLE bronze.accounts_stage;

        SET @end_time=GETDATE();

        PRINT'Accounts Loaded Successfully'
        PRINT'LOAD DURATION:' + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR) + 'Sec'
        PRINT'================================================================================================================================'
        /*==============================================================
          4. CARDS
        ==============================================================*/

        SET @start_time=GETDATE();

        PRINT'Cards:'
        PRINT'Deleting Data From Table: bronze.cards_stage'

        TRUNCATE TABLE bronze.cards_stage;

        PRINT'Bulk Insert Into bronze.cards_stage:'

        BULK INSERT bronze.cards_stage
        FROM 'C:\Users\imran\OneDrive\Desktop\Projects\My projects\Not Completed Projects\Bank Loan Project\Datasets\cards.csv'
        WITH(
                FIRSTROW=2,
                FIELDTERMINATOR=',',
                ROWTERMINATOR='0x0A',
                CODEPAGE='65001',
                TABLOCK
        );

        PRINT'Bulk Insert Completed'

        PRINT'Inserting Data Into bronze.cards:'

        INSERT INTO bronze.cards
        (
            card_id,
            account_id,
            card_type,
            issue_date,
            expiry_date,
            credit_limit,
            outstanding_balance,
            reward_points,
            is_active,
            network
        )
        SELECT
            card_id,
            account_id,
            card_type,
            TRY_CONVERT(DATE, issue_date, 105),
            TRY_CONVERT(DATE, expiry_date, 105),
            TRY_CONVERT(DECIMAL(12,2), credit_limit),
            TRY_CONVERT(DECIMAL(12,2), outstanding_balance),
            TRY_CONVERT(INT, reward_points),
            is_active,
            network
        FROM bronze.cards_stage;

        TRUNCATE TABLE bronze.cards_stage;

        SET @end_time=GETDATE();

        PRINT'Cards Loaded Successfully'
        PRINT'LOAD DURATION:' + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR) + 'Sec'
        PRINT'================================================================================================================================'
        /*==============================================================
          5. TRANSACTIONS
        ==============================================================*/

        SET @start_time=GETDATE();

        PRINT'Transactions:'
        PRINT'Deleting Data From Table: bronze.transactions_stage'

        TRUNCATE TABLE bronze.transactions_stage;

        PRINT'Bulk Insert Into bronze.transactions_stage:'

        BULK INSERT bronze.transactions_stage
        FROM 'C:\Users\imran\OneDrive\Desktop\Projects\My projects\Not Completed Projects\Bank Loan Project\Datasets\transactions.csv'
        WITH(
                FIRSTROW=2,
                FIELDTERMINATOR=',',
                ROWTERMINATOR='0x0A',
                CODEPAGE='65001',
                TABLOCK
        );

        PRINT'Bulk Insert Completed'

        PRINT'Inserting Data Into bronze.transactions:'

        INSERT INTO bronze.transactions
        (
            transaction_id,
            account_id,
            transaction_date,
            transaction_time,
            transaction_type,
            amount,
            channel,
            description,
            balance_after,
            status
        )
        SELECT
            transaction_id,
            account_id,
            TRY_CONVERT(DATE, transaction_date, 105),
            TRY_CONVERT(TIME, transaction_time),
            transaction_type,
            TRY_CONVERT(DECIMAL(12,2), amount),
            channel,
            description,
            TRY_CONVERT(DECIMAL(12,2), balance_after),
            status
        FROM bronze.transactions_stage;

        TRUNCATE TABLE bronze.transactions_stage;

        SET @end_time=GETDATE();

        PRINT'Transactions Loaded Successfully'
        PRINT'LOAD DURATION:' + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR) + 'Sec'
        PRINT'================================================================================================================================'
        /*==============================================================
          6. LOANS
        ==============================================================*/

        SET @start_time=GETDATE();

        PRINT'Loans:'
        PRINT'Deleting Data From Table: bronze.loans_stage'

        TRUNCATE TABLE bronze.loans_stage;

        PRINT'Bulk Insert Into bronze.loans_stage:'

        BULK INSERT bronze.loans_stage
        FROM 'C:\Users\imran\OneDrive\Desktop\Projects\My projects\Not Completed Projects\Bank Loan Project\Datasets\loans.csv'
        WITH(
                FIRSTROW=2,
                FIELDTERMINATOR=',',
                ROWTERMINATOR='0x0A',
                CODEPAGE='65001',
                TABLOCK
        );

        PRINT'Bulk Insert Completed'

        PRINT'Inserting Data Into bronze.loans:'

        INSERT INTO bronze.loans
        (
            loan_id,
            customer_id,
            branch_id,
            loan_type,
            principal_amount,
            interest_rate,
            tenure_months,
            disbursement_date,
            maturity_date,
            emi_amount,
            outstanding_balance,
            loan_status,
            purpose
        )
        SELECT
            loan_id,
            customer_id,
            branch_id,
            loan_type,
            TRY_CONVERT(DECIMAL(12,2), principal_amount),
            TRY_CONVERT(DECIMAL(12,2), interest_rate),
            TRY_CONVERT(INT, tenure_months),
            TRY_CONVERT(DATE, disbursement_date, 105),
            TRY_CONVERT(DATE, maturity_date, 105),
            TRY_CONVERT(DECIMAL(12,2), emi_amount),
            TRY_CONVERT(DECIMAL(12,2), outstanding_balance),
            loan_status,
            purpose
        FROM bronze.loans_stage;

        TRUNCATE TABLE bronze.loans_stage;

        SET @end_time=GETDATE();

        PRINT'Loans Loaded Successfully'
        PRINT'LOAD DURATION:' + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR) + 'Sec'
        PRINT'================================================================================================================================'
        /*==============================================================
          7. LOAN PAYMENTS
        ==============================================================*/

        SET @start_time=GETDATE();

        PRINT'Loan Payments:'
        PRINT'Deleting Data From Table: bronze.loan_payments_stage'

        TRUNCATE TABLE bronze.loan_payments_stage;

        PRINT'Bulk Insert Into bronze.loan_payments_stage:'

        BULK INSERT bronze.loan_payments_stage
        FROM 'C:\Users\imran\OneDrive\Desktop\Projects\My projects\Not Completed Projects\Bank Loan Project\Datasets\loan_payments.csv'
        WITH(
                FIRSTROW=2,
                FIELDTERMINATOR=',',
                ROWTERMINATOR='0x0A',
                CODEPAGE='65001',
                TABLOCK
        );

        PRINT'Bulk Insert Completed'

        PRINT'Inserting Data Into bronze.loan_payments:'

        INSERT INTO bronze.loan_payments
        (
            payment_id,
            loan_id,
            payment_date,
            scheduled_amount,
            paid_amount,
            principal_paid,
            interest_paid,
            penalty,
            days_late,
            payment_method,
            status
        )
        SELECT
            payment_id,
            loan_id,
            TRY_CONVERT(DATE, payment_date, 105),
            TRY_CONVERT(DECIMAL(12,2), scheduled_amount),
            TRY_CONVERT(DECIMAL(12,2), paid_amount),
            TRY_CONVERT(DECIMAL(12,2), principal_paid),
            TRY_CONVERT(DECIMAL(12,2), interest_paid),
            TRY_CONVERT(DECIMAL(12,2), penalty),
            TRY_CONVERT(INT, days_late),
            payment_method,
            status
        FROM bronze.loan_payments_stage;

        TRUNCATE TABLE bronze.loan_payments_stage;

        SET @end_time=GETDATE();

        PRINT'Loan Payments Loaded Successfully'
        PRINT'LOAD DURATION:' + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR) + 'Sec'
        PRINT'================================================================================================================================'
        /*==============================================================
          TOTAL LOADING DURATION
        ==============================================================*/

        SET @batch_end_time=GETDATE();

        PRINT'TOTAL LOADING DURATION: ' + CAST(DATEDIFF(SECOND,@batch_start_time,@batch_end_time) AS NVARCHAR)

END;
GO
-- FOR Executing the Stored Procedure
-----------------------------------------
EXEC bronze.load_bronze;
-----------------------------------------