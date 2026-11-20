-- SECTION A

-- Q1
CREATE DATABASE BankingDB;

USE BankingDB;

-- Q2

CREATE TABLE Branches (
Branch_ID VARCHAR(50) PRIMARY KEY,
Branch_Name VARCHAR (50) NOT NULL,
Region VARCHAR(50),
City VARCHAR(50),
Manager_Name  VARCHAR(50));

-- Q3

CREATE TABLE Customers(
Customer_ID VARCHAR(50) PRIMARY KEY,
First_Name VARCHAR(50) NOT NULL, 
Last_Name VARCHAR(50) NOT NULL, 
Gender VARCHAR(50), 
Date_of_Birth DATE, 
Location VARCHAR(50), 
Occupation VARCHAR(50), 
Registration_Date DATE, 
Customer_Segment VARCHAR(50));

-- Q4

CREATE TABLE Accounts (
  Account_ID  VARCHAR(50) PRIMARY KEY NOT NULL,
  Customer_ID VARCHAR(50) ,
  Account_Type VARCHAR(50) ,
  Account_Balance DECIMAL(10,2) ,
  Account_Status VARCHAR(50) ,
  Date_Opened DATE ,
  Branch_ID VARCHAR(50),
  
  FOREIGN KEY (Customer_ID) references Customers(Customer_ID),
  FOREIGN KEY (Branch_ID) references Branches(Branch_ID));
  
  
-- Q5

CREATE TABLE Loans(
Loan_ID VARCHAR(50) PRIMARY KEY, 
Customer_ID VARCHAR(50), 
Loan_Type VARCHAR(50), 
Loan_Amount DECIMAL(10,2), 
Interest_Rate FLOAT, 
Loan_Term INT, 
Loan_Status TEXT, 
Loan_Date DATE,

FOREIGN KEY (Customer_ID) references Customers(Customer_ID));

-- Q6

CREATE TABLE Transactions (
Transaction_ID VARCHAR(50) PRIMARY KEY, 
Account_ID VARCHAR(50), 
Transaction_Date DATE, 
Transaction_Type VARCHAR(50), 
Transaction_Amount DECIMAL(10,2), 
Transaction_Channel VARCHAR(50), 
Transaction_Status VARCHAR(50), 
Merchant_Category VARCHAR(50),

FOREIGN KEY (Account_ID) references Accounts(Account_ID));
DESCRIBE Transactions;

-- SECTION B

-- Q8
SELECT Account_ID, Customer_ID, Account_Type, Account_Balance, Date_Opened
FROM Accounts
WHERE Account_Balance > 100000 AND Account_Status = 'Active' AND Account_Type = 'Savings'
ORDER BY Account_Balance DESC;

-- Q9

SELECT C.Customer_ID,C.First_Name,C.Last_Name, C.Registration_Date,C.Customer_Segment
FROM Customers C
WHERE C.Customer_Segment IN ('Premium', 'Corporate') AND C.Registration_Date BETWEEN '2020-01-01' AND '2022-12-31'
ORDER BY C.Registration_Date, Last_Name; 

-- Q10

SELECT C.Customer_ID, C.First_Name,C.Last_Name,C.Location, C.Customer_Segment
FROM Customers C
WHERE C.Location IN ('Kumasi', 'Dormaa','Yendi') AND C.First_Name LIKE 'K%'
ORDER BY Location , First_Name;

-- Q11

SELECT C.Customer_ID,C.First_Name,C.Last_Name,C.Customer_Segment,C.Registration_Date, C.Occupation
FROM Customers C
WHERE C.Occupation = ''
ORDER BY Customer_ID;

-- Q12
SELECT Transaction_ID,Account_ID,Transaction_Date,Transaction_Channel,Transaction_Status,Transaction_Amount
FROM Transactions
WHERE Transaction_Status IN ('Failed', 'Pending')AND Transaction_Channel IN ('ATM', 'USSD') AND Transaction_Amount > 20000
ORDER BY Transaction_Amount DESC
LIMIT 10;

-- Q13
SELECT Loan_ID,Customer_ID,Loan_Type,Loan_Amount,Interest_Rate,Loan_Term,Loan_Status,Loan_Date
FROM Loans
WHERE YEAR(Loan_Date) = 2025
  AND Loan_Term >= 60
  AND Interest_Rate BETWEEN 15 AND 25
  AND Loan_Status <> 'Paid'
ORDER BY Loan_Amount DESC;

-- Q14

SELECT Account_Type, COUNT(Account_ID) AS Total_Accounts, SUM(Account_Balance) AS Total_Balance, ROUND(AVG(Account_Balance),2) AS Average_Balance
FROM Accounts
WHERE Account_Status = 'Active'
GROUP BY Account_Type
ORDER BY Total_Balance DESC;

-- Q15
SELECT Loan_Type, COUNT(Loan_ID) Total_Loans, SUM(Loan_Amount)AS Total_Borrowed , ROUND(AVG(Interest_Rate),2) AS Average_Interest
FROM Loans
WHERE Loan_Status IN ('Active','Restructured')
GROUP BY Loan_Type ,Loan_Status
ORDER BY Total_Borrowed DESC;

-- Q16
SELECT Transaction_Status, Transaction_Channel, COUNT(Transaction_ID) AS Total_Transactions, SUM(Transaction_Amount) AS Total_Value, ROUND(AVG(Transaction_Amount),2)
FROM Transactions
WHERE Transaction_Status = 'Successful'
GROUP BY Transaction_Channel
ORDER BY Total_Value DESC;

-- Q17
SELECT Branch_ID, COUNT(Account_ID) AS Total_Accounts, SUM(Account_Balance) as Total_Balance
FROM Accounts
GROUP BY Branch_ID
HAVING Total_Accounts >= 4 and Total_Balance > 400000
ORDER BY Total_Balance DESC;

