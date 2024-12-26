/*
Description: object buffering dirty vs clean pages.
Created by: Paul
Created: ?
Modified by: A. Nastase
Modified: 04.08.2010
Source: http://sqlskills.com/BLOGS/PAUL/post/Inside-the-Storage-Engine-Whats-in-the-buffer-pool.aspx
Notes:      
*/

select ObjectName
, ISNULL(Clean,0) as CleanPages
, ISNULL(Dirty,0) as DirtyPages
, str(ISNULL(Clean,0)/128.0,12,2) CleanPagesMB
, str(ISNULL(Dirty,0/128.0),12,2) as DirtyPagesMB
from
(
SELECT Case 
	WHEN GROUPING(t.object_id) = 1 then '=> Sum'
	ELSE Quotename(OBJECT_SCHEMA_NAME(t.object_id)) + '.' + Quotename(OBJECT_NAME(t.object_id)) 
  END as ObjectName
,CASE 
	WHEN bd.is_modified = 1 THEN 'Dirty' 
	ELSE 'Clean' 
END AS PageState
, COUNT (*) AS [PageCount]
from sys.dm_os_buffer_descriptors bd
     join sys.allocation_units as allc 
       on allc.allocation_unit_id = bd.allocation_unit_id
     join sys.partitions part
       on allc.container_id = part.partition_id
     join sys.tables t
       on part.object_id = t.object_id 
where bd.database_id = DB_ID()
Group by GROUPING sets
((t.object_id,bd.is_modified),(bd.is_modified))
)pgs
pivot (sum(PageCount) for PageState in ([Clean],[Dirty])) as pvt
