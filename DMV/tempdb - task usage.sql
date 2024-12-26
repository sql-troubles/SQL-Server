/*
Description: Real Time Tempdb Task Usage
Created: 08.10.2009
Created by: ?
Modified: 28.06.2010
Modified by: A. Nastase
Source: http://gallery.technet.microsoft.com/ScriptCenter/en-us/300762d1-86d4-4242-9843-fc868686f4f8
Notes: 
*/

SELECT t1.session_id
, (t1.internal_objects_alloc_page_count + task_alloc) as allocated
, (t1.internal_objects_dealloc_page_count + task_dealloc) as deallocated 
from sys.dm_db_session_space_usage as t1
     JOIN (--aggregated 
		select session_id
		, sum(internal_objects_alloc_page_count) as task_alloc
		, sum (internal_objects_dealloc_page_count) as task_dealloc 
		from sys.dm_db_task_space_usage group by session_id
     ) as t2
       ON t1.session_id = t2.session_id 
where t2.session_id >50
order by allocated DESC
