/*
Description: Missing Indexes
Created: 08.10.2009
Created by: ?
Modified: 28.06.2010
Modified by: A. Nastase
Source: http://gallery.technet.microsoft.com/ScriptCenter/en-us/abf03365-3605-407f-a0ac-8e4e219947bf
Notes: 
*/

declare @dbid int
select @dbid = db_id()

select d.index_handle
, d.object_id
, object_name(d.object_id) table_name
, D.equality_columns
, d.inequality_columns
, d.included_columns
, d.statement
, s.avg_total_user_cost
, s.avg_user_impact
, s.last_user_seek
, s.unique_compiles
from sys.dm_db_missing_index_group_stats s
     JOIN sys.dm_db_missing_index_groups g
       ON s.group_handle = g.index_group_handle
          JOIN sys.dm_db_missing_index_details d
            ON d.index_handle = g.index_handle
              JOIN sys.objects o 
                ON D.object_id = o.object_id       
where D.database_id = @dbid
order by s.avg_user_impact desc
