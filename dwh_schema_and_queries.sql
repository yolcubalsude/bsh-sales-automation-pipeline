-- DWH Star Schema DDL for BSH Sales Analytics

-- 1. Dim_Date
CREATE TABLE Dim_Date (
    DateKey INT PRIMARY KEY,
    FullDate DATE NOT NULL,
    Year INT NOT NULL,
    Quarter INT NOT NULL,
    Month INT NOT NULL,
    MonthName VARCHAR(20) NOT NULL
);

-- 2. Dim_Product
CREATE TABLE Dim_Product (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    Category VARCHAR(50) NOT NULL,
    UnitPrice DECIMAL(10, 2) NOT NULL
);

-- 3. Dim_Region
CREATE TABLE Dim_Region (
    RegionID INT PRIMARY KEY,
    RegionName VARCHAR(50) NOT NULL,
    Country VARCHAR(50) NOT NULL
);

-- 4. Fact_Sales
CREATE TABLE Fact_Sales (
    SalesID INT PRIMARY KEY,
    DateKey INT REFERENCES Dim_Date(DateKey),
    ProductID INT REFERENCES Dim_Product(ProductID),
    RegionID INT REFERENCES Dim_Region(RegionID),
    QuantitySold INT NOT NULL,
    Revenue DECIMAL(12, 2) NOT NULL,
    Profit DECIMAL(12, 2) NOT NULL,
    DiscountRate DECIMAL(4, 2) DEFAULT 0.00
);

-- KPI Analysis Query: Category Performance
SELECT 
    p.Category,
    SUM(f.Revenue) AS TotalRevenue,
    SUM(f.Profit) AS TotalProfit,
    ROUND((SUM(f.Profit) / NULLIF(SUM(f.Revenue), 0)) * 100, 2) AS ProfitMarginPct
FROM Fact_Sales f
JOIN Dim_Product p ON f.ProductID = p.ProductID
GROUP BY p.Category
ORDER BY TotalRevenue DESC;