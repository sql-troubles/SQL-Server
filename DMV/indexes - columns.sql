/*
Description: Table Index Columns 
Created: 12.11.2010
Created by: A. Nastase
Modified: 25.11.2011
Modified by: A. Nastase
Source: 
Notes: 
*/ 
SELECt obj.schema_id "Schema Id"
, inc.object_id "Object Id"
, inc.index_id "Index Id"
, inc.index_column_id "Index Column Id"
, inc.column_id "column id"
, sch.name [Schema Name]
, obj.name [Table Name]
, ind.name AS [Index Name]
, col.name [Column Name]
, ind.type_desc [index type]
FROM sys.index_columns  inc
     JOIN sys.columns COL WITH (NOLOCK)
       ON inc.object_id = COL.object_id 
      AND inc.column_id = COL.column_id 
     JOIN sys.indexes AS ind WITH (NOLOCK)
       ON inc.[object_id] = ind.[object_id]
      AND inc.index_id = ind.index_id
     JOIN sys.objects AS obj WITH (NOLOCK)
       ON inc.[object_id] = obj.[object_id]
          JOIN sys.schemas sch WITH (NOLOCK)
            ON obj.schema_id = sch.schema_id
WHERE inc.object_id = object_id('INVENTTRANS')
  --AND ind.name LIKE '%'
