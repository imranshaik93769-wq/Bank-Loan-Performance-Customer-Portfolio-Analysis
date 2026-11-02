use bankdb;

--To explore the structure of tables
--
-----------------------------------------------------------
--Measures Exploration:
-----------------------------------------------------------
--Toatal Branches
Select count(branch_id) as TotalBranches
from silver.branches;
--How many Employees are threre in all branches
select sum(employee_count) as Totalemployees
from silver.branches;
--Total customers
select count(customer_id) as TotalCustomers
from silver.customers;
--Total number of Accounts
select count(account_id) as TotalAccounts
from silver.accounts;
--Finding avg Current Balance in all accounts
select round(avg(current_balance),2) as AverageBal
from silver.accounts;
--Total number of crads
select count(card_id) as Totalcards
from silver.cards;
--Average Credit limit
select round(avg(credit_limit),2) as AvgCriditLimt
from silver.cards;
--Total number of transactions
select	count(transaction_id) as Totaltransactions
from silver.transactions;
--Total amount transfered
Select sum(amount) as TotalTransferedAmount
from silver.transactions;
--Total number of Loans from all branches
select count(loan_id) as totalloans
from silver.loans;
--Average Inresest rate for loans from all branches
select avg(interest_rate) as AvgInterest
from silver.loans;
--Average EMI amount per Month for loan clearence
select round(Avg(emi_amount),2) as AvgEMIAmount
from silver.loans;

--Report that shows all key metrics
Select 'Total Branches' as Name, count(branch_id) as Detaills
from silver.branches
union all
select 'TOtal Employees',sum(employee_count) as Totalemployees
from silver.branches
union all
select 'Total Customers', count(customer_id) as TotalCustomers
from silver.customers
union all
select 'Total Accounts', count(account_id) as TotalAccounts
from silver.accounts
union all
select 'Average Balance', round(avg(current_balance),2) as AverageBal
from silver.accounts
union all
select 'Total Cards', count(card_id) as Totalcards
from silver.cards
union all
select 'Average Credit Limit ', round(avg(credit_limit),2) as AvgCriditLimt
from silver.cards
union all
select 'Total Transactions', count(transaction_id) as Totaltransactions
from silver.transactions
union all
Select 'Total Transfered Amount', sum(amount) as TotalTransferedAmount
from silver.transactions
union all
select 'Total Loans', count(loan_id) as totalloans
from silver.loans
union all
select 'Average Interest', avg(interest_rate) as AvgInterest
from silver.loans
union all
select 'Average EMI Amount', round(Avg(emi_amount),2) as AvgEMIAmount
from silver.loans;

-----------------------------------------------------------
--Magnitude Analysis:
-----------------------------------------------------------
--list the unique branch name and count repeated branch names
select distinct branch_name
from silver.branches;
---------------------
select branch_name,
	count(*) as count
from silver.branches
group by branch_name
having count(*)>1;
select * from silver.branches;
--which state has highest brannches
select top 1 state,
	count(branch_id) as CountOfBranches
from silver.branches
group by state
order by count(branch_id) DESC;
--Which City has Highesst employees
select top 1 city,
	sum(employee_count) as TotalEmployees
from silver.branches
group by city
order by sum(employee_count) DESC;
--Gender wise Customer Count
select gender,
		COUNT(Customer_id) as TotalCount
from silver.customers
group by gender
order by COUNT(Customer_id) DESC;
--From Which city Highest Customers are come
select top 1 city,
		count(customer_id) as TotalCustomers
from silver.customers
group by city
order by count(customer_id) DESC;
--How many Account_types are there And Count of it
select account_type,
		count(*) as count
from silver.accounts
group by account_type
order by count(*) DESC;
--find the Total Number of Active and Closed accounts
select status,
	count(*) as TotalCount
from silver.accounts
group by status
order by Count(*) DESC;
-- What type of cards and networks are there
select card_type,
	network,
	Count(*) as TotalCount
from silver.cards
Group by card_type,network
Order by Count(*) DESC;
--Most transaction types
select transaction_type,
	count(*) as count
from silver.transactions
group by transaction_type
Order By count(*) DESC;
-- Transation Satus and their Count
select status,
	count(*) as count
from silver.transactions
group by status
Order by count(*) DESC;
-- How many customers are their for each loan type
select loan_type,
		count(customer_id) as CustomerCount
from silver.loans
group by loan_type
order by count(customer_id) DESC;
--Average EMI amount for Loan_types
select loan_type,
		round(avg(emi_amount),2) as AvgEMI
