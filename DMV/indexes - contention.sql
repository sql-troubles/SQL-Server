/*
Description: index contention
Created by: Thomas da.
Created: 12.12.2015
Modified by: A. Nastase
Modified: 16.02.2011
Source: http://blogs.msdn.com/b/sqlcat/archive/2005/12/12/502735.aspx
Notes: 
*/

-- index contention
SELECT s.database_id
, object_name(s.object_id) [object_name]
, i.name index_name
, i.index_id      
, s.partition_number
, row_lock_count
, row_lock_wait_count
, cast (100.0 * row_lock_wait_count / (1 + row_lock_count) as numeric(15,2)) [block %]
, row_lock_wait_in_ms
, cast (1.0 * row_lock_wait_in_ms / (1 + row_lock_wait_count) as numeric(15,2)) [avg row lock waits in ms]
FROM sys.dm_db_index_operational_stats (DB_ID(), NULL, NULL, NULL) s
     JOIN sys.indexes i
       ON i.object_id = s.object_id
      AND i.index_id = s.index_id
WHERE objectproperty(s.object_id,'IsUserTable') = 1
ORDER BY row_lock_wait_count DESC
