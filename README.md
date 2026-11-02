# Bank Loan Performance & Customer Portfolio Analysis

An end-to-end SQL Server project where I took raw banking data, cleaned and organised it in layers, and answered **46 business questions** about customers, branches, transactions and loans.

---

## What is this project about?

Banks collect a lot of data: customers, accounts, cards, transactions and loans. On its own, that data doesn't say much.

In this project I built a small data warehouse for a bank called **BankDB** and used SQL to find out things like:

- Which loan type has the most late payments?
- Who are the top customers by transaction amount?
- Which branches hold the most money?
- How do customers with different credit scores behave with loans?

---

## Tools used

- **SQL Server** (T-SQL)
- **SSMS** (SQL Server Management Studio)
- **CSV files** as the raw data source

---

## How I built it (Bronze → Silver → Gold)

I followed the Medallion Architecture, which means the data moves through three layers.

| Layer | What it does | What's inside |
|---|---|---|
| **Bronze** | Stores the raw data as it comes | 7 tables with primary and foreign keys, plus 7 stage tables for loading the CSVs |
| **Silver** | Prepares the data for analysis | 7 views on top of the bronze tables |
| **Gold** | Business-ready data for reporting | Star schema: `dim_customers`, `fact_transactions`, `fact_loan_payments`, `branch_summary` |

### The data

| Table | What it holds |
|---|---|
| branches | Branch details, location and employee count |
| customers | Customer profile, income, credit score, KYC status |
| accounts | Account type, balance, status |
| cards | Card type, credit limit, outstanding balance |
| transactions | Every deposit, withdrawal, transfer and so on |
| loans | Loan type, amount, EMI, status |
| loan_payments | Each loan payment, late days and penalty |

---

## Folder structure

```
BankDB-Loan-Customer-Analytics/
│
├── README.md
│
├── data/
│   ├── branches.csv
│   ├── customers.csv
│   ├── accounts.csv
│   ├── cards.csv
│   ├── transactions.csv
│   ├── loans.csv
│   └── loan_payments.csv
│
└── sql/
    ├── 01_Initial_Database_Setup.sql
    ├── 02_Bronze_Tables_DDL.sql
    ├── 03_Bronze_Stage_DDL.sql
    ├── 04_Bronze_Stored_Procedure.sql
    ├── 05_Data_Quality_Checks.sql
    ├── 06_Silver_Views.sql
    ├── 07_Silver_Exploratory_Analysis.sql
    ├── 08_Gold_Views.sql
    └── 09_Gold_Business_Analytics.sql
```

---

## How to run it

Run the files in this order:

1. `01_Initial_Database_Setup.sql` creates the database and the bronze, silver and gold schemas.
2. `02_Bronze_Tables_DDL.sql` creates the bronze tables.
3. `03_Bronze_Stage_DDL.sql` creates the stage tables.
4. `04_Bronze_Stored_Procedure.sql` loads the CSV data into the tables.
5. `05_Data_Quality_Checks.sql` checks row counts, duplicates and nulls.
6. `06_Silver_Views.sql` creates the silver views.
7. `07_Silver_Exploratory_Analysis.sql` runs the exploratory insights.
8. `08_Gold_Views.sql` creates the gold star schema views.
9. `09_Gold_Business_Analytics.sql` runs the business insights.

---

## Data quality checks

Before analysing anything, I checked every table for:

- Row counts
- Duplicate records
- Null values
- Column data types

---

## The 46 insights

### Measures (12)
Total branches, total employees, total customers, total accounts, average balance, total cards, average credit limit, total transactions, total amount transferred, total loans, average loan interest rate and average EMI amount.

### Magnitude (14)
- Unique and repeated branch names
- State with the most branches
- City with the most employees
- Gender wise customer count
- City with the most customers
- Account types and their counts
- Active vs closed accounts
- Card types and networks
- Most common transaction types
- Transaction status counts
- Customers per loan type
- Average EMI per loan type
- Payment methods and their status

