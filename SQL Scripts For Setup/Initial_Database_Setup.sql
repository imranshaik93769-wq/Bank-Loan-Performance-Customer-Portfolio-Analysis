/* Bank Loan Performance & Customer Portfolio Analysis */
--Create Database
---------------------------------------------------------------------
Create Database BankDB;
go
---------------------------------------------------------------------
--Connect Database
---------------------------------------------------------------------
Use BankDB;
go
---------------------------------------------------------------------
--Create Schemas
---------------------------------------------------------------------
Create Schema bronze;
go
Create Schema silver;
go
Create Schema gold;
go
---------------------------------------------------------------------
--To see the Schemas in Database
---------------------------------------------------------------------
SELECT name
FROM sys.schemas;
--to check the schemas
SELECT name
FROM sys.tables
WHERE schema_id = SCHEMA_ID('bronze');
go
SELECT name
FROM sys.tables
WHERE schema_id = SCHEMA_ID('silver');
go
SELECT name
FROM sys.tables
WHERE schema_id = SCHEMA_ID('gold');
go
---------------------------------------------------------------------