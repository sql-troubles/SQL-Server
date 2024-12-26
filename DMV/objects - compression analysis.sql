/*
Description: objects - compression analysis
Created: 19.10.2011
Created by: A. Nastase
Modified: 19.10.2011
Modified by: A. Nastase
Source: http://msdn.microsoft.com/en-us/library/dd894051(v=SQL.100).aspx
Notes: criteria: scan>75.00, updates <20.00
*/ 

-- objects - compression analysis
SELECT dat.[Table_Name]
, dat.[Index_Name]
, dat.[Partition]
, dat.[Index_ID]
, dat.[Index_Type]
, dat.leaf_update_count * 100.0/IsNull(dat.Operations, 1) [Percent_Update]
, dat.range_scan_count * 100.0/IsNull(dat.Operations, 1) [Percent_Scan]
, dat.Operations
FROM (
	SELECT o.name AS [Table_Name]
	, x.name AS [Index_Name]
	, i.partition_number AS [Partition]
	, i.index_id AS [Index_ID]
	, x.type_desc AS [Index_Type]
	, i.leaf_update_count
	, i.range_scan_count
	, IsNull(i.range_scan_count + i.leaf_insert_count
				+ i.leaf_delete_count + i.leaf_update_count
				+ i.leaf_page_merge_count + i.singleton_lookup_count, -1) [Operations]
	FROM sys.dm_db_index_operational_stats (db_id(), NULL, NULL, NULL) i
		 JOIN sys.objects o 
		   ON o.object_id = i.object_id
		 JOIN sys.indexes x 
		   ON x.object_id = i.object_id AND x.index_id = i.index_id
	WHERE (i.range_scan_count + i.leaf_insert_count
		   + i.leaf_delete_count + leaf_update_count
		   + i.leaf_page_merge_count + i.singleton_lookup_count) != 0
	AND objectproperty(i.object_id,'IsUserTable') = 1
) dat
--WHERE (dat.range_scan_count * 100.0/IsNull(dat.Operations, 1))>75.00
--  AND (dat.leaf_update_count * 100.0/IsNull(dat.Operations, 1)) <20.00
ORDER BY dat.[Table_Name] ASC