from silver.loans
group by loan_type
order by round(avg(emi_amount),2) DESC;
-- What are payment methods and their status count
select payment_method,
	status,
	count(*) as count
from silver.loan_payments
group by payment_method,status
order by count(*) DESC;
-----------------------------------------------------------
--Ranking Analysis:
-----------------------------------------------------------
--Top 5 branches by Count
select state,
		branch_name
from(
		select state,
			branch_name,
			count(*) as count,
			row_number() over(order by count(*) DESC) as rank
		from silver.branches
		group by state,branch_name
	) as t
where rank<=5
--find first and last opening braches
SELECT 'First Opened Branch' AS BranchType,
branch_name,
opening_date
FROM silver.branches
WHERE opening_date = (SELECT MIN(opening_date) FROM silver.branches)
 UNION ALL
SELECT 'Last Opened Branch',
branch_name,
opening_date
FROM silver.branches
WHERE opening_date = (SELECT MAX(opening_date) FROM silver.branches);
--find the top 5 Highest annual income Customers 
select customer_id,
	CustomerName,
	annual_income
from(
		select customer_id,
			CONCAT(first_name,' ',last_name) as customerName,
			annual_income,
			ROW_NUMBER() over(Order By annual_income DESC) as rank
		from silver.customers
	) as t
where rank<=5;
-- who is Old and Young Customer
select customer_id,
		CONCAT(first_name,' ',last_name) as customerName,
		date_of_birth
from silver.customers
where date_of_birth = (select min(date_of_birth) from silver.customers)
or	  date_of_birth=(select max(date_of_birth) from silver.customers)
order by date_of_birth DESC;
--find the top 5 Currecnt Balance Account customers
select *
from( select c.customer_id,
		CONCAT(c.first_name,' ',c.last_name) as customerName,
		a.account_id,
		a.current_balance,
		Row_number() over(Order By a.current_balance DESC) as rank
	from silver.customers as c
	join silver.accounts as a
		on c.customer_id=a.customer_id
	) as t
where rank<=5;
--find out the top 2 Customers having Highest credit limit
select *
from(select c.customer_id,
			CONCAT(c.first_name,' ',c.last_name) as customerName,
			cr.card_type,
			cr.credit_limit,
			ROW_NUMBER() over(order by cr.credit_limit DESC) as rank
	from silver.customers as c
	join silver.accounts as a
		on c.customer_id=a.customer_id
	join silver.cards as cr
	on a.account_id=cr.account_id
	) as t
where rank<=2;
-- Find Top Transerefed amount for each customer
select *
from(select c.customer_id,
			CONCAT(c.first_name,' ',c.last_name) as customerName,
			a.account_id,
			t.amount,
			ROW_NUMBER() over(partition by c.customer_id order by t.amount DESC) as rank
	from silver.customers as c
	join silver.accounts as a
		on c.customer_id=a.customer_id
	join silver.transactions as t
		on a.account_id=t.account_id
	) as t
where rank=1
--which person taken the highest loans
WITH LoanCount AS
(
    SELECT
        c.customer_id,
        CONCAT(c.first_name,' ',c.last_name) AS CustomerName,
        COUNT(l.loan_id) OVER(PARTITION BY c.customer_id) AS NumberOfLoans
    FROM silver.customers c
    JOIN silver.loans l
        ON c.customer_id = l.customer_id
),
RankData AS
(
    SELECT *,
           RANK() OVER(ORDER BY NumberOfLoans DESC) AS rnk
    FROM LoanCount
)
SELECT DISTINCT
       customer_id,
       CustomerName,
       NumberOfLoans
FROM RankData
WHERE rnk = 1;
--Which branches have issued the highest number of loans
WITH BranchLoans AS
(
    SELECT
        branch_id,
        COUNT(loan_id) AS TotalLoans
    FROM silver.loans
    GROUP BY branch_id
)
SELECT *,
       DENSE_RANK() OVER(ORDER BY TotalLoans DESC) AS Rank
FROM BranchLoans;
--Which customers have borrowed the highest total loan amount
WITH LoanData AS
(
    SELECT
        c.customer_id,
        CONCAT(c.first_name,' ',c.last_name) AS CustomerName,
        SUM(l.principal_amount) AS TotalLoanAmount
    FROM silver.customers c
    JOIN silver.loans l
        ON c.customer_id = l.customer_id
    GROUP BY c.customer_id,
             c.first_name,
             c.last_name
)
SELECT *,
       RANK() OVER(ORDER BY TotalLoanAmount DESC) AS Rank
FROM LoanData;

----