/*
Description: index fragmentation
Created by: A. Nastase
Created: 19.10.2010
Modified by: A. Nastase
Modified: 19.10.2010
Notes: 
*/ 

-- f r eine Tabelle, sehen Sie OBJECT_ID('dbo.SYSCOMPANYUSERINFO')
declare @dbid int
select @dbid = db_id()

SELECT IPS.object_id [Object Id]
--, obj.schema_id [Schema Id]
, ips.index_id [Index Id]
, sch.name [Schema Name]
, obj.name [Table Name]
, ind.name [Index Name]
, ind.type_desc [Index Type]
, ind.is_unique 
, ind.is_primary_key
, STATS_DATE(ind.[object_id], ind.index_id) [Statistics Date]
, cast(ips.avg_fragmentation_in_percent as decimal(7,2)) [Average Fragmentations (%)]
, cast(ips.avg_fragment_size_in_pages as decimal(7,2))  [Average Fragment size (pages)]
, ips.fragment_count [Fragment Count]
, ips.page_count [Page Count]
FROM sys.dm_db_index_physical_stats(@dbid, OBJECT_ID('dbo.LedgerTrans'), NULL, NULL, NULL) ips
     JOIN sys.objects AS obj WITH (NOLOCK)
       ON ips.object_id = obj.object_id 
          JOIN sys.schemas sch
           ON obj.schema_id = sch.schema_id
     JOIN sys.indexes AS ind WITH (NOLOCK)
       ON ips.[object_id] = ind.[object_id]
      AND ips.index_id = ind.index_id 
WHERE ind.type in (1,2)
  --AND DateDiff(D, '2010-10-19', STATS_DATE(ind.[object_id], ind.index_id))<>0
  --AND ips.avg_fragmentation_in_percent  !=0
  AND ips.alloc_unit_type_desc = 'IN_ROW_DATA'
ORDER BY  obj.name 
, ind.index_id 



-- f r alle Tabellen
declare @dbid int
select @dbid = db_id()

SELECT IPS.object_id [Object Id]
--, obj.schema_id [Schema Id]
, ips.index_id [Index Id]
, sch.name [Schema Name]
, obj.name [Table Name]
, ind.name [Index Name]
, ind.type_desc [Index Type]
, ind.is_unique 
, ind.is_primary_key
, STATS_DATE(ind.[object_id], ind.index_id) [Statistics Date]
, cast(ips.avg_fragmentation_in_percent as decimal(7,2)) [Average Fragmentations (%)]
, cast(ips.avg_fragment_size_in_pages as decimal(7,2))  [Average Fragment size (pages)]
, ips.fragment_count [Fragment Count]
, ips.page_count [Page Count]
FROM sys.dm_db_index_physical_stats(@dbid, NULL, NULL, NULL, NULL) ips
     JOIN sys.objects AS obj WITH (NOLOCK)
       ON ips.object_id = obj.object_id 
          JOIN sys.schemas sch
           ON obj.schema_id = sch.schema_id
     JOIN sys.indexes AS ind WITH (NOLOCK)
       ON ips.[object_id] = ind.[object_id]
      AND ips.index_id = ind.index_id 
WHERE ind.type in (1,2)
  --AND DateDiff(D, '2010-10-19', STATS_DATE(ind.[object_id], ind.index_id))<>0
  --AND ips.avg_fragmentation_in_percent  !=0
  AND ips.alloc_unit_type_desc = 'IN_ROW_DATA'
ORDER BY  obj.name 
, ind.index_id 
