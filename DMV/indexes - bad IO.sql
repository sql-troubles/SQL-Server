/*
Description: Possible Bad NC Indexes (writes > reads)
Created by: G. Berry
Created: 02.08.2010
Modified by: A. Nastase
Modified: 16.02.2011
Notes: Consider your complete workload
-- Investigate further before dropping an index
*/

SELECT OBJECT_NAME(s.[object_id]) AS [table_name]
, i.name AS [index_name]
, i.index_id
, user_updates AS [Total Writes]
, user_seeks + user_scans + user_lookups AS [Total Reads]
, user_updates - (user_seeks + user_scans + user_lookups) AS [Difference]
, user_updates /(user_seeks + user_scans + user_lookups) AS [Ratio]
FROM sys.dm_db_index_usage_stats AS s WITH (NOLOCK)
    JOIN sys.indexes AS i WITH (NOLOCK)
      ON s.[object_id] = i.[object_id]
     AND i.index_id = s.index_id
WHERE OBJECTPROPERTY(s.[object_id],'IsUserTable') = 1
AND s.database_id = DB_ID()
AND user_updates > (user_seeks + user_scans + user_lookups)
AND i.index_id > 1
ORDER BY [Difference] DESC
, [Total Writes] DESC
, [Total Reads] ASC;
