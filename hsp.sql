
CREATE DATABASE EcommerceDBs;
GO

USE EcommerceDBs;
GO

-- 1. CUSTOMER TABLE
CREATE TABLE Customers
(
    Customer_ID INT PRIMARY KEY,
    Customer_Name VARCHAR(100) NOT NULL,
    Gender CHAR(1),
    City VARCHAR(50),
    Registration_Date DATE
);

-- 2. PRODUCT TABLE
CREATE TABLE Products
(
    Product_ID INT PRIMARY KEY,
    Product_Name VARCHAR(100) NOT NULL,
    Category VARCHAR(50),
    Price DECIMAL(10,2),
    Stock INT
);

-- 3. ORDERS TABLE
CREATE TABLE Orders
(
    Order_ID INT PRIMARY KEY,
    Customer_ID INT,
    Order_Date DATE,
    Order_Status VARCHAR(30),

    FOREIGN KEY (Customer_ID)
    REFERENCES Customers(Customer_ID)
);

-- 4. ORDER DETAILS TABLE
CREATE TABLE Order_Details
(
    Detail_ID INT PRIMARY KEY,
    Order_ID INT,
    Product_ID INT,
    Quantity INT,
    Unit_Price DECIMAL(10,2),

    FOREIGN KEY (Order_ID)
    REFERENCES Orders(Order_ID),

    FOREIGN KEY (Product_ID)
    REFERENCES Products(Product_ID)
);

-- 5. PAYMENTS TABLE
CREATE TABLE Payments
(
    Payment_ID INT PRIMARY KEY,
    Order_ID INT,
    Payment_Method VARCHAR(30),
    Payment_Status VARCHAR(30),
    Amount DECIMAL(10,2),

    FOREIGN KEY (Order_ID)
    REFERENCES Orders(Order_ID)
);


-- ============================================
-- INSERT CUSTOMERS
-- ============================================

INSERT INTO Customers VALUES
(1,'Ali Khan','M','Karachi','2026-01-05'),
(2,'Sara Ahmed','F','Lahore','2026-01-10'),
(3,'Usman Shah','M','Islamabad','2026-02-01'),
(4,'Ayesha Malik','F','Karachi','2026-02-15'),
(5,'Bilal Hassan','M','Multan','2026-03-01'),
(6,'Hina Ahmed','F','Lahore','2026-03-10'),
(7,'Hamza Ali','M','Karachi','2026-04-05'),
(8,'Zara Khan','F','Islamabad','2026-04-12');


-- ============================================
-- INSERT PRODUCTS
-- ============================================

INSERT INTO Products VALUES
(101,'Laptop','Electronics',150000,20),
(102,'Smartphone','Electronics',85000,35),
(103,'Headphones','Accessories',5000,100),
(104,'Keyboard','Accessories',3500,60),
(105,'Office Chair','Furniture',25000,15),
(106,'Monitor','Electronics',45000,25),
(107,'Mouse','Accessories',2000,80),
(108,'Desk','Furniture',18000,12);


-- ============================================
-- INSERT ORDERS
-- ============================================

INSERT INTO Orders VALUES
(1001,1,'2026-04-01','Delivered'),
(1002,2,'2026-04-03','Delivered'),
(1003,3,'2026-04-05','Pending'),
(1004,4,'2026-04-07','Cancelled'),
(1005,5,'2026-04-10','Delivered'),
(1006,6,'2026-04-12','Processing'),
(1007,7,'2026-04-15','Delivered'),
(1008,8,'2026-04-18','Pending'),
(1009,1,'2026-05-01','Delivered'),
(1010,3,'2026-05-05','Delivered');


-- ============================================
-- INSERT ORDER DETAILS
-- ============================================

