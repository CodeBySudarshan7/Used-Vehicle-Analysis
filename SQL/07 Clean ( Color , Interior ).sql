# Clean your bad Color/Interior values

# COLOR --

SELECT DISTINCT color
FROM vehicle_clean
WHERE color REGEXP '^[0-9]+$'
ORDER BY color;

UPDATE vehicle_clean
SET color = NULL
WHERE color IS NULL
   OR TRIM(color) = ''
   OR TRIM(color) = '—'
   OR TRIM(color) = '–'
   OR TRIM(color) = 'Â€”'
   OR TRIM(color) REGEXP '^[0-9]+$';

UPDATE vehicle_clean
SET color =
    CASE
        WHEN LOWER(TRIM(color)) = 'beige' THEN 'Beige'
        WHEN LOWER(TRIM(color)) = 'black' THEN 'Black'
        WHEN LOWER(TRIM(color)) = 'blue' THEN 'Blue'
        WHEN LOWER(TRIM(color)) = 'brown' THEN 'Brown'
        WHEN LOWER(TRIM(color)) = 'burgundy' THEN 'Burgundy'
        WHEN LOWER(TRIM(color)) = 'charcoal' THEN 'Charcoal'
        WHEN LOWER(TRIM(color)) = 'gold' THEN 'Gold'
        WHEN LOWER(TRIM(color)) = 'gray' THEN 'Gray'
        WHEN LOWER(TRIM(color)) = 'green' THEN 'Green'
        WHEN LOWER(TRIM(color)) = 'lime' THEN 'Lime'
        WHEN LOWER(TRIM(color)) = 'off-white' THEN 'Off-White'
        WHEN LOWER(TRIM(color)) = 'orange' THEN 'Orange'
        WHEN LOWER(TRIM(color)) = 'pink' THEN 'Pink'
        WHEN LOWER(TRIM(color)) = 'purple' THEN 'Purple'
        WHEN LOWER(TRIM(color)) = 'red' THEN 'Red'
        WHEN LOWER(TRIM(color)) = 'silver' THEN 'Silver'
        WHEN LOWER(TRIM(color)) = 'turquoise' THEN 'Turquoise'
        WHEN LOWER(TRIM(color)) = 'white' THEN 'White'
        WHEN LOWER(TRIM(color)) = 'yellow' THEN 'Yellow'
        ELSE color
    END;


# INTERIOR -- 

UPDATE vehicle_clean
SET interior = NULL
WHERE interior IS NULL
   OR TRIM(interior) = ''
   OR TRIM(interior) = '—'
   OR TRIM(interior) = '–'
   OR TRIM(interior) = 'Â€”';

UPDATE vehicle_clean
SET interior =
    CASE
        WHEN LOWER(TRIM(interior)) = 'beige' THEN 'Beige'
        WHEN LOWER(TRIM(interior)) = 'black' THEN 'Black'
        WHEN LOWER(TRIM(interior)) = 'blue' THEN 'Blue'
        WHEN LOWER(TRIM(interior)) = 'brown' THEN 'Brown'
        WHEN LOWER(TRIM(interior)) = 'burgundy' THEN 'Burgundy'
        WHEN LOWER(TRIM(interior)) = 'gold' THEN 'Gold'
        WHEN LOWER(TRIM(interior)) = 'gray' THEN 'Gray'
        WHEN LOWER(TRIM(interior)) = 'green' THEN 'Green'
        WHEN LOWER(TRIM(interior)) = 'off-white' THEN 'Off-White'
        WHEN LOWER(TRIM(interior)) = 'orange' THEN 'Orange'
        WHEN LOWER(TRIM(interior)) = 'purple' THEN 'Purple'
        WHEN LOWER(TRIM(interior)) = 'red' THEN 'Red'
        WHEN LOWER(TRIM(interior)) = 'silver' THEN 'Silver'
        WHEN LOWER(TRIM(interior)) = 'tan' THEN 'Tan'
        WHEN LOWER(TRIM(interior)) = 'white' THEN 'White'
        WHEN LOWER(TRIM(interior)) = 'yellow' THEN 'Yellow'
        ELSE interior
    END;
    
    


