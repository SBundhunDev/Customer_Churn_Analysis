
-- =======================================================
-- SQL Server Migration Script (Compatible with SSMS 22)
-- Target Database: CustomerChurnDB
-- Generated from SQLite Binary Resource
-- =======================================================

USE master;
GO

-- 1. Create the database if it does not exist
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'OTTCustomerChurnDB')
BEGIN
    CREATE DATABASE OTTCustomerChurnDB;
END
GO

USE OTTCustomerChurnDB;
GO

-- 2. Drop existing tables if they exist to allow clean re-runs
IF OBJECT_ID('dbo.db_support', 'U') IS NOT NULL DROP TABLE dbo.db_support;
IF OBJECT_ID('dbo.db_subscription', 'U') IS NOT NULL DROP TABLE dbo.db_subscription;
IF OBJECT_ID('dbo.db_customer', 'U') IS NOT NULL DROP TABLE dbo.db_customer;
GO

-- 3. Create Tables with optimized SQL Server Data Types
CREATE TABLE dbo.db_customer (
    customerid VARCHAR(50) NOT NULL PRIMARY KEY,
    name VARCHAR(255),
    country VARCHAR(100),
    state VARCHAR(100),
    gender VARCHAR(50),
    dob DATETIME,
    interests VARCHAR(MAX),
    pincode NUMERIC(18, 2)
);

CREATE TABLE dbo.db_subscription (
    customerid VARCHAR(50) NOT NULL CONSTRAINT FK_Subscription_Customer REFERENCES dbo.db_customer(customerid),
    subscription_start_date DATE,
    subscription_type VARCHAR(100),
    renewal_date DATE,
    plan_type VARCHAR(100),
    contract_type VARCHAR(100),
    cancellation_date DATE,
    cancellation_reason VARCHAR(255),
    monthly_charges DECIMAL(10, 2),
    cltv INT,
    churn_score INT
);

CREATE TABLE dbo.db_support (
    customerid VARCHAR(50) NOT NULL CONSTRAINT FK_Support_Customer REFERENCES dbo.db_customer(customerid),
    complaint_date DATETIME,
    escalations VARCHAR(50),
    csat_score INT,
    col_1 REAL,
    comment VARCHAR(MAX)
);
GO

-- 4. Populate Core Customer Schema (db_customer)
INSERT INTO dbo.db_customer (customerid, name, country, state, gender, dob, interests, pincode) VALUES
('0002-ORFBO', 'chris', 'USA', 'New York', 'Male', '1982-04-12 00:00:00', 'travel', NULL),
('0003-MKNFE', 'paul', 'USA', 'Kentucky', 'Male', '1995-11-23 00:00:00', NULL, NULL),
('0004-TLHLJ', 'jenny', 'USA', 'Washington', 'Female', '1978-02-15 00:00:00', 'movie', NULL),
('0011-IGKFF', 'mike', 'USA', 'Nevada', 'Male', '2001-08-30 00:00:00', NULL, NULL),
('0013-EXCHZ', 'alex', 'USA', 'Washington', 'Female', '1990-05-05 00:00:00', 'drama', NULL),
('0013-MHZWF', 'christina', '', 'Washington', 'Women', '1988-12-10 00:00:00', NULL, NULL),
('0013-SMEOE', 'galabrielle', 'USA', 'Maine', 'Female', '1976-09-21 00:00:00', NULL, NULL),
('0014-BMAQU', 'maddy', 'USA', 'Nevada', 'Male', '1999-03-14 00:00:00', NULL, NULL),
('0015-UOCOJ', 'maya', NULL, 'Ontario', 'Women', '1985-07-07 00:00:00', NULL, NULL),
('0016-QLJIS', 'arjun', 'Canada', 'Ontario', 'Male', '1993-10-29 00:00:00', NULL, NULL),
('0017-DINOC', 'shiva', 'USA', 'New York', 'Men', '1997-01-22 00:00:00', NULL, NULL),
('0017-IUDMW', 'mary', 'USA', 'Kentucky', 'Female', '1981-06-18 00:00:00', NULL, NULL),
('0018-NYROU', 'charlot', '','Texas', 'Female', '2004-12-01 00:00:00', NULL, NULL),
('0019-EFAEP', 'ricky', 'USA', 'Montana', 'Female', '1992-04-25 00:00:00', NULL, NULL),
('0019-GFNTW', 'adam', 'USA', 'Utah', 'Men', '1979-11-11 00:00:00', 'job', NULL),
('0020-INWCK', 'peal', 'USA', 'Washington', 'Female', '1986-02-28 00:00:00', NULL, NULL),
('0020-JDNXP', 'riya', 'USA', 'Montana', 'Female', '1994-08-19 00:00:00', NULL, NULL),
('0021-IKXGC', 'vasto', 'USA', 'Texas', 'Female', '2000-09-02 00:00:00', NULL, NULL),
('0022-TCJCI', 'rocky', 'USA', 'Maine', 'Male', '1983-12-30 00:00:00', NULL, NULL),
('0023-HGHWL', 'steve', 'USA', 'Utah', 'Men', '1991-05-14 00:00:00', NULL, NULL),
('0023-UYUPN', 'pristina', 'USA', 'New York', 'Women', '1977-10-06 00:00:00', NULL, NULL);

