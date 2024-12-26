/*
Description: Table Index Columns 
Created: 07.08.2015
Created by: A. Nastase
Modified: 07.08.2015
Modified by: A. Nastase
Source: 
Notes: 
*/ 


SELECT --obj.schema_id "Schema Id"
--, inc.object_id "Object Id"
--, inc.index_id "Index Id"
 sch.name [Schema Name]
, obj.name [Table Name]
, ind.name AS [Index Name]
, ind.type_desc [index type]
FROM sys.indexes AS ind WITH (NOLOCK)
     JOIN sys.objects AS obj WITH (NOLOCK)
       ON ind.[object_id] = obj.[object_id]
          JOIN sys.schemas sch WITH (NOLOCK)
            ON obj.schema_id = sch.schema_id
WHERE ind.object_id = object_id('INVENTTRANS')
