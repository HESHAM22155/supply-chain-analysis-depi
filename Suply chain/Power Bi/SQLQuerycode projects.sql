/* =========================================
   1. CREATE DIMENSIONS TABLES
   ========================================= */

-- Date Dimension
CREATE TABLE Dim_Date (
    Date_SK INT PRIMARY KEY,
    Full_Date DATE,
    Day INT,
    Month INT,
    Month_Name VARCHAR(20),
    Quarter INT,
    Year INT,
    Week INT
);

-- Customer Dimension
CREATE TABLE Dim_Customer (
    Customer_SK INT PRIMARY KEY,
    Customer_ID INT,
    Customer_City VARCHAR(100),
    Customer_State VARCHAR(100),
    Customer_Country VARCHAR(100),
    Customer_Zipcode VARCHAR(20),
    Customer_Segment VARCHAR(50)
);

-- Product Dimension
CREATE TABLE Dim_Product (
    Product_SK INT PRIMARY KEY,
    Product_ID INT,
    Product_Name VARCHAR(255),
    Product_Price DECIMAL(10,2),
    Product_Status INT,
    Category_Name VARCHAR(100),
    Department_Name VARCHAR(100)
);

-- Location Dimension
CREATE TABLE Dim_Location (
    Location_SK INT PRIMARY KEY,
    City VARCHAR(100),
    State VARCHAR(100),
    Region VARCHAR(100),
    Market VARCHAR(100),
    Latitude DECIMAL(10,6),
    Longitude DECIMAL(10,6)
);

-- Category Dimension
CREATE TABLE Dim_Category (
    Category_SK INT PRIMARY KEY,
    Category_Name VARCHAR(100),
    Department_SK INT
);




/* =========================================
   2. CREATE FACT TABLE
   ========================================= */

CREATE TABLE Fact_Sales (
    Order_Item_SK INT PRIMARY KEY,
    Order_ID INT,

    Customer_SK INT,
    Product_SK INT,
    Location_SK INT,
    Order_Date_SK INT,
    Ship_Date_SK INT,

    Payment_Type VARCHAR(50),
    Order_Status VARCHAR(50),

    Order_Item_Quantity INT,
    Sales DECIMAL(15,2),
    Order_Item_Discount DECIMAL(15,2),
    Order_Item_Discount_Rate DECIMAL(10,4),
    Order_Item_Total DECIMAL(15,2),
    Order_Item_Profit_Ratio DECIMAL(10,4),
    Order_Profit_Per_Order DECIMAL(15,2),
    Days_Shipping_Real INT,
    Days_Shipment_Scheduled INT,

    FOREIGN KEY (Customer_SK) REFERENCES Dim_Customer(Customer_SK),
    FOREIGN KEY (Product_SK) REFERENCES Dim_Product(Product_SK),
    FOREIGN KEY (Location_SK) REFERENCES Dim_Location(Location_SK),
    FOREIGN KEY (Order_Date_SK) REFERENCES Dim_Date(Date_SK),
    FOREIGN KEY (Ship_Date_SK) REFERENCES Dim_Date(Date_SK)
);




/* =========================================
   3. LOAD DIMENSIONS DATA
   ========================================= */

-- Load Customer
INSERT INTO Dim_Customer (
    Customer_SK,
    Customer_ID,
    Customer_City,
    Customer_State,
    Customer_Country,
    Customer_Zipcode,
    Customer_Segment
)
SELECT 
    Customer_SK,
    Customer_SK AS Customer_ID,
    Customer_City,
    Customer_State,
    Customer_Country,
    Customer_Zipcode,
    Customer_Segment
FROM [Supply_Chain Star Schema].[dbo].[Dim_Customer0];



-- Load Date Dimension
INSERT INTO Dim_Date (
    Date_SK,
    Full_Date,
    Day,
    Month,
    Month_Name,
    Quarter,
    Year,
    Week
)
SELECT 
    Date_SK,
    [Date] AS Full_Date,
    DAY([Date]),
    MONTH([Date]),
    DATENAME(MONTH, [Date]),
    DATEPART(QUARTER, [Date]),
    YEAR([Date]),
    DATEPART(WEEK, [Date])
FROM [Supply_Chain Star Schema].[dbo].[Dim_Date0];