-- 5. Populate Subscriptions Schema (db_subscription)
INSERT INTO dbo.db_subscription (customerid, subscription_start_date, subscription_type, renewal_date, plan_type, contract_type, cancellation_date, cancellation_reason, monthly_charges, cltv, churn_score) VALUES
('0023-UYUPN', '2022-12-31', 'Paid', '2025-12-31', 'Standard', 'Monthly', NULL, NULL, 13.99, 790, 47),
('0023-HGHWL', '2020-06-23', 'Organic', '2025-06-23', 'Premium', 'Annual', NULL, NULL, 22.99, 1955, 7),
('0022-TCJCI', '2023-09-14', 'Refferal', '2024-09-14', 'Basic', 'Monthly', '2024-09-14', 'Forgot to cancel trial', 16.99, 42, 99),
('0021-IKXGC', '2021-07-07', 'Paid', '2025-07-07', 'Standard', 'Annual', NULL, NULL, 13.99, 840, 27),
('0020-JDNXP', '2022-01-19', 'Organic', '2024-01-19', 'Premium', 'Annual', NULL, NULL, 20.99, 550, 62),
('0020-INWCK', '2023-05-06', 'Organic', '2025-05-06', 'Standard', 'Monthly', NULL, NULL, 13.99, 840, 27),
('0019-GFNTW', '2019-11-11', 'Paid', '2025-11-11', 'Premium', 'Annual', NULL, NULL, 92.99, 2185, 3),
('0019-EFAEP', '2022-08-25', 'Refferal', '2024-08-25', 'Basic', 'Monthly', '2024-10-31', 'Switched to competitor', 12.99, 160, 76),
('0018-NYROU', '2020-10-09', 'Organic', '2025-10-09', 'Standard', 'Annual', NULL, NULL, 13.99, 980, 19),
('0017-IUDMW', '2023-03-17', 'Refferal', '2024-03-17', 'Standard', 'Monthly', '2024-05-01', 'Poor streaming quality', 7.99, 270, 83),
('0017-DINOC', '2021-12-01', 'Organic', '2025-12-01', 'Premium', 'Annual', NULL, NULL, 22.99, 1610, 14),
('0016-QLJIS', '2022-04-03', 'Organic', '2025-04-03', 'Basic', 'Annual', NULL, NULL, 6.99, 335, 41),
('0015-UOCOJ', '2023-07-22', 'Organic', '2024-07-22', 'Standard', 'Monthly', NULL, NULL, 13.99, 240, 34),
('0014-BMAQU', '2020-02-14', 'Organic', '2025-02-14', 'Premium', 'Annual', NULL, NULL, 22.99, 1840, 5),
('0013-SMEOE', '2021-09-30', 'Refferal', '2024-09-30', 'Basic', 'Monthly', '2024-11-15', 'Not enough content', 8.99, 230, 79),
('0013-MHZWF', '2022-06-18', 'Paid', '2025-06-18', 'Standard', 'Annual', NULL, NULL, 17.99, 720, 22),
('0013-EXCHZ', '2023-01-05', 'Refferal', '2024-01-05', 'Standard', 'Monthly', '2024-02-28', 'Too expensive', 13.99, 195, 88),
('0011-IGKFF', '2019-05-10', 'Paid', '2025-05-10', 'Premium', 'Annual', NULL, NULL, 22.99, 1725, 8),
('0004-TLHLJ', '2022-11-20', 'Organic', '2025-11-20', 'Basic', 'Monthly', NULL, NULL, 6.99, 210, 34),
('0003-MKNFE', '2020-08-01', 'Paid', '2024-08-01', 'Premium', 'Annual', '2024-09-10', 'Switched to competitor', 12.99, 1150, 91),
('0002-ORFBO', '2021-03-15', 'Refferal', '2025-03-15', 'Standard', 'Annual', NULL, NULL, 13.99, 627, 12);

-- 6. Populate Behavioral Interaction Log (db_support)
INSERT INTO dbo.db_support (customerid, complaint_date, escalations, csat_score, col_1, comment) VALUES
('0022-TCJCI', '2024-09-14 00:00:00', 'N', 90, NULL, 'received refund'),
('0022-TCJCI', '2024-09-13 00:00:00', 'Y', 10, NULL, NULL),
('0019-EFAEP', '2024-09-27 00:00:00', 'Y', 30, NULL, NULL),
('0017-IUDMW', '2024-04-10 00:00:00', 'Y', 25, NULL, NULL),
('0013-SMEOE', '2024-11-01 00:00:00', 'N', 30, NULL, NULL),
('0013-MHZWF', '2025-03-18 00:00:00', 'N', 90, NULL, 'guidance to renew'),
('0013-EXCHZ', '2024-01-20 00:00:00', 'Y', 20, NULL, NULL),
('0003-MKNFE', '2024-08-28 00:00:00', 'Y', 10, NULL, 'demaned refund'),
('0003-MKNFE', '2024-08-28 00:00:00', 'N', 60, NULL, 'service issue');
GO

-- 7. Verification check to ensure import success
SELECT 'db_customer' AS TableName, COUNT(*) AS TotalRows FROM dbo.db_customer
UNION ALL
SELECT 'db_subscription', COUNT(*) FROM dbo.db_subscription
UNION ALL
SELECT 'db_support', COUNT(*) FROM dbo.db_support;
GO
