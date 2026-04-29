# 🗄️ SQL Data Engineering Layer  
### Supply Chain Analysis – DEPI Project  

---

## 📌 Project Overview  

This layer represents the **data engineering backbone** of the Supply Chain project.  
It transforms raw data into a structured **Star Schema database** ready for analytics.

---

## 🎯 Objective  

- Clean raw supply chain data  
- Build relational data model (Star Schema)  
- Create Fact & Dimension tables  
- Prepare data for Power BI & Python  

---

## 🧱 Data Model (Star Schema)

### ⭐ Fact Table:
- Fact_Sales

### 📁 Dimension Tables:
- Dim_Products  
- Dim_Customers  
- Dim_Location  

---

## ⚙️ ETL Process  

### 1️⃣ Data Cleaning  
- Remove duplicates  
- Handle missing values  
- Standardize formats  

### 2️⃣ Data Transformation  
- Normalize raw dataset  
- Split into Fact & Dimensions  
- Define relationships (PK / FK)  

### 3️⃣ Data Loading  
- Load structured tables into SQL Server  

---

## 🖼️ Project Screenshots  

### 🧱 Database Structure
<p align="center">
  <img src="../image/p1.gif" width="85%" />
</p>

---

### 📊 Data Modeling Process
<p align="center">
  <img src="../image/p2.gif" width="85%" />
</p>

---

### ⚡ SQL Execution & Queries
<p align="center">
  <img src="../image/p3.gif" width="85%" />
</p>

---

## 📂 SQL Files  

- `ddl/create_tables.sql` → Create schema tables  
- `dml/insert_data.sql` → Insert cleaned data  
- `star_schema/fact_sales.sql` → Fact table logic  
- `star_schema/dim_tables.sql` → Dimension tables  

---

## 📁 Data Files  

Cleaned datasets used in the project:

<p align="center">
  <img src="../image/Screenshot 2026-04-29 124541.png" width="85%" />
</p>

---

## 🧹 Cleanup Summary  

Removed:
- `.vs/` (IDE files)  
- `.ssmssln` (Visual Studio solution)  
- Temporary system files  

---

## 🛠️ Tools Used  

- SQL Server  
- SSMS  
- CSV Files  

---

## 📊 Output Impact  

This layer enables:

- Fast analytics queries  
- Reliable Power BI dashboards  
- Structured business reporting  
- Scalable data architecture  

---

## 🔥 Key Achievements  

✔ Built full Star Schema  
✔ Transformed raw data into structured model  
✔ Optimized database for analytics  
✔ Enabled BI integration  

---

## 💡 Business Value  

- Improved data accuracy  
- Faster reporting  
- Better decision-making  
- Scalable analytics foundation  

---

## 🚀 Final Note  

This SQL layer is the **foundation of the entire analytics system**, connecting raw data to business intelligence dashboards.

---
