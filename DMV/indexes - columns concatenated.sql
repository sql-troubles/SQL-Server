/*
Description: indexes pro table - the indexex are concatenated 
Created: 22.03.2016
Created by: A. Nastase 
Modified: 22.03.2016
Modified by: A. Nastase 
Source: http://www.sqlservercentral.com/articles/Indexing/110106/
Notes: 
*/ 

SELECT QuoteName(sch.name) + '.' + QuoteName(obj.name) [table_name]
, ind.name [index_name]
, ind.type_desc [index type]
, STUFF((SELECT  ', ' + col.name + ' ' + CASE WHEN inc.is_descending_key = 1 THEN 'DESC' ELSE 'ASC' END -- Include column order (ASC / DESC)
       FROM sys.index_columns inc WITH (NOLOCK)
            JOIN sys.columns COL WITH (NOLOCK)
              ON inc.object_id = COL.object_id 
             AND inc.column_id = COL.column_id 
        WHERE ind.object_id = inc.object_id
          AND ind.index_id = inc.index_id
          AND inc.is_included_column = 0
        ORDER BY inc.key_ordinal
        FOR XML PATH('')), 1, 2, '') AS key_column_list 
, STUFF((SELECT  ', ' + col.name + ' ' + CASE WHEN inc.is_descending_key = 1 THEN 'DESC' ELSE 'ASC' END -- Include column order (ASC / DESC)
       FROM sys.index_columns inc WITH (NOLOCK)
            JOIN sys.columns COL WITH (NOLOCK)
              ON inc.object_id = COL.object_id 
             AND inc.column_id = COL.column_id 
        WHERE ind.object_id = inc.object_id
          AND ind.index_id = inc.index_id
          AND inc.is_included_column = 1
        ORDER BY inc.key_ordinal
        FOR XML PATH('')), 1, 2, '') AS included_column_list 
, ind.filter_definition 
, ind.is_disabled 
FROM sys.indexes AS ind WITH (NOLOCK)
     JOIN sys.objects AS obj WITH (NOLOCK)
       ON ind.[object_id] = obj.[object_id]
          JOIN sys.schemas sch WITH (NOLOCK)
            ON obj.schema_id = sch.schema_id
WHERE obj.is_ms_shipped = 0
  AND ind.type_desc IN ('NONCLUSTERED', 'CLUSTERED')
  AND ind.object_id = object_id('')
ORDER BY sch.name
, obj.name
, key_column_list
, included_column_list
