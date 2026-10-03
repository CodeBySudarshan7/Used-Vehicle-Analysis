SELECT *
FROM vehicle_clean;
SELECT *
FROM vehicle_clean
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/vehicle_clean.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';