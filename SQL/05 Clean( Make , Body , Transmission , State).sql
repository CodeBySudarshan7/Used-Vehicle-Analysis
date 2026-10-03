
# Standardize Make -- 

UPDATE vehicle_clean
SET make =
    CASE
        WHEN LOWER(make) = 'bmw' THEN 'BMW'
        WHEN LOWER(make) = 'mini' THEN 'MINI'
        WHEN LOWER(make) IN ('vw', 'volkswagen') THEN 'Volkswagen'
        WHEN LOWER(make) IN ('mercedes', 'mercedes-b') THEN 'Mercedes-Benz'
        WHEN LOWER(make) IN ('landrover', 'land rover') THEN 'Land Rover'
        WHEN LOWER(make) IN ('gmc truck', 'gmc') THEN 'GMC'
        WHEN LOWER(make) IN ('ford tk', 'ford truck') THEN 'Ford'
        WHEN LOWER(make) = 'dodge tk' THEN 'Dodge'
        WHEN LOWER(make) = 'chev truck' THEN 'Chevrolet'
        ELSE make
    END;
    
    
 # Standardize Body -- 
 
UPDATE vehicle_clean
SET body =
    CASE
        WHEN LOWER(body) = 'suv' THEN 'SUV'
        WHEN LOWER(body) = 'regular-cab' THEN 'Regular Cab'
        ELSE body
    END;
    
    
# Standardize Transmission -- 
    
UPDATE vehicle_clean
SET transmission =
    CASE
        WHEN LOWER(TRIM(transmission)) = 'automatic' THEN 'Automatic'
        WHEN LOWER(TRIM(transmission)) = 'manual' THEN 'Manual'
        WHEN transmission IS NULL OR TRIM(transmission) = '' THEN 'Unknown'
        ELSE 'Unknown'
    END;
    
 
# Clean State --


UPDATE vehicle_clean
SET state = UPPER(TRIM(state));