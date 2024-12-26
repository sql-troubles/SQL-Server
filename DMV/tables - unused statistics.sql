/*
Description: tables - unused statistics
Created by: Turgay Sahtiyan
Created: 08.05.2013
Modified by: A. Nastase
Modified: 31.03.2015
Source: http://blogs.msdn.com/b/turgays/archive/2013/05/08/how-to-find-unused-statistics.aspx
Notes: 
*/

select OBJECT_NAME(id) as TableName
, s.name as StatsName
, s.auto_created
, i.rowmodctr as UpdatedRowCount
, ps.TableRowCount 
, case ps.TableRowCount when 0 then 0 else i.rowmodctr*1./ps.TableRowCount end as UpdatedPercentage
, STATS_DATE(i.id,i.indid) as StatsLastUpdatedTime
from sysindexes i
     left join sys.stats s 
       on s.object_id=i.id and s.stats_id=i.indid
     cross apply (
     select SUM(row_count) TableRowCount
     from sys.dm_db_partition_stats 
     where object_id=i.id and (index_id=0 or index_id=1)
    ) ps
order by UpdatedPercentage desc 
