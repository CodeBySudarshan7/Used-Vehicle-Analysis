# Add Column 

# Vehicle Age -- 
ALTER TABLE vehicle_clean
ADD COLUMN vehicle_age INT;

UPDATE vehicle_clean
SET vehicle_age =
    YEAR(sale_datetime) - year
WHERE sale_datetime IS NOT NULL
  AND year IS NOT NULL; 
  
# Delete sale year is earlier than the vehicle year --

DELETE FROM vehicle_clean
WHERE sale_datetime IS NOT NULL
  AND year IS NOT NULL
  AND YEAR(sale_datetime) - year < 0;
  
  

# Price Difference --

ALTER TABLE vehicle_clean
ADD COLUMN price_difference DECIMAL(12,2);

UPDATE vehicle_clean
SET price_difference = sellingprice - mmr
WHERE sellingprice IS NOT NULL
  AND mmr IS NOT NULL;
  
  
  
# Premium %
ALTER TABLE vehicle_clean
ADD COLUMN premium_pct DECIMAL(10,4);

ALTER TABLE vehicle_clean
MODIFY COLUMN premium_pct DECIMAL(10,2);

UPDATE vehicle_clean
SET premium_pct =
    CASE
        WHEN mmr IS NOT NULL
             AND mmr > 0
             AND sellingprice IS NOT NULL
        THEN ROUND(((sellingprice - mmr) / mmr) * 100, 2)
        ELSE NULL
    END;
    
# Premium / Discount category -- 

ALTER TABLE vehicle_clean
ADD COLUMN pricing_status VARCHAR(20);

UPDATE vehicle_clean
SET pricing_status =
    CASE
        WHEN premium_pct > 0 THEN 'Premium'
        WHEN premium_pct < 0 THEN 'Discount'
        WHEN premium_pct = 0 THEN 'At MMR'
        ELSE 'Unknown'
    END;

# VIN validation --

ALTER TABLE vehicle_clean
ADD COLUMN vin_quality VARCHAR(20);

UPDATE vehicle_clean
SET vin_quality =
    CASE
        WHEN vin IS NULL OR TRIM(vin) = '' THEN 'Missing'
        WHEN CHAR_LENGTH(vin) < 10 THEN 'Invalid'
        ELSE 'Valid'
    END;

# Duplicate VINs --

SELECT
    vin,
    COUNT(*) AS duplicate_count
FROM vehicle_clean
WHERE vin IS NOT NULL
GROUP BY vin
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;

# Data Quality flags --

ALTER TABLE vehicle_clean
ADD COLUMN overall_quality VARCHAR(20);

UPDATE vehicle_clean
SET overall_quality =
    CASE
        WHEN year IS NULL
          OR odometer IS NULL
          OR mmr IS NULL
          OR sellingprice IS NULL
          OR sale_datetime IS NULL
          OR vin_quality = 'Invalid'
            THEN 'Invalid'

        WHEN vin IS NULL
          OR TRIM(vin) = ''
            THEN 'Review'

        ELSE 'Valid'
    END;
    

