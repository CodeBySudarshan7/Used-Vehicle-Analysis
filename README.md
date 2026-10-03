# 🚗 Used Vehicle Sales & Pricing Analytics

[![SQL](https://img.shields.io/badge/SQL-MySQL-4479A1?logo=mysql&logoColor=white)](#)
[![Python](https://img.shields.io/badge/Python-Pandas%20%7C%20NumPy-3776AB?logo=python&logoColor=white)](#)
[![Excel](https://img.shields.io/badge/Excel-Power%20Query-217346?logo=microsoftexcel&logoColor=white)](#)
[![Power BI](https://img.shields.io/badge/Power%20BI-DAX-F2C811?logo=powerbi&logoColor=black)](#)
[![License](https://img.shields.io/badge/License-MIT-lightgrey)](#)

An end-to-end analytics project that transforms **550K+ raw used-vehicle sales records** into a reliable analytical dataset and an interactive **Power BI** dashboard — covering sales performance, pricing behavior, market positioning, and geographic trends.

**Workflow:** `Excel / Power Query → SQL → Python (Pandas/NumPy) → Power BI (DAX)`

---

## 📋 Table of Contents

- [Overview](#-project-overview)
- [Business Problem](#-business-problem)
- [Objectives](#-project-objectives)
- [Tech Stack](#️-technology-stack)
- [Dataset](#-dataset)
- [Workflow](#-end-to-end-analytics-workflow)
- [Methodology](#-methodology)
- [Key Metric: Premium %](#-key-metric-premium-)
- [Dashboard](#-power-bi-dashboard)
- [Key Business Insights](#-key-business-insights)
- [Project Structure](#-project-structure)
- [How to Run](#️-how-to-run)
- [Skills Demonstrated](#-skills-demonstrated)
- [Future Improvements](#-future-improvements)
- [Author](#-author)

---

## 📊 Project Overview

**Used Vehicle Sales & Pricing Analytics** is an end-to-end data analytics project built to analyze **550K+ used-vehicle sales records** and generate actionable business insights related to sales performance, vehicle pricing, market positioning, vehicle characteristics, sellers, and geographic trends.

The project demonstrates a complete analytics workflow: the raw dataset was validated, cleaned, standardized, transformed, analyzed, and finally visualized through an interactive Power BI dashboard — mirroring how analytics is actually done in a business setting, rather than jumping straight from a CSV to a chart.

---

## 🎯 Business Problem

Used-vehicle sales datasets often contain inconsistent categorical values, missing information, duplicate records, invalid values, and unstructured date fields. Poor-quality data can lead to inaccurate business analysis and misleading dashboard results.

This project focuses on transforming a large raw vehicle-sales dataset into a reliable analytical dataset and answering key business questions such as:

- Which vehicle makes have the highest sales volume?
- Which states generate the most vehicle sales?
- Which body types are most popular?
- How does actual selling price compare with MMR (Manheim Market Report value)?
- Which vehicles sell above or below market value?
- How does vehicle age affect pricing?
- How does mileage relate to selling price?
- Which sellers contribute the highest sales?
- What is the relationship between MMR and selling price?

---

## 🚀 Project Objectives

### Data Quality
- Validate the raw dataset
- Identify missing values
- Detect duplicate records and duplicate VINs
- Standardize inconsistent categorical values
- Validate numerical fields
- Validate and clean sale dates
- Create data-quality indicators/flags

### Data Analysis
- Analyze sales by make, model, body type, and state
- Analyze vehicle pricing and pricing distribution
- Compare selling price with MMR
- Analyze vehicle age and mileage against price
- Analyze seller performance
- Analyze sales trends over time

### Business Intelligence
- Build an interactive Power BI dashboard
- Create DAX measures for business KPIs
- Develop dynamic slicers for exploration
- Analyze sales and pricing performance
- Generate actionable business insights

---

## 🛠️ Technology Stack

| Technology | Purpose |
|---|---|
| **Excel** | Initial data inspection and business-level analysis |
| **Power Query (M)** | Data cleaning and transformation |
| **SQL / MySQL** | Data querying, aggregation, and validation |
| **Python** | Data cleaning, analysis, and validation |
| **Pandas** | Data manipulation and transformation |
| **NumPy** | Numerical operations |
| **Jupyter Notebook** | Python analysis workflow |
| **Power BI** | Interactive dashboard and reporting |
| **DAX** | KPI and analytical measures |
| **Git & GitHub** | Version control and documentation |

---

## 📁 Dataset

The project uses a large used-vehicle sales dataset containing **550K+ records**.

### Original Columns

| Column | Description |
|---|---|
| `year` | Vehicle manufacturing year |
| `make` | Vehicle manufacturer |
| `model` | Vehicle model |
| `trim` | Vehicle trim/version |
| `body` | Vehicle body type |
| `transmission` | Transmission type |
| `vin` | Vehicle Identification Number |
| `state` | State where vehicle was sold |
| `condition` | Vehicle condition |
| `odometer` | Vehicle mileage |
| `color` | Exterior color |
| `interior` | Interior color |
| `seller` | Seller/dealer |
| `mmr` | Market reference value |
| `sellingprice` | Final selling price |
| `saledate` | Vehicle sale date |

> The raw dataset is preserved separately from the cleaned analytical dataset so that every transformation step is reproducible and auditable.

### Engineered Columns

| Column | Description |
|---|---|
| `Vehicle Age` | `saledate.year − year` — age of the vehicle at time of sale |
| `Mileage Band` | Bucketed odometer ranges (e.g., Low / Medium / High) for segment analysis |
| `Pricing Status` | Above MMR / At MMR / Below MMR classification |
| `Premium %` | Normalized percentage difference between selling price and MMR |
| `SaleDate_Clean` | Standardized, validated sale date used for time-based analysis |

---

## 🔄 End-to-End Analytics Workflow

```text
Raw Vehicle Sales Data
          │
          ▼
Data Quality Checking
          │
          ▼
Data Cleaning & Standardization
          │
          ▼
Feature Engineering
          │
          ├───────────────┐
          ▼               ▼
        SQL           Python/Pandas
      Analysis          Analysis
          │               │
          └───────┬───────┘
                  ▼
            Power BI Model
                  │
                  ▼
             DAX Measures
                  │
                  ▼
        Interactive Dashboard
                  │
                  ▼
          Business Insights
```

---

## 🔍 Methodology

### 1. Excel / Power Query — Initial Inspection
Used for a first pass at the raw data: quick pivot-table exploration, spotting obvious quality issues (blank cells, inconsistent text casing, outliers), and validating a sample of records before committing to a full cleaning pipeline in Python.

### 2. SQL — Querying, Aggregation & Validation
SQL was used as the analytical validation layer — every key number produced later in Python or Power BI was cross-checked here first.

```sql
-- Total vehicles
SELECT COUNT(*) FROM vehicle_clean;

-- Average selling price
SELECT AVG(sellingprice) FROM vehicle_clean;

-- Sales volume by make
SELECT make, COUNT(*) AS vehicle_count
FROM vehicle_clean
GROUP BY make
ORDER BY vehicle_count DESC;

-- Average selling price by make
SELECT make, AVG(sellingprice) AS avg_selling_price
FROM vehicle_clean
GROUP BY make
ORDER BY avg_selling_price DESC;

-- State-wise sales
SELECT state, COUNT(*) AS vehicle_count
FROM vehicle_clean
GROUP BY state
ORDER BY vehicle_count DESC;
```

### 3. Python (Pandas / NumPy) — Cleaning & Feature Engineering
Deeper, programmatic cleaning was handled in Python — missing-value analysis, duplicate and duplicate-VIN detection, text standardization, and type conversion.

```python
# Standardize categorical text fields
df["make"] = df["make"].astype("string").str.strip().str.upper()

# Feature engineering: vehicle age at time of sale
df["Vehicle Age"] = df["saledate"].dt.year - df["year"]
```

String operations removed inconsistent spacing/casing so that categorical values (e.g., different capitalizations of the same make) could be grouped and analyzed correctly.

### 4. Power BI — Dashboard & DAX
The cleaned, feature-engineered dataset was loaded into Power BI, where DAX measures power the KPI cards and drive the dynamic slicer-based filtering across every visual.

---

## 📐 Key Metric: Premium %

One of the core analyses in this project is comparing the **actual selling price** against **MMR** (the market reference value) to understand how vehicles perform relative to the broader market.

```
Premium % = (Selling Price − MMR) / MMR × 100
```

- `Selling Price > MMR` → **Above MMR** (sold at a premium)
- `Selling Price < MMR` → **Below MMR** (sold under market value)
- `Selling Price ≈ MMR` → **At MMR**

This gives a normalized measure of how much a vehicle's selling price differed from its expected market value — independent of the vehicle's absolute price — making it possible to compare pricing performance across very different vehicle segments.

---

## 📈 Power BI Dashboard

The dashboard is organized around four analytical lenses:

| Section | What it shows |
|---|---|
| **KPI Cards** | Total Vehicles, Total Sales, Average Selling Price, Average MMR, Above MMR %, Below MMR % |
| **Sales Analysis** | Sales volume by make, body type, state, and seller |
| **Pricing Analysis** | Selling price vs. MMR comparison, Premium % distribution, above/below-market breakdown |
| **Vehicle Analysis** | Vehicle age, mileage, and condition vs. pricing |
| **Geographic Analysis** | State-level map highlighting regions with the highest sales volume |

**Slicers** let a user filter by make, state, body type, transmission, and year — every KPI and visual updates dynamically based on the selection, so the dashboard supports open-ended exploration rather than a single fixed view.

> 📷 *Add dashboard screenshots/GIFs here once exported from Power BI (e.g., `/assets/dashboard-overview.png`).*

---

## 💡 Key Business Insights

- **MMR and selling price are strongly positively correlated** — confirmed via scatter plot and trend-line analysis, validating MMR as a reliable pricing benchmark.
- **Sales volume is concentrated** in a handful of top-performing states and vehicle makes, visible immediately through the geographic map and make-level breakdown.
- **Vehicle age and mileage show a clear inverse relationship with selling price**, consistent with expected depreciation patterns — but the *strength* of that relationship varies by body type and make.
- Popularity (sales volume) and pricing strength (average selling price) do **not** always move together — some high-volume makes sell at relatively modest prices, while lower-volume makes command a premium.

---

## 📁 Project Structure

> Update this section to match your actual repository layout.

```
used-vehicle-sales-analytics/
├── data/
│   ├── raw/                     # Original, unmodified dataset
│   └── processed/               # Cleaned, analysis-ready dataset
├── sql/
│   └── analysis_queries.sql     # Validation & aggregation queries
├── notebooks/
│   └── cleaning_and_eda.ipynb   # Pandas/NumPy cleaning + feature engineering
├── excel/
│   └── initial_inspection.xlsx  # Pivot tables, early data checks
├── powerbi/
│   └── vehicle_analytics.pbix   # Power BI dashboard file
├── assets/
│   └── dashboard-overview.png   # Dashboard screenshots
├── README.md
└── requirements.txt
```

---

## ▶️ How to Run

```bash
# 1. Clone the repository
git clone https://github.com/<your-username>/used-vehicle-sales-analytics.git
cd used-vehicle-sales-analytics

# 2. Install Python dependencies
pip install -r requirements.txt

# 3. Run the cleaning & EDA notebook
jupyter notebook notebooks/cleaning_and_eda.ipynb

# 4. (Optional) Load sql/analysis_queries.sql into MySQL to reproduce the SQL analysis

# 5. Open powerbi/vehicle_analytics.pbix in Power BI Desktop to explore the dashboard
```

---

## 🧠 Skills Demonstrated

`SQL` · `Python` · `Pandas` · `NumPy` · `Data Cleaning` · `Feature Engineering` · `Exploratory Data Analysis` · `Excel` · `Power Query` · `Power BI` · `DAX` · `Data Visualization` · `Business Analytics` · `Git/GitHub`

---

## 🔮 Future Improvements

- Automate the cleaning pipeline into a reusable script/module
- Add a predictive model to estimate selling price from vehicle attributes
- Deploy the dataset behind a lightweight API for live querying
- Add row-level data-quality scoring instead of binary flags
- Expand geographic analysis with city-level granularity (where available)

---

## 👤 Author

**Sudarshan Surendra Todkar**
B.Tech, Artificial Intelligence & Data Science — Government College of Engineering, Kolhapur

- GitHub: [Add your GitHub profile link]
- LinkedIn: [Add your LinkedIn link]
- Email: [Add your email]

---

*If you found this project useful or interesting, consider giving the repository a ⭐.*
#   U s e d - V e h i c l e - A n a l y s i s  
 