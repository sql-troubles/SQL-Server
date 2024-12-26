/*
Description: objects - page compression
Created: 19.10.2011
Created by: A. Nastase
Modified: 19.10.2011
Modified by: A. Nastase
Source: http://msdn.microsoft.com/en-us/library/dd894051(v=SQL.100).aspx
Notes: in White Paper the join constraints are not correct (duplicated returned). the query was corrected.
*/ 

--objects - page compression
SELECT o.name
, ips.index_type_desc
, p.partition_number
, p.data_compression_desc
, ips.page_count
, ips.compressed_page_count
FROM sys.dm_db_index_physical_stats (DB_ID(), object_id('dbo.ActiveSubscriptions'), NULL, NULL, 'DETAILED') ips
     JOIN sys.objects o 
       ON o.object_id = ips.object_id
     JOIN sys.partitions p 
       ON ips.object_id = p.object_id
      AND ips.index_id = p.index_id 
      AND ips.partition_number = p.partition_number 
