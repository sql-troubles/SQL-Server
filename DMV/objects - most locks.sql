/*
Description: objects with most locks
Created: 19.01.2010
Created by: Unknown
Modified: 19.01.2010
Modified by: A. Nastase
Source: (How to: Determine Which Queries Are Holding Locks) http://technet.microsoft.com/en-us/library/bb630355(SQL.100).aspx
Notes: 
Warning: NOT TESTED YET!!! Not modified yet, the code is based on AdventureWorksDW
*/ 

-- Find objects in a particular database that have the most
-- lock acquired. This sample uses AdventureWorks_DW.
-- Create the session and add an event and target.
-- 
IF EXISTS(SELECT * FROM sys.server_event_sessions WHERE name='LockCounts')
DROP EVENT session LockCounts ON SERVER
GO
DECLARE @dbid int

SELECT @dbid = db_id('AdventureWorksDW')

DECLARE @sql nvarchar(1024)
SET @sql = '
CREATE event session LockCounts ON SERVER
ADD EVENT sqlserver.lock_acquired (WHERE database_id =' + CAST(@dbid AS nvarchar) +')
ADD TARGET package0.synchronous_bucketizer ( 
SET filtering_event_name=''sqlserver.lock_acquired'', source_type=0, source=''resource_0'')'

EXEC (@sql)
GO
ALTER EVENT session LockCounts ON SERVER 
STATE=start
GO
-- 
-- Create a simple workload that takes locks.
-- 
USE AdventureWorksDW
GO
SELECT TOP 1 * FROM dbo.vAssocSeqLineItems
GO
-- Bucketizing target output is available from the 
-- sys.dm_xe_session_targets dynamic management view in
-- XML format.
-- The following query joins the bucketizing target output with
-- sys.objects to obtain the object names.
--
SELECT name, object_id, lock_count FROM 
(SELECT objstats.value('.','bigint') AS lobject_id, 
objstats.value('@count', 'bigint') AS lock_count
FROM (
SELECT CAST(xest.target_data AS XML)
LockData
FROM sys.dm_xe_session_targets xest
JOIN sys.dm_xe_sessions xes ON xes.address = xest.event_session_address
JOIN sys.server_event_sessions ses ON xes.name = ses.name
WHERE xest.target_name = 'synchronous_bucketizer' AND xes.name = 'LockCounts'
) Locks
CROSS APPLY LockData.nodes('//BucketizerTarget/Slot') AS T(objstats)
 ) LockedObjects 
INNER JOIN sys.objects o
ON LockedObjects.lobject_id = o.object_id
WHERE o.type != 'S' AND o.type = 'U'
ORDER BY lock_count desc
GO
-- 
-- Stop the event session.
-- 
ALTER EVENT SESSION LockCounts ON SERVER
state=stop
GO
