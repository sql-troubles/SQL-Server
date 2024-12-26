/*
Description: database - files autogrowth quota
Created by: Greg Larsen
Created: 23.11.2012
Modified by: A. Nastase
Modified: 20.11.2013
Notes: 
Source: https://www.simple-talk.com/sql/database-administration/sql-server-database-growth-and-autogrowth-settings/
*/
-- database - files autogrowth events
DECLARE @filename NVARCHAR(1000);
DECLARE @bc INT;
DECLARE @ec INT;
DECLARE @bfn VARCHAR(1000);
DECLARE @efn VARCHAR(10);

-- Get the name of the current default trace
SELECT @filename = CAST(value AS NVARCHAR(1000))
FROM ::fn_trace_getinfo(DEFAULT)
WHERE traceid = 1 AND property = 2;

-- rip apart file name into pieces
SET @filename = REVERSE(@filename);
SET @bc = CHARINDEX('.',@filename);
SET @ec = CHARINDEX('_',@filename)+1;
SET @efn = REVERSE(SUBSTRING(@filename,1,@bc));
SET @bfn = REVERSE(SUBSTRING(@filename,@ec,LEN(@filename)));

-- set filename without rollover number
SET @filename = @bfn + @efn

-- process all trace files
SELECT 
  Cast(ftg.StartTime as Date) Datum --StartTime
, te.name AS Ereignis --EventName
, db.name Datenbank --DatabaseName  
, ftg.Filename Datei
,SUM((ftg.IntegerData*8)/1024.0) AS [Wachstum (MB)] 
,AVG((ftg.duration/1000)) AS [Durch Wachstumzeit (ms)]
, MIN(ftg.StartTime) [Erste Wachstum]
, MAX(ftg.StartTime) [Letzte Wachstum]
, count(*) [Anzahl Wachstums]
FROM ::fn_trace_gettable(@filename, DEFAULT) AS ftg 
INNER JOIN sys.trace_events AS te ON ftg.EventClass = te.trace_event_id  
JOIN sys.databases db ON ftg.databaseid = db.database_id 
WHERE (ftg.EventClass = 92  -- Date File Auto-grow
    OR ftg.EventClass = 93) -- Log File Auto-grow
	--AND db.name = 'DynamicsAXLHBw'
GROUP BY Cast(ftg.StartTime as Date)
, te.name 
, db.name
,ftg.Filename
ORDER BY Datum
