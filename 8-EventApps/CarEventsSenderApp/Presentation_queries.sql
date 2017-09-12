--- 1. PowerBi real time
-- inserts into car_events table
SELECT
    System.Timestamp as deviceTime,
    EngineRpm as engineRpm,
    SpeedOdb as speedOdb,
	8000 as maxRpm,
	280 as maxSpeed,
	LitersPerHundredInstant as litersInstant
INTO
    [powerbi]
FROM
    [inputhub]


---2. Raw Storage 

SELECT
   *
INTO
    [raweventsblob]
FROM
    [inputhub]


-- 3. Real time web
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
GROUP BY TumblingWindow(SECOND, 5)


--4. Azure ML
--DONT RUN
SELECT 
	checkAnomaly(EngineCoolantTemp, EngineLoad, EngineRpm, HorsepowerHp, ThrottlePosition)
INTO
    [carhealthstatussql]
FROM
    [inputhub]

--  TO BE EXECUTED
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

