/*
Description: Object Definitions 
Created by: A. Nastase
Created: 16.08.2010
Modified by: A. Nastase
Modified: 16.08.2010
Notes: 
*/

SELECT sql.object_id 
, s.name [schema_name]
, obj.name [object_name]
, obj.type
, obj.type_desc 
, obj.modify_date
, sql.definition
FROM sys.all_sql_modules sql
     JOIN sys.all_objects obj
       ON sql.object_id = obj.object_id 
          JOIN sys.schemas s
            ON obj.schema_id = s.schema_id 
WHERE obj.type = 'V'
  AND s.name = 'dbo'
