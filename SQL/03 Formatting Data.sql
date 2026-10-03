UPDATE vehicle_clean
SET
    make = TRIM(make),
    model = TRIM(model),
    trim = TRIM(trim),
    body = TRIM(body),
    transmission = TRIM(transmission),
    vin = TRIM(vin),
    state = TRIM(state),
    color = TRIM(color),
    interior = TRIM(interior),
    seller = TRIM(seller);