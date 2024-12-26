/*
Description: Number Records  
Created by: A. Nastase
Created: 12.08.2010
Modified by: A. Nastase
Modified: 12.08.2010
Notes: 
*/

-- number records
SELECT t.name 
, T.type
, t.max_column_id_used 
, nr.records_count
FROM sys.tables t
     JOIN sys.schemas s
       ON t.schema_id = s.schema_id 
     LEFT JOIN ( -- number records
		SELECT object_id 
		, SUM (row_count) records_count
		FROM sys.dm_db_partition_stats 
		WHERE (index_id=0 or index_id=1)
		GROUP BY object_id
	) nr
	ON t.object_id = nr.object_id 
WHERE s.name = 'dbo'
  -- AND t.object_id = object_id ('dbo.InventTable')
  and t.name like '%doc%'
ORDER BY nr.records_count DESC
