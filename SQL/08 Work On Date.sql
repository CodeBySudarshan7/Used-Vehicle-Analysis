# Adding New Columns

# Convert SaleDate -- 

ALTER TABLE vehicle_clean
ADD COLUMN sale_datetime DATETIME;

UPDATE vehicle_clean
SET sale_datetime =
    CASE
        WHEN saledate IS NULL OR TRIM(saledate) = '' THEN NULL

        WHEN TRIM(saledate) REGEXP
             '^[A-Za-z]{3} [A-Za-z]{3} [0-9]{1,2} [0-9]{4} [0-9]{2}:[0-9]{2}:[0-9]{2} GMT'
        THEN
            STR_TO_DATE(
                SUBSTRING_INDEX(TRIM(saledate), ' GMT', 1),
                '%a %b %d %Y %H:%i:%s'
            )

        ELSE NULL
    END;

# Delete invalid/unconverted dates

DELETE FROM vehicle_clean
WHERE sale_datetime IS NULL
  AND saledate IS NOT NULL
  AND TRIM(saledate) <> '';