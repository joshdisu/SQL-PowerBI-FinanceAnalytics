CREATE DATABASE BankProject

CREATE SCHEMA Banks

--Import Dataset

SELECT * 
FROM [Banks].[Customer Table];

SELECT *
FROM [Banks].[Transactions Table]

--Sum Transaction type
SELECT transaction_type, SUM(transaction_amount) AS Value
FROM [Banks].[Transactions Table]
GROUP BY transaction_type

SELECT MIN(transaction_date) AS MIN_DATE, MAX(transaction_date) AS MAX_DATE
FROM [Banks].[Transactions Table]

--Total Transactions by month and year 
SELECT FORMAT(transaction_date, 'MMMM-yyyy') AS Date, SUM(transaction_amount) AS Value
FROM [Banks].[Transactions Table]
--WHERE transaction_date BETWEEN '01-JAN-2022' AND '31-DEC-2022'
GROUP BY FORMAT(transaction_date, 'MMMM-yyyy')
ORDER BY 2 DESC;

--Daily report
--Count of customer transaction on 2023-08-29
SELECT COUNT(customer_id) AS Customer_Count, transaction_date
FROM [Banks].[Transactions Table]
WHERE transaction_date = '29-AUG-2023'
GROUP BY transaction_date;

--Debit transactions
--Transactions that happened on 2023-08-29
SELECT transaction_type, SUM(transaction_amount) AS Value
FROM [Banks].[Transactions Table]
WHERE transaction_date = '29-AUG-2023'
GROUP BY transaction_type;

--Net Profit 
--Subquery and CTE 
SELECT 
SUM(CASE WHEN transaction_type = 'Credit' THEN transaction_amount ELSE 0 END) AS TotalCredits,
SUM(CASE WHEN transaction_type = 'Debit' THEN transaction_amount ELSE 0 END) AS TotalDebits
FROM [Banks].[Transactions Table]
WHERE transaction_date = '29-AUG-2023'
) SELECT (TotalCredits - TotalDebits AS NetProfit
FROM TransactionSummary;

--Top 3 Customers in a month
SELECT DISTINCT TOP 3 A.customer_id, B.customer_name,
SUM(CASE WHEN A.transaction_type = 'Credit' THEN A.transaction_amount ELSE 0 END) Credit_Amt,
SUM(CASE WHEN A.transaction_type = 'Debit' THEN A.transaction_amount ELSE 0 END) Debit_Amt,
SUM(CASE WHEN A.transaction_type = 'Credit' THEN A.transaction_amount ELSE 0 END - CASE WHEN A.transaction_type = 'Debit' THEN A.transaction_amount ELSE 0 END) Net_Value
FROM [Banks].[Transactions Table]A
JOIN [Banks].[Customer Table] B 
ON A.customer_id = B.customer_id
WHERE A.transaction_date >= '2023-08-01' AND A.transaction_date <='2023-08-30'
GROUP BY A.customer_id, B.customer_name
--ORDER BY Net_Value DESC;

