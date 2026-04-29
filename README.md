# Sql-DAProject
This project performs comprehensive SQL-based data cleaning and exploratory data analysis (EDA) on a global layoffs dataset (2020-2023). It uncovers trends in company downsizing, industry impacts, and regional patterns to inform HR and business strategy.
![Layoffs Data Analysis Banner](https://copilot.microsoft.com/th/id/BCO.a7939b23-86c0-4bb1-ba27-7f6f3e42576a.png)
# 📉 Global Layoffs Dataset – SQL EDA Project

## 🔎 Project Overview
This project explores a real dataset of company layoffs across industries, countries, and funding stages.  
The goal is to demonstrate **Exploratory Data Analysis (EDA)** using **SQL Workbench** — perfect for beginners running their first SQL queries on structured data.

---

## 📂 Dataset
Columns included:
- `company` – Company name  
- `location` – City of headquarters  
- `industry` – Sector of operation  
- `total_laid_off` – Number of employees laid off  
- `percentage_laid_off` – Workforce proportion affected  
- `date` – Layoff date  
- `stage` – Funding stage (Series A, Post‑IPO, etc.)  
- `country` – Country of operation  
- `funds_raised_millions` – Total funding raised  

---

## 🛠️ Getting Started
### Step 1: Create Table
```sql
CREATE TABLE layoffs (
    company VARCHAR(100),
    location VARCHAR(100),
    industry VARCHAR(50),
    total_laid_off INT,
    percentage_laid_off FLOAT,
    date DATE,
    stage VARCHAR(50),
    country VARCHAR(50),
    funds_raised_millions INT
);
```
## Next Steps:
   - View Data
      ```
      SELECT * FROM layoffs LIMIT 10;
      ```
   - Check Missing Value
     ``` SELECT
     SUM(CASE WHEN total_laid_off IS NULL THEN 1 ELSE 0 END) AS missing_total,
     SUM(CASE WHEN percentage_laid_off IS NULL THEN 1 ELSE 0 END) AS missing_percentage
     FROM layoffs;
     ```
  - Industry Distribution
    ```
     SELECT industry, COUNT(*) AS companies
    FROM layoffs
    GROUP BY industry
    ORDER BY companies DESC;
    ```

  - Top Layoffs - Company-wise
    ```
    SELECT company, total_laid_off
    FROM layoffs
    ORDER BY total_laid_off DESC
    LIMIT 10;
    ```
 
  - Country‑wise Impact
    ```
     SELECT country, SUM(total_laid_off) AS total_laid_offs
    FROM layoffs
    GROUP BY country
    ORDER BY total_laid_offs DESC;
    ```
  
## 🧠 Skills Demonstrated
- SQL Workbench basics (SELECT, GROUP BY, ORDER BY)
- Data cleaning (handling NULLs)
- Exploratory Data Analysis (EDA)
- Real‑world dataset analysis

<p align="center">
<img src="https://img.shields.io/badge/SQL-Queries-blue" />
<img src="https://img.shields.io/badge/Data-Cleaning-green" />
<img src="https://img.shields.io/badge/EDA-Analysis-yellow" />
<img src="https://img.shields.io/badge/Portfolio-Project-orange" />
</p>

## 📊 Timeline of Layoff Reasons (2020–2023)
- **2020** – Pandemic Shock: Sudden lockdowns, demand collapse → layoffs in travel, hospitality, retail.
- **2021** – Over‑Hiring During Digital Boom: Tech/e‑commerce scaled rapidly → later overstaffed.
- **2022** – Inflation & Funding Crunch: Rising rates + VC slowdown → startups trimmed staff.
- **2023** – Correction & Automation Restructuring: Big tech downsized, automation replaced repetitive roles.

For getiing to know reason behinf this layoff read file: [Reasons](https://github.com/aishwarya854/Global_layoff_datasetSql-DAProject/blob/layoffs/Layoffs%20Reason.pdf)
## 📈 Insights

- Industries most affected: Tech, Finance, Retail, Logistics.
- Countries with highest layoffs: United States, India, Brazil, Australia.
- Funding stage vs. layoffs: Post‑IPO firms cut aggressively to stabilize profits.
- Extreme cases: Embark Trucks (70% workforce), Ericsson (8,500 employees).

