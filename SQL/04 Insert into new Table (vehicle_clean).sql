

# Clean text while inserting

INSERT INTO vehicle_clean
SELECT
    year,
    TRIM(make),
    TRIM(model),
    TRIM(trim),
    TRIM(body),
    TRIM(transmission),
    UPPER(TRIM(vin)),
    UPPER(TRIM(state)),
    `condition`,
    odometer,
    TRIM(color),
    TRIM(interior),
    TRIM(seller),
    mmr,
    sellingprice,
    saledate
FROM vehicle_raw;