### Ranking (10)
- Top 5 branches
- First and last opened branch
- Top 5 customers by annual income
- Oldest and youngest customer
- Top 5 accounts by balance
- Top 2 customers by credit limit
- Highest transaction per customer
- Customer with the most loans
- Branches with the most loans
- Customers with the highest total loan amount

### Gold business insights (10)
1. **Late payment and penalty analysis:** payments grouped by how late they were (on time, 1-30, 31-60, 60+ days).
2. **Top 5 customers** by total transaction amount.
3. **Month wise deposit amount** (deposits, refunds, interest).
4. **Month wise debit amount** (debits, withdrawals, transfers, fees).
5. **Loans by credit score:** which credit band (Excellent, Good, Fair, Poor) holds loans in which status.
6. **Channel analysis:** transactions and amount by channel and status.
7. **Top branches** by balance and number of accounts.
8. **Month over month comparison** of transaction amount using `LAG()`.
9. **Running total** of monthly transactions.
10. **Loan type risk:** late payment percentage and collection shortfall for each loan type.

---

## Overall insights (what the data says)

These are the main things I learned after running all the analysis on the dataset.

### Customers and accounts
- The bank has **500 customers** and **700 accounts**, handled across **40 branches** with **1,230 employees**. California has the most branches (7).
- Customer segments are fairly balanced. Student (100) and Business (97) are the biggest groups.
- Only **143 customers (about 29%) are KYC Verified**, while 105 have Failed KYC. That is a compliance risk worth watching.
- **497 accounts are active and 203 (about 29%) are closed.** The average account balance is about **14,569**.
- IRA is the most common account type (136), followed closely by Certificate of Deposit and Savings.

### Branches
- The top branches by total balance are **Atlanta (about 501.9K)**, **San Diego (about 438.1K)** and **Washington (about 391.6K)**.

### Cards
- There are **600 cards**: 358 debit and 242 credit. Visa, Mastercard, American Express and Discover are almost evenly split.
- The average credit limit is about **9,799** across all cards.

### Transactions
- **5,000 transactions** moved about **35.9 million** in total, spread almost evenly across the six transaction types.
- **Online** is the most used channel (1,470), then Branch and Mobile.
- Only about **34% of transactions are Completed**. The rest are almost equally split between Pending and Failed, which points to a big gap in processing success.

### Loans
- There are **300 loans**. Education is the most common type (64) and also has the highest average EMI (about 7,355).
- The average interest rate is about **11.05%** and the average EMI is about **6,314**.
- About **57% of loans are either Defaulted (86) or In Arrears (83)**. Only 65 are Active and 66 are Closed.

### Loan payments
- Out of **2,000 payments**: 573 Paid on time, 500 Late, 468 Missed and 459 Pending.
- About **25% of payments are late**, and late fees total about **94K**.
- **Home loans have the highest late payment rate (about 28%)** and Credit Builder loans the lowest (about 22%).
- Credit score has only a small effect: Poor-score customers pay late about 27% of the time, Excellent-score customers about 23%.

### In one line
This bank has healthy account activity, but its biggest risks are **loan repayment** (more than half the loans are defaulted or in arrears), **KYC completion** and **transaction failures**.

---

## SQL concepts I practiced

- Creating databases, schemas, tables, and primary and foreign keys
- Staging tables and data loading
- Views (silver and gold layers)
- Star schema design (fact and dimension views)
- Joins, `GROUP BY`, `HAVING`
- `CASE WHEN` for bucketing data
- CTEs and subqueries
- Window functions: `ROW_NUMBER`, `RANK`, `DENSE_RANK`, `LAG`, running totals

---

## About me

Hi, I'm **[Shaik Imran]**, learning data analytics and SQL.
Feel free to connect with me on [https://www.linkedin.com/in/shaik-imran-a09218299]) or send feedback.

If you liked this project, please give it a star.
