# 📂 Raw Data

This folder contains the **original, unmodified** used-vehicle sales dataset before any cleaning, validation, or transformation.

## File(s)

| File | Description |
|---|---|
| `used_vehicle_sales_raw.csv` | Original dataset as sourced — **550K+ records**, 16 columns |

> ⚠️ Update the filename above to match your actual raw data file.

## Purpose

The raw file is kept untouched and separate from `data/processed/` so that:

- Every cleaning and transformation step is **reproducible** — the pipeline can always be re-run from this original source.
- Data-quality issues (missing values, duplicates, inconsistent categories) can be **audited** by comparing raw vs. processed.
- No cleaning step accidentally overwrites or destroys original information.

## Schema (as received)

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

## Known Data-Quality Issues

These are addressed during cleaning (see `notebooks/cleaning_and_eda.ipynb` and `sql/analysis_queries.sql`) — this file is left as-is so the "before" state is always available for reference:

- Missing values across several columns
- Duplicate records and duplicate VINs
- Inconsistent casing/spacing in categorical fields (`make`, `body`, `color`, `interior`)
- Invalid or out-of-range numerical values
- Unstructured/inconsistent `saledate` formatting

## Do Not Edit

Please do not modify files in this folder directly. If a correction to the source data is genuinely needed, document it in a commit message and keep a copy of the original for comparison.
