LOAD DATA INFILE
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Raw_data.csv'
INTO TABLE vehicle_raw
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@year,@make,@model,@trim,@body,@transmission,@vin,@state,@condition,@odometer,@color,@interior,@seller,@mmr,@sellingprice,@saledate)
SET
year = NULLIF(@year,''),
make = NULLIF(@make,''),
model = NULLIF(@model,''),
trim = NULLIF(@trim,''),
body = NULLIF(@body,''),
transmission = NULLIF(@transmission,''),
vin = NULLIF(@vin,''),
state = NULLIF(@state,''),
`condition` = NULLIF(@condition,''),
odometer = NULLIF(@odometer,''),
color = NULLIF(@color,''),
interior = NULLIF(@interior,''),
seller = NULLIF(@seller,''),
mmr = NULLIF(@mmr,''),
sellingprice = NULLIF(@sellingprice,''),
saledate = NULLIF(@saledate,'');