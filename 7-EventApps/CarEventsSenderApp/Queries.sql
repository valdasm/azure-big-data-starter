Input, output names - onlyletters allowed
When using aggregation function, use AS

https://msdn.microsoft.com/en-us/library/azure/dn931787.aspx

------------------------------------------
GOOD
1. Raw events

SELECT
   *
INTO
    [raweventsblob]
FROM
    [inputhub]

	
------------------------------------------

---------------------------------------
1. Dashboard - Real time

SELECT
    GpsTime,
    Longitude,
    Latitude,
    EngineRpm,
    SpeedOdb
INTO
    [dashboardhub]
FROM
    [inputhub]
-------------------------------------

2. Dashboard 10 seconds    
//DeviceTime faked to current

SELECT
    MAX(DeviceTime) as deviceTime,
    AVG(Longitude) as longitude,
    AVG(Latitude) as latitude,
    AVG(EngineRpm) as engineRpm,
    AVG(SpeedOdb) as speedOdb
INTO
    [dashboardhub]
FROM
    [inputhub]
TIMESTAMP BY DeviceTime
GROUP BY TumblingWindow(SECOND, 10)

//WORKS !!! timestamp as devicetime, entry to event hub
SELECT
    System.Timestamp as deviceTime,
    AVG(Longitude) as longitude,
    AVG(Latitude) as latitude,
    AVG(EngineRpm) as engineRpm,
    AVG(SpeedOdb) as speedOdb
INTO
    [dashboardhub]
FROM
    [inputhub]
GROUP BY TumblingWindow(SECOND, 10)


3. Machine Learning WORKS !!! OUTPUT VALUE NULL

SELECT 
	checkAnomaly(EngineCoolantTemp, EngineLoad, EngineRpm, HorsepowerHp, ThrottlePosition)

INTO
    [outputblob]
FROM
    [inputhub]

----------------------------------------------------------------
GOOD
4. Join reference data WORKS !!! joining column has to be of the same type INSERT INTO SQL

SELECT 
	input.carid,
	System.Timestamp as deviceTime,
	checkAnomaly(input.EngineCoolantTemp, input.EngineLoad, input.EngineRpm, input.HorsepowerHp, input.ThrottlePosition, ref.make, ref.type) AS AnomalyDetected

INTO
    [carhealthstatussql]
FROM
    [inputhub] AS input
INNER JOIN [carreferencedata] AS ref
ON input.carid = ref.carid
-----------------------------------------------------------------

5. Reference data Blob WORKS!!!
SELECT 
	
    ref.make AS Make,
    ref.type AS Type

INTO
    [outputblob]
FROM
    [inputhub] AS input
INNER JOIN [carreferencedata] AS ref
ON input.carid = ref.carid


6. Input blob  WORKS!!! UTF 8 CONVERT even though test fails, it seems to be working and writing
data back to blob storage

SELECT 
	input.carid,
	ref.make

INTO
    [outputblob]
FROM
    [inputblob] input
INNER JOIN [carreferencedata] AS ref
ON input.carid = ref.carid

7. Insert into SQL
SELECT and show that new data arrives

--------------------------------------------------------
8. PowerBi
Current Speed and revs every 5 seconds

SELECT
    System.Timestamp as deviceTime,
    AVG(EngineRpm) as engineRpm,
    AVG(SpeedOdb) as speedOdb,
	8000 as maxRpm,
	280 as maxSpeed,
	AVG(LitersPerHundredInstant) as litersInstant
INTO
    [powerbi]
FROM
    [inputhub]
GROUP BY TumblingWindow(SECOND, 5)



----------- 
-- I suspect some issues with this one
-----------

SELECT
    System.Timestamp as deviceTime,
	AVG(LitersPerHundredInstant) as litersInstant
INTO
    [powerbiconsumption]
FROM
    [inputhub]
GROUP BY HoppingWindow(Duration(minute, 5), Hop(second, 5), Offset(millisecond, -1)) 


------------------------------------------------