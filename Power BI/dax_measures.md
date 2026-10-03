# 📊 Power BI DAX Measures

This document contains the main **DAX measures** used in the Used Vehicle Sales & Pricing Analytics Power BI dashboard.

The measures are designed to analyze vehicle sales, pricing performance, MMR comparison, vehicle volume, and market positioning.

> **Note:** All measures assume the cleaned data is loaded into a table named `tblCleanVehicles` with columns `sellingprice`, `mmr`, `state`, `VehicleAge`, and `odometer`. Rename the table/column references below to match your actual Power BI data model if they differ.

---

# 📌 Table of Contents

- [1. Total Vehicles](#1-total-vehicles)
- [2. Total Sales](#2-total-sales)
- [3. Average Selling Price](#3-average-selling-price)
- [4. Average MMR](#4-average-mmr)
- [5. Average Price Difference](#5-average-price-difference)
- [6. Average Premium %](#6-average-premium-)
- [7. Vehicles Above MMR](#7-vehicles-above-mmr)
- [8. Vehicles Below MMR](#8-vehicles-below-mmr)
- [9. Vehicles At MMR](#9-vehicles-at-mmr)
- [10. Above MMR %](#10-above-mmr-)
- [11. Below MMR %](#11-below-mmr-)
- [12. Average Vehicle Age](#12-average-vehicle-age)
- [13. Average Mileage](#13-average-mileage)
- [14. Top State Sales](#14-top-state-sales)
- [15. Average Price - Top State](#15-average-price---top-state)
- [16. Average Vehicles per State](#16-average-vehicles-per-state)
- [17. Pricing Status](#17-pricing-status)

---

# 1. Total Vehicles

Counts the total number of vehicle sales records in the dataset. Powers the "Total Vehicles" KPI card and responds to all active slicers (make, state, body type, etc.).

```DAX
Total Vehicles =
COUNTROWS(tblCleanVehicles)
```

---

# 2. Total Sales

Sums the actual selling price across all vehicles in the current filter context. Represents total revenue generated from vehicle sales.

```DAX
Total Sales =
SUM(tblCleanVehicles[sellingprice])
```

---

# 3. Average Selling Price

Calculates the average actual selling price of vehicles. Used to benchmark overall pricing levels and to compare across makes, states, or body types via slicers.

```DAX
Average Selling Price =
AVERAGE(tblCleanVehicles[sellingprice])
```

---

# 4. Average MMR

Calculates the average market reference value (MMR) across vehicles. Used as the baseline for all pricing-performance comparisons.

```DAX
Average MMR =
AVERAGE(tblCleanVehicles[mmr])
```

---

# 5. Average Price Difference

Calculates the average absolute difference between selling price and MMR — a simple, non-normalized view of pricing performance.

```DAX
Average Price Difference =
AVERAGEX(
    tblCleanVehicles,
    tblCleanVehicles[sellingprice] - tblCleanVehicles[mmr]
)
```

---

# 6. Average Premium %

Calculates the average normalized pricing performance across vehicles — how far, on average, selling price deviates from MMR as a percentage. This is the row-level `Premium %` metric aggregated for the dashboard.

```DAX
Average Premium % =
AVERAGEX(
    tblCleanVehicles,
    DIVIDE(
        tblCleanVehicles[sellingprice] - tblCleanVehicles[mmr],
        tblCleanVehicles[mmr]
    )
) * 100
```

---

# 7. Vehicles Above MMR

Counts vehicles that sold for more than their MMR (sold at a premium to the market reference value).

```DAX
Vehicles Above MMR =
CALCULATE(
    COUNTROWS(tblCleanVehicles),
    tblCleanVehicles[sellingprice] > tblCleanVehicles[mmr]
)
```

---

# 8. Vehicles Below MMR

Counts vehicles that sold for less than their MMR (sold under the market reference value).

```DAX
Vehicles Below MMR =
CALCULATE(
    COUNTROWS(tblCleanVehicles),
    tblCleanVehicles[sellingprice] < tblCleanVehicles[mmr]
)
```

---

# 9. Vehicles At MMR

Counts vehicles that sold at exactly their MMR value.

```DAX
Vehicles At MMR =
CALCULATE(
    COUNTROWS(tblCleanVehicles),
    tblCleanVehicles[sellingprice] = tblCleanVehicles[mmr]
)
```

---

# 10. Above MMR %

Calculates the percentage of vehicles that sold above MMR, relative to total vehicles in the current filter context. Powers the "Above MMR %" KPI card.

```DAX
Above MMR % =
DIVIDE(
    [Vehicles Above MMR],
    [Total Vehicles]
) * 100
```

---

# 11. Below MMR %

Calculates the percentage of vehicles that sold below MMR, relative to total vehicles in the current filter context. Powers the "Below MMR %" KPI card.

```DAX
Below MMR % =
DIVIDE(
    [Vehicles Below MMR],
    [Total Vehicles]
) * 100
```

---

# 12. Average Vehicle Age

Calculates the average vehicle age (in years) at the time of sale, using the engineered `VehicleAge` column. Used to analyze how age relates to pricing and sales volume.

```DAX
Average Vehicle Age =
AVERAGE(tblCleanVehicles[VehicleAge])
```

---

# 13. Average Mileage

Calculates the average odometer reading across vehicles. Used alongside vehicle age to analyze condition-driven pricing effects.

```DAX
Average Mileage =
AVERAGE(tblCleanVehicles[odometer])
```

---

# 14. Top State Sales

Returns the highest number of vehicles sold by any single state in the current filter context — used to highlight the leading state on the geographic analysis page.

```DAX
Top State Sales =
MAXX(
    VALUES(tblCleanVehicles[state]),
    CALCULATE(COUNTROWS(tblCleanVehicles))
)
```

---

# 15. Average Price - Top State

Calculates the average selling price within the state that has the highest sales volume, allowing a direct pricing comparison against the overall average.

```DAX
Average Price - Top State =
VAR TopState =
    TOPN(
        1,
        VALUES(tblCleanVehicles[state]),
        CALCULATE(COUNTROWS(tblCleanVehicles)),
        DESC
    )
RETURN
CALCULATE(
    AVERAGE(tblCleanVehicles[sellingprice]),
    KEEPFILTERS(TopState)
)
```

---

# 16. Average Vehicles per State

Calculates the average number of vehicles sold per state — a normalized measure of sales distribution/concentration across the dataset.

```DAX
Average Vehicles per State =
DIVIDE(
    [Total Vehicles],
    DISTINCTCOUNT(tblCleanVehicles[state])
)
```

---

# 17. Pricing Status

Classifies each vehicle as sold **Above**, **At**, or **Below** MMR. Implemented as a calculated column so it can be used directly as a category on slicers, legends, and matrix visuals (rather than a measure, since it evaluates per-row).

```DAX
Pricing Status =
SWITCH(
    TRUE(),
    tblCleanVehicles[sellingprice] > tblCleanVehicles[mmr], "Above MMR",
    tblCleanVehicles[sellingprice] < tblCleanVehicles[mmr], "Below MMR",
    "At MMR"
)
```

---

## 🧠 Notes on Usage

- Measures **7–11** work together as a set: 7–9 return raw counts, 10–11 turn those counts into the percentages shown on the KPI cards.
- Measure **17** (`Pricing Status`) is a **calculated column**, not a measure — it must exist per-row before measures like `Vehicles Above MMR` can be visualized by category on a chart legend.
- All measures respect the active filter context, so they automatically recalculate when a user interacts with the make, state, body type, or year slicers on the dashboard.
- For large models (550K+ rows), prefer `DIVIDE()` over the `/` operator throughout — it safely handles divide-by-zero cases without extra `IF()` wrapping.
