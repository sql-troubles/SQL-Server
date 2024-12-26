/*
Description: Index Cost Benefits
Created: 08.10.2009
Created by: ?
Modified: 28.06.2010
Modified by: A. Nastase
Source: http://gallery.technet.microsoft.com/ScriptCenter/en-us/3fd9c233-3792-41aa-91b9-6102c6da9f35
Notes: 
*/

declare @dbid int
select @dbid = db_id()

--- sys.dm_db_index_usage_stats
select 'object' = object_name(object_id),index_id
		,'user reads' = user_seeks + user_scans + user_lookups
		,'system reads' = system_seeks + system_scans + system_lookups
		,'user writes' = user_updates
		,'system writes' = system_updates
from sys.dm_db_index_usage_stats
where objectproperty(object_id,'IsUserTable') = 1
and database_id = @dbid
order by 'user reads' desc

select 'object'=object_name(o.object_id), o.index_id
		, 'usage_reads'=user_seeks + user_scans + user_lookups
		, 'operational_reads'=range_scan_count + singleton_lookup_count
		, range_scan_count
		, singleton_lookup_count
		, 'usage writes' =  user_updates
		, 'operational_leaf_writes'=leaf_insert_count+leaf_update_count+ leaf_delete_count 
		, leaf_insert_count,leaf_update_count,leaf_delete_count 
		, 'operational_leaf_page_splits' = leaf_allocation_count
		, 'operational_nonleaf_writes'=nonleaf_insert_count + nonleaf_update_count + nonleaf_delete_count
		, 'operational_nonleaf_page_splits' = nonleaf_allocation_count
from sys.dm_db_index_operational_stats (@dbid,NULL,NULL,NULL) o
	,sys.dm_db_index_usage_stats u
where objectproperty(o.object_id,'IsUserTable') = 1
and u.object_id = o.object_id
and u.index_id = o.index_id
order by operational_reads desc, operational_leaf_writes, operational_nonleaf_writes
go
