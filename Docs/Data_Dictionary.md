# 📖 Data Dictionary

Full reference for every column in the **Used Vehicle Sales & Pricing Analytics** dataset — both the original raw fields and the columns engineered during cleaning.

---

## 1. Original Columns (Raw Data)

| Column | Data Type | Description | Example Value | Notes |
|---|---|---|---|---|
| `year` | Integer | Vehicle manufacturing year | `2014` | Used to compute `Vehicle Age` |
| `make` | Text | Vehicle manufacturer | `Toyota` | Standardized to uppercase during cleaning |
| `model` | Text | Vehicle model | `Camry` | Kept as-is; free-text field |
| `trim` | Text | Vehicle trim/version | `SE` | Can be blank for some records |
| `body` | Text | Vehicle body type | `Sedan` | Standardized casing during cleaning |
| `transmission` | Text | Transmission type | `Automatic` | Categorical — used for slicer filtering |
| `vin` | Text | Vehicle Identification Number | `1HGCM82633A004352` | Checked for duplicates; near-unique per vehicle |
| `state` | Text | U.S. state where vehicle was sold | `CA` | Used for geographic analysis |
| `condition` | Numeric / Text | Vehicle condition rating | `4.5` | Scale varies by source; validated during cleaning |
| `odometer` | Integer | Vehicle mileage at time of sale | `45210` | Validated for out-of-range / negative values |
| `color` | Text | Exterior color | `White` | Standardized casing during cleaning |
| `interior` | Text | Interior color | `Black` | Standardized casing during cleaning |
| `seller` | Text | Seller / dealer name | `ABC Motors` | Used for seller performance analysis |
| `mmr` | Decimal | Market reference value (Manheim Market Report) | `15250.00` | Benchmark used for pricing analysis |
| `sellingprice` | Decimal | Final actual selling price | `15800.00` | Primary revenue/price field |
| `saledate` | Date/Text | Date of vehicle sale | `Tue Dec 16 2014 12:30:00 GMT-0800` | Originally unstructured; parsed into `SaleDate_Clean` |

---

## 2. Engineered Columns (Processed Data)

| Column | Data Type | Formula / Logic | Description |
|---|---|---|---|
| `Vehicle Age` | Integer | `saledate.year − year` | Age of the vehicle (in years) at the time of sale |
| `Mileage Band` | Text (Category) | Odometer bucketed into ranges (e.g., `Low`, `Medium`, `High`) | Groups vehicles into mileage segments for comparison |
| `Pricing Status` | Text (Category) | `sellingprice > mmr` → Above MMR; `< mmr` → Below MMR; else At MMR | Classifies each sale relative to market reference value |
| `Premium %` | Decimal | `(sellingprice − mmr) / mmr × 100` | Normalized measure of pricing performance vs. MMR |
| `SaleDate_Clean` | Date | Parsed/standardized from raw `saledate` | Reliable date field used for all time-based analysis |

---

## 3. Field Notes & Caveats

- **`vin`**: Not guaranteed 100% unique across the raw dataset — duplicate VINs were investigated separately during cleaning (see `Data_Cleaning_Process.md`) rather than assumed to always indicate an error, since re-sales of the same vehicle are possible.
- **`condition`**: Scale and completeness varies; treated as a supplementary field rather than a primary analysis dimension.
- **`mmr` vs. `sellingprice`**: Both are the core fields behind the pricing analysis. Records with a missing or zero `mmr` were excluded from `Premium %` and `Pricing Status` calculations to avoid divide-by-zero and misleading classifications.
- **`saledate`**: Arrived in an inconsistent, timestamp-like text format and required explicit parsing before it could be used for any trend or time-based analysis — see `Data_Cleaning_Process.md` for the exact approach.

---

## 4. Column Usage by Tool

| Column | Used in SQL | Used in Python/Pandas | Used in Power BI |
|---|---|---|---|
| `make`, `body`, `state` | ✅ Aggregation & grouping | ✅ Standardization | ✅ Slicers, sales analysis |
| `mmr`, `sellingprice` | ✅ Averages, comparisons | ✅ Premium % calculation | ✅ Pricing analysis, KPIs |
| `odometer`, `condition` | — | ✅ Mileage Band creation | ✅ Vehicle analysis |
| `saledate` | — | ✅ Date parsing, Vehicle Age | ✅ Time-based visuals |
| `vin` | ✅ Duplicate detection | ✅ Duplicate detection | — |
| `seller` | ✅ Seller aggregation | — | ✅ Seller performance visuals |
