Use BankDB;
go

/*=============================================================================
 Business Analysis:
=============================================================================*/
--Loan Late payment and Panalty Analysis
SELECT 
    CASE 
        WHEN days_late = 0 THEN 'On Time'
        WHEN days_late BETWEEN 1 AND 30 THEN '1-30 Days Late'
        WHEN days_late BETWEEN 31 AND 60 THEN '31-60 Days Late'
        ELSE '60+ Days Late'
    END AS delay_category,
    COUNT(payment_id) AS TotalPayments,
    SUM(paid_amount) AS TotalPaidAmount,
    SUM(penalty) AS TotalPenaltyAmount
FROM gold.fact_loan_payments
GROUP BY 
    CASE 
        WHEN days_late = 0 THEN 'On Time'
        WHEN days_late BETWEEN 1 AND 30 THEN '1-30 Days Late'
        WHEN days_late BETWEEN 31 AND 60 THEN '31-60 Days Late'
        ELSE '60+ Days Late'
    END
ORDER BY TotalPenaltyAmount DESC;

-- top 5 customers with the highest total transaction
SELECT TOP 5
    c.customer_id,
    c.customer_name,
    c.segment,
    COUNT(t.transaction_id) AS total_transactions,
    ROUND(SUM(t.amount), 2) AS total_transacted_amount
FROM gold.dim_customers c
JOIN gold.fact_transactions t 
    ON c.customer_id = t.customer_id
GROUP BY c.customer_id, c.customer_name, c.segment
ORDER BY total_transacted_amount DESC;

-- Month wise Deposit Amount in Bnaks
select * from gold.fact_transactions;

SELECT
    YEAR(transaction_date) AS trans_year,
    DATENAME(MONTH,transaction_date) AS trans_month,
    SUM(amount) AS total_deposit
FROM gold.fact_transactions
WHERE transaction_type in ('Deposit', 'Refund', 'Interest')
GROUP BY
    YEAR(transaction_date),
     DATENAME(MONTH,transaction_date)
ORDER BY trans_year,trans_month;

--Month wise Credit Amount in Banks
SELECT
    YEAR(transaction_date) as year,
    DATENAME(MONTH,transaction_date) as Month,
    SUM(amount) as Total_Credit_Amount
FROM gold.fact_transactions
WHERE transaction_type in ('Debit', 'Withdrawal', 'Transfer', 'Fee')
GROUP BY YEAR(transaction_date),
        DATENAME(MONTH,transaction_date)
ORDER BY year,Month;

-- Who are Taken more Loans By The Credit Score
SELECT 
    CASE 
        WHEN c.credit_score >= 750 THEN 'Excellent'
        WHEN c.credit_score BETWEEN 650 AND 749 THEN 'Good'
        WHEN c.credit_score BETWEEN 550 AND 649 THEN 'Fair'
        ELSE 'Poor'
    END AS credit_like,
    p.loan_status,
    COUNT(DISTINCT p.loan_id) AS total_loans
FROM gold.dim_customers c
JOIN gold.fact_loan_payments p 
    ON c.customer_id = p.customer_id
GROUP BY 
    CASE 
        WHEN c.credit_score >= 750 THEN 'Excellent'
        WHEN c.credit_score BETWEEN 650 AND 749 THEN 'Good'
        WHEN c.credit_score BETWEEN 550 AND 649 THEN 'Fair'
        ELSE 'Poor'
    END,
    p.loan_status
ORDER BY credit_like;

-- How many transactions were performed through each channel and status,and Total Amount
SELECT channel,
    status,
    COUNT(transaction_id) AS trans_count,
    SUM(amount) AS Amount
FROM gold.fact_transactions
GROUP BY channel, status
ORDER BY channel, trans_count DESC;

--Top Branches by Balance and Accounts
select * from gold.branch_summary;
SELECT branch_name,
    city,
    state,
    region,
    total_accounts,
    total_branch_balance
FROM gold.branch_summary
ORDER BY total_branch_balance DESC;

--Find the total transaction amount for each month along with the previous months
SELECT 
    trans_year,
    trans_month,
    total_amount,
    LAG(total_amount) OVER (ORDER BY trans_year, trans_month) as prev_month_amount
FROM (
    SELECT 
        YEAR(transaction_date) as trans_year,
        MONTH(transaction_date) as trans_month,
        ROUND(SUM(amount), 2) as total_amount
    FROM gold.fact_transactions
    GROUP BY YEAR(transaction_date), MONTH(transaction_date)
)  as t;

-- Find the monthly total transaction amount and running total
SELECT trans_year,
    trans_month,
    monthly_amount,
    SUM(monthly_amount) OVER (ORDER BY trans_year, trans_month) AS running_total
FROM (
    SELECT 
        YEAR(transaction_date) AS trans_year,
        MONTH(transaction_date) AS trans_month,
        ROUND(SUM(amount), 2) AS monthly_amount
    FROM gold.fact_transactions
    GROUP BY YEAR(transaction_date), MONTH(transaction_date)
) t;

--Loan Type wise Late payment and Collection Shortfall Analysis
SELECT 
    loan_type,
    COUNT(payment_id) AS TotalPayments,
    SUM(CASE WHEN days_late > 0 THEN 1 ELSE 0 END) AS LatePayments,
    ROUND(SUM(CASE WHEN days_late > 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(payment_id), 2) AS LatePaymentPercent,
    SUM(penalty) AS TotalPenaltyAmount,
    SUM(scheduled_amount) AS TotalScheduledAmount,
    SUM(paid_amount) AS TotalPaidAmount,
    SUM(scheduled_amount - paid_amount) AS CollectionShortfall
FROM gold.fact_loan_payments
GROUP BY loan_type
ORDER BY LatePaymentPercent DESC;