INSERT INTO Order_Details VALUES
(1,1001,101,1,150000),
(2,1001,103,2,5000),
(3,1002,102,1,85000),
(4,1002,107,2,2000),
(5,1003,106,1,45000),
(6,1004,105,1,25000),
(7,1005,104,2,3500),
(8,1005,103,1,5000),
(9,1006,108,1,18000),
(10,1007,101,1,150000),
(11,1007,107,1,2000),
(12,1008,105,2,25000),
(13,1009,102,2,85000),
(14,1009,103,1,5000),
(15,1010,106,2,45000);


-- ============================================
-- INSERT PAYMENTS
-- ============================================

INSERT INTO Payments VALUES
(501,1001,'Card','Paid',160000),
(502,1002,'Cash','Paid',89000),
(503,1003,'Card','Unpaid',45000),
(504,1004,'Cash','Refunded',25000),
(505,1005,'Online','Paid',12000),
(506,1006,'Card','Pending',18000),
(507,1007,'Online','Paid',152000),
(508,1008,'Cash','Unpaid',50000),
(509,1009,'Card','Paid',175000),
(510,1010,'Online','Paid',90000);


-- ============================================
-- 1. DISPLAY ALL TABLES
-- ============================================

SELECT * FROM Customers;
SELECT * FROM Products;
SELECT * FROM Orders;
SELECT * FROM Order_Details;
SELECT * FROM Payments;


-- ============================================
-- 2. CUSTOMER OVERVIEW
-- ============================================

SELECT
COUNT(*) AS Total_Customers,
SUM(CASE WHEN Gender='M' THEN 1 ELSE 0 END) AS Male_Customers,
SUM(CASE WHEN Gender='F' THEN 1 ELSE 0 END) AS Female_Customers
FROM Customers;


-- ============================================
-- 3. PRODUCT OVERVIEW
-- ============================================

SELECT
COUNT(*) AS Total_Products,
SUM(Stock) AS Total_Stock,
AVG(Price) AS Average_Price,
MAX(Price) AS Highest_Price,
MIN(Price) AS Lowest_Price
FROM Products;


-- ============================================
-- 4. ORDER OVERVIEW
-- ============================================

SELECT
COUNT(*) AS Total_Orders,
SUM(CASE WHEN Order_Status='Delivered' THEN 1 ELSE 0 END) AS Delivered_Orders,
SUM(CASE WHEN Order_Status='Pending' THEN 1 ELSE 0 END) AS Pending_Orders,
SUM(CASE WHEN Order_Status='Cancelled' THEN 1 ELSE 0 END) AS Cancelled_Orders,
SUM(CASE WHEN Order_Status='Processing' THEN 1 ELSE 0 END) AS Processing_Orders
FROM Orders;


-- ============================================
-- 5. SALES OVERVIEW
-- ============================================

SELECT
SUM(OD.Quantity * OD.Unit_Price) AS Total_Sales,
AVG(OD.Quantity * OD.Unit_Price) AS Average_Order_Value,
MAX(OD.Quantity * OD.Unit_Price) AS Highest_Sale,
MIN(OD.Quantity * OD.Unit_Price) AS Lowest_Sale
FROM Order_Details OD
INNER JOIN Orders O
ON OD.Order_ID=O.Order_ID
WHERE O.Order_Status='Delivered';


-- ============================================
-- 6. CATEGORY-WISE SALES
-- ============================================

SELECT
P.Category,
SUM(OD.Quantity) AS Total_Quantity,
SUM(OD.Quantity * OD.Unit_Price) AS Total_Sales
FROM Products P
INNER JOIN Order_Details OD
ON P.Product_ID=OD.Product_ID
INNER JOIN Orders O
ON OD.Order_ID=O.Order_ID
WHERE O.Order_Status='Delivered'
GROUP BY P.Category;


-- ============================================
-- 7. TOP SELLING PRODUCTS
-- ============================================

SELECT TOP 5
P.Product_Name,
SUM(OD.Quantity) AS Total_Quantity_Sold,
SUM(OD.Quantity * OD.Unit_Price) AS Total_Revenue
FROM Products P
INNER JOIN Order_Details OD
ON P.Product_ID=OD.Product_ID
INNER JOIN Orders O
ON OD.Order_ID=O.Order_ID
WHERE O.Order_Status='Delivered'
GROUP BY P.Product_Name
ORDER BY Total_Quantity_Sold DESC;


