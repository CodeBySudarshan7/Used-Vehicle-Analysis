# 🧹 Data Cleaning Process

This document describes the step-by-step process used to transform the raw used-vehicle sales dataset (**550K+ records**) into the cleaned, analysis-ready dataset used for SQL, Python, and Power BI analysis.

The guiding principle throughout: **profile before you touch anything, and never silently drop large numbers of records without understanding why they're being removed.**

---

## Step 1 — Initial Data Profiling

Before making any changes, the raw dataset was profiled to understand its shape and quality:

- Row and column counts
- Data types per column
- Missing-value counts per column
- Basic descriptive statistics (`min`, `max`, `mean`) for numeric fields
- Unique-value counts for categorical fields (to spot inconsistent variants, e.g. `"toyota"` vs `"Toyota"` vs `"TOYOTA "`)

This profiling step is what surfaced the specific issues addressed below — the cleaning plan was built from what the data actually showed, not assumed in advance.

---

## Step 2 — Missing Value Analysis

- Identified which columns had missing values and how frequently.
- Numeric fields with valid business meaning for "unknown" (e.g., missing `condition`) were flagged rather than dropped outright.
- Records missing critical fields for pricing analysis (`mmr` or `sellingprice`) were excluded from pricing-specific calculations, since imputing a sale price would distort the analysis rather than clarify it.

```python
# Missing value summary
df.isnull().sum()
```

---

## Step 3 — Duplicate Detection

- Checked for fully duplicate rows across all columns.
- Checked separately for duplicate `vin` values, since a repeated VIN could mean either a data-entry error *or* a legitimate re-sale of the same vehicle — these were reviewed rather than deleted automatically.

```python
# Full duplicate rows
df.duplicated().sum()

# Duplicate VINs
df["vin"].duplicated().sum()
```

```sql
-- Duplicate VIN check in SQL
SELECT vin, COUNT(*) AS occurrences
FROM vehicle_raw
GROUP BY vin
HAVING COUNT(*) > 1;
```

---

## Step 4 — Standardizing Categorical Text Fields

Categorical columns (`make`, `body`, `color`, `interior`) had inconsistent casing and stray whitespace, which would otherwise cause the same category to be counted as multiple distinct groups.

```python
df["make"] = df["make"].astype("string").str.strip().str.upper()
df["body"] = df["body"].astype("string").str.strip().str.upper()
df["color"] = df["color"].astype("string").str.strip().str.upper()
df["interior"] = df["interior"].astype("string").str.strip().str.upper()
```

This step alone materially changed the "unique value" counts for these columns — several makes and body types were being split across near-duplicate spellings before standardization.

---

## Step 5 — Numeric Field Validation

- Checked `odometer`, `mmr`, and `sellingprice` for negative values, zero values where they shouldn't occur, and extreme outliers.
- Records with clearly invalid numeric values (e.g., negative mileage) were flagged and excluded from analysis rather than corrected with guessed values.

---

## Step 6 — Date Cleaning

- The raw `saledate` field arrived in an inconsistent, timestamp-like text format.
- Parsed into a proper datetime type and stored as `SaleDate_Clean`.
- Records with unparseable dates were flagged separately so they could still be included in non-time-based analysis without breaking time-series calculations.

```python
df["SaleDate_Clean"] = pd.to_datetime(df["saledate"], errors="coerce")
```

---

## Step 7 — Feature Engineering

New columns were derived from the cleaned base data to support the core business analysis:

| Feature | Logic |
|---|---|
| `Vehicle Age` | `SaleDate_Clean.dt.year − year` |
| `Mileage Band` | `odometer` bucketed into ranges |
| `Pricing Status` | Compares `sellingprice` vs. `mmr` |
| `Premium %` | `(sellingprice − mmr) / mmr × 100` |

```python
df["Vehicle Age"] = df["SaleDate_Clean"].dt.year - df["year"]
```

---

## Step 8 — Data-Quality Flags

Rather than deleting every imperfect record, a set of quality flags was added so downstream analysis could choose to include or exclude questionable rows depending on the question being asked:

- `has_missing_price` — `mmr` or `sellingprice` missing
- `has_invalid_odometer` — negative or implausible mileage
- `has_unparsed_date` — `saledate` could not be parsed

---

## Step 9 — Validation Against SQL

After cleaning in Python, key aggregate figures (total records, average selling price, sales by make/state) were re-computed in SQL against the cleaned table and cross-checked against the Python output to confirm the cleaning pipeline hadn't introduced inconsistencies.

```sql
SELECT COUNT(*) FROM vehicle_clean;
SELECT AVG(sellingprice) FROM vehicle_clean;
```

---

## Summary

| Stage | Purpose |
|---|---|
| Profiling | Understand the data before touching it |
| Missing values | Identify and handle gaps without guessing |
| Duplicates | Detect exact duplicates and duplicate VINs |
| Standardization | Normalize categorical text for accurate grouping |
| Numeric validation | Catch invalid/out-of-range values |
| Date cleaning | Produce a reliable field for time-based analysis |
| Feature engineering | Add analysis-ready derived columns |
| Quality flags | Preserve transparency instead of silent deletion |
| SQL validation | Confirm the cleaned dataset is internally consistent |

This approach prioritized **traceability** — at every stage, it's possible to see what was changed, why, and how many records were affected, rather than treating cleaning as an opaque black box between raw and processed data.
