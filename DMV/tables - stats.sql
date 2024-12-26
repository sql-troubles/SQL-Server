/*
Description: Tables stats
Created: 21.10.2010
Created by: A. Nastase
Modified: 21.10.2010
Modified by: A. Nastase
Source: 
Notes: 
*/ 

SELECT dps.object_id [table id]
, sch.name [schema_name]
, tbl.name [table_name]
, tbl.type_desc [table_type]
, dps.[rowCount] [rows] 
, (dps.reservedpages+ IsNull(its.reservedpages, 0)) * 8 [reserved (kb)]
, dps.pages * 8 [data (kb)]
, dps.pages/128 [data (Mb)]
, CASE WHEN dps.usedpages + IsNull(its.usedpages, 0) > pages THEN dps.usedpages + IsNull(its.usedpages, 0) - dps.pages ELSE 0 END * 8 [index_size (kb)]
, CASE WHEN dps.reservedpages + IsNull(its.reservedpages, 0) > dps.usedpages + IsNull(its.usedpages, 0) THEN dps.reservedpages + IsNull(its.reservedpages, 0) - dps.usedpages - IsNull(its.usedpages, 0) ELSE 0 END * 8 [unused (kb)]
FROM sys.tables tbl
   JOIN sys.schemas sch
     ON tbl.schema_id = sch.schema_id 
   JOIN ( -- statistics
 SELECT object_id
 , SUM (CASE
    WHEN (index_id < 2) THEN row_count
    ELSE 0
   END) [rowCount] 
 , SUM (reserved_page_count) reservedpages
    , SUM (used_page_count) usedpages
 , SUM ( CASE
    WHEN (index_id < 2) THEN (in_row_data_page_count + lob_used_page_count + row_overflow_used_page_count)
    ELSE lob_used_page_count + row_overflow_used_page_count
   END) pages
 FROM sys.dm_db_partition_stats
 --WHERE object_id = object_id ('Sales.Store')
 GROUP BY object_id
 ) dps 
   ON tbl.object_id = dps.object_id
     LEFT JOIN ( --  internal tables tied to the table
       SELECT it.parent_id object_id
        , sum(reserved_page_count) reservedpages
  , sum(used_page_count) usedpages
  FROM sys.dm_db_partition_stats p
       join sys.internal_tables it
         on  p.object_id = it.object_id
  WHERE it.internal_type IN (202,204,211,212,213,214,215,216) 
    --AND it.parent_id = object_id ('Sales.Store')
  GROUP BY it.parent_id
   ) its
    ON tbl.object_id = its.object_id
WHERE tbl.type = 'U'
ORDER BY dps.pages DESC

ORDER BY sch.name 
, tbl.name 
