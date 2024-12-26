/*
Description: retrieving objects' definition for INFORMATION_SCHEMA 
Created: 09.08.2010
Created by: A. Nastase
Modified: 09.08.2010
Modified by: A. Nastase
Source: http://sql-troubles.blogspot.com/2010/08/sql-server-2008-information-schema.html
Notes: 
*/

SELECT s.name [schema_name] 
, o.name [object_name] 
, sm.definition 
FROM sys.all_sql_modules sm 
    JOIN sys.all_objects o 
       ON sm.object_id = o.object_id 
   JOIN sys.schemas s 
      ON o.schema_id = s.schema_id 
WHERE s.name = 'INFORMATION_SCHEMA'
ORDER BY o.name 
