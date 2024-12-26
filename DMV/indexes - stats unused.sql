/*
Description: indexes - stats unused
Created by: A. Nastase
Created: 10.05.2013
Modified by: A. Nastase
Modified: 10.05.2013
Notes: adapted after http://blogs.msdn.com/b/turgays/archive/2013/05/08/how-to-find-unused-statistics.aspx
*/

-- indexes - stats unused
SELECT OBJECT_NAME(id) as TableName
, s.name as StatsName
, s.auto_created
, rowmodctr as UpdatedRowCount
, case rct.TableRowCount when 0 then 0 else i.rowmodctr*1./rct.TableRowCount end as UpdatedPercentage
, STATS_DATE(i.id,i.indid) as StatsLastUpdatedTime
FROM sysindexes i
     LEFT JOIN sys.stats s 
       ON s.object_id = i.id 
      AND s.stats_id = i.indid
     OUTER APPLY ( -- record count
		 SELECT SUM(row_count) TableRowCount
		 FROM sys.dm_db_partition_stats 
		 WHERE object_id = i.id 
		   and (index_id=0 or index_id=1)
      ) rct
WHERE rct.TableRowCount != 0
ORDER BY UpdatedPercentage DESC