-- Load Location
INSERT INTO Dim_Location (
    Location_SK,
    City,
    State,
    Region,
    Market,
    Latitude,
    Longitude
)
SELECT 
    Location_SK,
    Order_City,
    Order_State,
    Order_Region,
    Market,
    Latitude,
    Longitude
FROM [Supply_Chain Star Schema].[dbo].[Dim_Location0];



-- Load Product
INSERT INTO Dim_Product (
    Product_SK,
    Product_Name,
    Product_Price,
    Product_Status
)
SELECT 
    Product_SK,
    Product_Name,
    Product_Price,
    Product_Status
FROM [Supply_Chain Star Schema].[dbo].[Dim_Product0];



-- Load Category
INSERT INTO Dim_Category (
    Category_SK,
    Category_Name,
    Department_SK
)
SELECT 
    Category_SK,
    Category_Name,
    Department_SK
FROM [Supply_Chain Star Schema].[dbo].[Dim_Category0];




/* =========================================
   4. LOAD FACT TABLE
   ========================================= */

INSERT INTO Fact_Sales (
    Order_Item_SK,
    Order_ID,
    Customer_SK,
    Product_SK,
    Location_SK,
    Order_Date_SK,
    Ship_Date_SK,
    Payment_Type,
    Order_Status,
    Order_Item_Quantity,
    Sales,
    Order_Item_Discount,
    Order_Item_Discount_Rate,
    Order_Item_Total,
    Order_Item_Profit_Ratio,
    Order_Profit_Per_Order,
    Days_Shipping_Real,
    Days_Shipment_Scheduled
)
SELECT 
    Order_Item_SK,
    Order_ID,
    Customer_SK,
    Product_SK,
    Location_SK,
    Order_Date_SK,
    Ship_Date_SK,
    Payment_Type,
    Order_Status,
    Order_Item_Quantity,
    Sales,
    Order_Item_Discount,
    Order_Item_Discount_Rate,
    Order_Item_Total,
    Order_Item_Profit_Ratio,
    Order_Profit_Per_Order,
    Days_Shipping_Real,
    Days_Shipment_Scheduled
FROM Fact_Sales0;




/* =========================================
   5. DATA VALIDATION
   ========================================= */

-- Row count check
SELECT 'Fact_Sales' AS TableName, COUNT(*) AS RowsCount FROM Fact_Sales
UNION ALL
SELECT 'Dim_Customer', COUNT(*) FROM Dim_Customer
UNION ALL
SELECT 'Dim_Product', COUNT(*) FROM Dim_Product
UNION ALL
SELECT 'Dim_Location', COUNT(*) FROM Dim_Location
UNION ALL
SELECT 'Dim_Date', COUNT(*) FROM Dim_Date
UNION ALL
SELECT 'Dim_Category', COUNT(*) FROM Dim_Category;



-- NULL check in Fact
SELECT 
    SUM(CASE WHEN Customer_SK IS NULL THEN 1 ELSE 0 END) AS Null_Customers,
    SUM(CASE WHEN Product_SK IS NULL THEN 1 ELSE 0 END) AS Null_Products,
    SUM(CASE WHEN Location_SK IS NULL THEN 1 ELSE 0 END) AS Null_Location,
    SUM(CASE WHEN Order_Date_SK IS NULL THEN 1 ELSE 0 END) AS Null_OrderDate
FROM Fact_Sales;



-- Business totals check
SELECT 
    SUM(Sales) AS Total_Sales,
    SUM(Order_Item_Quantity) AS Total_Qty,
    SUM(Order_Profit_Per_Order) AS Total_Profit
FROM Fact_Sales;



-- Referential integrity check
SELECT 'Customer' AS CheckType, COUNT(*) AS Missing
FROM Fact_Sales f
LEFT JOIN Dim_Customer d ON f.Customer_SK = d.Customer_SK
WHERE d.Customer_SK IS NULL

UNION ALL

SELECT 'Product', COUNT(*)
FROM Fact_Sales f
LEFT JOIN Dim_Product d ON f.Product_SK = d.Product_SK
WHERE d.Product_SK IS NULL

UNION ALL

SELECT 'Location', COUNT(*)
FROM Fact_Sales f
LEFT JOIN Dim_Location d ON f.Location_SK = d.Location_SK
WHERE d.Location_SK IS NULL;





