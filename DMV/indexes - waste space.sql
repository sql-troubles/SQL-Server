/*
Description: indexes - waste space 
Created by: Deepak Biswal
Created: 29.06.2012
Modified by: A. Nastase
Modified: 02.07.2012
Source: http://blogs.msdn.com/b/deepakbi/archive/2012/06/29/how-much-space-are-you-wasting.aspx
Notes: 
*/ 

-- indexes - waste space 
WITH WastedMB 
AS
(
SELECT t1.database_id
, t1.object_id
, t1.index_id
, t2.name
, t3.partition_number
, t3.used_page_count
FROM sys.dm_db_index_usage_stats t1
     JOIN sys.indexes t2 
       ON t1.object_id = t2.object_id 
      AND t1.index_id = t2.index_id
     JOIN sys.dm_db_partition_stats t3 
       ON t1.object_id = t3.object_id 
      AND t1.index_id = t3.index_id
WHERE database_id = DB_ID() 
  and user_seeks = 0 
  and user_scans = 0 and user_lookups = 0 
  and OBJECTPROPERTY(t1.[object_id],'IsUserTable') = 1 and t2.index_id > 1 
  and t2.is_unique = 0 and t2.is_unique_constraint = 0
)
SELECT DB_NAME(database_id) database_name
, OBJECT_NAME(object_id) [table]
, index_id
, name [index name]
, COUNT(*) AS [partitions count]
, SUM(used_page_count) AS  [Pages count]
, (SUM(used_page_count) * 8) / 1024 AS [waste space (MB)]
FROM  WastedMB
GROUP BY database_id, object_id, index_id,name
ORDER BY [waste space (MB)] DESC
, [table]
, [index name]
COMPUTE SUM((SUM(used_page_count) * 8) / 1024)