-- Q18
SELECT Customer_ID, SUM(Loan_Amount) AS Total_Borrowed, COUNT(Loan_ID) AS Total_Loan
FROM Loans
GROUP BY Customer_ID
HAVING Total_Loan >= 2 AND Total_Borrowed  > 500000
ORDER BY Total_Borrowed DESC;

-- Q19

SELECT Merchant_Category,COUNT(Transaction_ID) AS Total_Payments,SUM(Transaction_Amount) AS Total_Spend
FROM Transactions
WHERE Transaction_Type = 'Payment'AND Transaction_Status = 'Successful' AND Merchant_Category IS NOT NULL AND TRIM(Merchant_Category) <> ''
GROUP BY Merchant_Category
HAVING SUM(Transaction_Amount) > 250000
ORDER BY Total_Spend DESC;

-- Q20
SELECT A.Account_ID,CONCAT(C.First_Name, ' ', C.Last_Name) AS Customer_Name,A.Account_Type,A.Account_Balance,B.Branch_Name,B.Region
FROM Accounts A
JOIN Customers C
  ON A.Customer_ID = C.Customer_ID
JOIN Branches B
  ON A.Branch_ID = B.Branch_ID
WHERE A.Account_Status = 'Active'
  AND C.Customer_Segment = 'Premium'
ORDER BY A.Account_Balance DESC;

-- Q21

SELECT C.Customer_ID,CONCAT(C.First_Name,' ', C.Last_Name) AS Customer_Name,C.Customer_Segment,C.Registration_Date
FROM Customers C
LEFT JOIN Accounts A
  ON C.Customer_ID = A.Customer_ID
WHERE A.Customer_ID IS NULL
ORDER BY C.Registration_Date;

-- Q22

SELECT UPPER(B.Region) AS Region,COUNT(T.Transaction_ID) AS Total_Transactions,SUM(T.Transaction_Amount) AS Total_Value
FROM Transactions T
JOIN Accounts A
  ON T.Account_ID = A.Account_ID
JOIN Branches B
  ON A.Branch_ID = B.Branch_ID
WHERE T.Transaction_Type = 'Deposit' AND T.Transaction_Status = 'Successful'
GROUP BY Region
ORDER BY Total_Value DESC;


-- Q23
SELECT C.Customer_ID,CONCAT(C.First_Name,' ', C.Last_Name) AS Customer_Name,C.Customer_Segment,C.Location
FROM Customers C
LEFT JOIN Loans L
  ON C.Customer_ID = L.Customer_ID
WHERE C.Customer_Segment IN ('Premium', 'Corporate')
  AND L.Loan_ID IS NULL
ORDER BY C.Customer_Segment, C.Last_Name;

-- Q24

SELECT T.Transaction_ID, T.Transaction_Date, T.Transaction_Amount, T.Transaction_Channel, A.Account_Type, CONCAT(C.First_Name,' ', C.Last_Name) AS Customer_Name, B.City AS City
 FROM Transactions T
 JOIN Accounts A
 ON T.Account_ID= A.Account_ID
 JOIN Customers C
 ON A.Customer_ID = C.Customer_ID
 JOIN Branches B
 ON B.Branch_ID = A.Branch_ID
 WHERE Transaction_Status = 'Failed' AND Transaction_Amount>10000
GROUP BY T.Transaction_ID
 ORDER BY T. Transaction_Amount DESC;
 
 -- Q25
 SELECT Account_ID,Customer_ID,Account_Type,Account_Balance
FROM Accounts
WHERE Account_Status = 'Active'
  AND Account_Balance > (SELECT AVG(Account_Balance) FROM Accounts)
ORDER BY Account_Balance DESC;

-- 26
SELECT C.Customer_ID,C.First_Name,C.Last_Name,C.Location,C.Customer_Segment
FROM Customers C
WHERE C.Customer_ID IN (
    SELECT L.Customer_ID
    FROM Loans L
    WHERE L.Loan_Status = 'Defaulted'
)
ORDER BY C.Last_Name;

-- Q27

SELECT C.Customer_ID,C.First_Name,C.Last_Name,C.Customer_Segment
FROM Customers C
WHERE EXISTS (
SELECT 1 
FROM Loans L
WHERE L.Customer_ID = C.Customer_ID)
AND NOT EXISTS (
SELECT 1
FROM Accounts A
WHERE A.Customer_ID = C.Customer_ID)
ORDER BY C.Customer_ID;

-- Q28

SELECT T.Customer_ID,CONCAT( C.First_Name,' ', C.Last_Name) AS Customer_Name,T.Total_Loans
FROM (
    SELECT Customer_ID,SUM(Loan_Amount) AS Total_Loans
    FROM Loans
    GROUP BY Customer_ID
) AS T
JOIN Customers C
  ON T.Customer_ID = C.Customer_ID
WHERE T.Total_Loans > (
SELECT AVG(X.Total)
    FROM (
    SELECT SUM(Loan_Amount) AS Total
	FROM Loans
	GROUP BY Customer_ID
    ) AS X
)
ORDER BY T.Total_Loans DESC;

-- Q29
SELECT A.Account_Type,A.Account_ID,CONCAT(C.First_Name,' ', C.Last_Name) AS Customer_Name,A.Account_Balance
FROM Accounts A 
JOIN Customers C
  ON A.Customer_ID = C.Customer_ID
WHERE A.Account_Balance = (
    SELECT MAX(A2.Account_Balance)
    FROM Accounts A2
    WHERE A2.Account_Type = A.Account_Type
)
ORDER BY A.Account_Type;
