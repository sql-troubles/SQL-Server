/*
Description: Rarely-Used Indexes
Created: 08.10.2009
Created by: ?
Modified: 28.06.2010
Modified by: A. Nastase
Source: http://gallery.technet.microsoft.com/ScriptCenter/en-us/72369ef6-38e7-4ead-a774-4a970f13ad45
Notes: 
*/


declare @dbid int
select @dbid = db_id()

select objectname=object_name(s.object_id), s.object_id
, indexname=i.name, i.index_id
, user_seeks
, user_scans
, user_lookups
, user_updates
, user_seeks + user_scans + user_lookups + user_updates score
, last_user_seek
, last_user_scan
, last_user_lookup
, last_user_update
from sys.dm_db_index_usage_stats s
	 JOIN sys.indexes i
	   ON i.object_id = s.object_id
and i.index_id = s.index_id
where database_id = @dbid 
and objectproperty(s.object_id,'IsUserTable') = 1
order by score asc
