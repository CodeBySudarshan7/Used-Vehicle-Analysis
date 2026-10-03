# Numeric validation -- 

# Year --

UPDATE vehicle_clean
SET year = NULL
WHERE year < 1980
   OR year > YEAR(CURDATE());
 
# odometer --

UPDATE vehicle_clean
SET odometer = NULL
WHERE odometer <= 0;

# mmr -- 

UPDATE vehicle_clean
SET mmr = NULL
WHERE mmr <= 0;
   
# sellingprice -- 

UPDATE vehicle_clean
SET sellingprice = NULL
WHERE sellingprice <= 0;
