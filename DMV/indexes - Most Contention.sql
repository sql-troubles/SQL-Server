/*
Description: Indexes With the Most Contention
Created: 08.10.2009
Created by: ?
Modified: 28.06.2010
Modified by: A. Nastase
Source: http://gallery.technet.microsoft.com/ScriptCenter/en-us/e909e469-3f9c-4dc5-92db-3d10bd4373d8
Notes: 
*/

declare @dbid int
select @dbid = db_id()

Select dbid=database_id
    , objectname=object_name(s.object_id)
	, indexname=i.name
	, i.index_id	--, partition_number
	, row_lock_count
	, row_lock_wait_count
	, [block %]=cast (100.0 * row_lock_wait_count / (1 + row_lock_count) as numeric(15,2))
	, row_lock_wait_in_ms
	, [avg row lock waits in ms]=cast (1.0 * row_lock_wait_in_ms / (1 + row_lock_wait_count) as numeric(15,2))
from sys.dm_db_index_operational_stats (@dbid, NULL, NULL, NULL) s
	 JOIN sys.indexes i
	   ON i.object_id = s.object_id
      and i.index_id = s.index_id
where objectproperty(s.object_id,'IsUserTable') = 1
order by row_lock_wait_count desc