-- ============================================
-- 8. CITY-WISE CUSTOMER ANALYSIS
-- ============================================

SELECT
City,
COUNT(Customer_ID) AS Total_Customers
FROM Customers
GROUP BY City
ORDER BY Total_Customers DESC;


-- ============================================
-- 9. PAYMENT METHOD ANALYSIS
-- ============================================

SELECT
Payment_Method,
COUNT(Payment_ID) AS Total_Transactions,
SUM(Amount) AS Total_Amount
FROM Payments
WHERE Payment_Status='Paid'
GROUP BY Payment_Method;


-- ============================================
-- 10. PAYMENT STATUS ANALYSIS
-- ============================================

SELECT
Payment_Status,
COUNT(Payment_ID) AS Total_Payments,
SUM(Amount) AS Total_Amount
FROM Payments
GROUP BY Payment_Status;


-- ============================================
-- 11. MONTHLY SALES ANALYSIS
-- ============================================

SELECT
YEAR(O.Order_Date) AS Sales_Year,
MONTH(O.Order_Date) AS Sales_Month,
SUM(OD.Quantity * OD.Unit_Price) AS Monthly_Sales
FROM Orders O
INNER JOIN Order_Details OD
ON O.Order_ID=OD.Order_ID
WHERE O.Order_Status='Delivered'
GROUP BY YEAR(O.Order_Date),MONTH(O.Order_Date)
ORDER BY Sales_Year,Sales_Month;


-- ============================================
-- 12. CUSTOMER-WISE SALES
-- ============================================

SELECT
C.Customer_Name,
COUNT(DISTINCT O.Order_ID) AS Total_Orders,
SUM(OD.Quantity * OD.Unit_Price) AS Total_Spending
FROM Customers C
INNER JOIN Orders O
ON C.Customer_ID=O.Customer_ID
INNER JOIN Order_Details OD
ON O.Order_ID=OD.Order_ID
WHERE O.Order_Status='Delivered'
GROUP BY C.Customer_Name
ORDER BY Total_Spending DESC;


-- ============================================
-- 13. LOW STOCK PRODUCTS
-- ============================================

SELECT
Product_ID,
Product_Name,
Category,
Stock
FROM Products
WHERE Stock < 20;


-- ============================================
-- 14. DOUGHNUT CHART DATA - ORDER STATUS
-- ============================================

SELECT
Order_Status,
COUNT(*) AS Total_Orders
FROM Orders
GROUP BY Order_Status;


-- ============================================
-- 15. TOP CUSTOMERS
-- ============================================

SELECT TOP 5
C.Customer_Name,
C.City,
SUM(OD.Quantity * OD.Unit_Price) AS Total_Spending
FROM Customers C
INNER JOIN Orders O
ON C.Customer_ID=O.Customer_ID
INNER JOIN Order_Details OD
ON O.Order_ID=OD.Order_ID
WHERE O.Order_Status='Delivered'
GROUP BY C.Customer_Name,C.City
ORDER BY Total_Spending DESC;


-- ============================================
-- 16. COMPLETE E-COMMERCE REPORT
-- ============================================

SELECT
O.Order_ID,
C.Customer_Name,
C.City,
O.Order_Date,
P.Product_Name,
P.Category,
OD.Quantity,
OD.Unit_Price,
(OD.Quantity * OD.Unit_Price) AS Total_Price,
O.Order_Status,
PY.Payment_Method,
PY.Payment_Status
FROM Orders O
INNER JOIN Customers C
ON O.Customer_ID=C.Customer_ID
INNER JOIN Order_Details OD
ON O.Order_ID=OD.Order_ID
INNER JOIN Products P
ON OD.Product_ID=P.Product_ID
LEFT JOIN Payments PY
ON O.Order_ID=PY.Order_ID;
