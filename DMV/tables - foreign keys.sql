/*
Description: tables - foreign keys 
Created by: A. Nastase
Created: 28.02.2012
Modified by: A. Nastase
Modified: 28.02.2012
Source: http://lostechies.com/jimmybogard/2008/11/27/viewing-all-foreign-key-constraints-in-sql-server/
Notes:      
*/


-- tables - foreign keys
SELECT f.name AS ForeignKey 
, OBJECT_NAME(f.parent_object_id) AS TableName
, COL_NAME(fc.parent_object_id, fc.parent_column_id) AS ColumnName
, OBJECT_NAME (f.referenced_object_id) AS ReferenceTableName
, COL_NAME(fc.referenced_object_id, fc.referenced_column_id) AS ReferenceColumnName 
FROM sys.foreign_keys AS f 
     JOIN sys.foreign_key_columns AS fc 
       ON f.OBJECT_ID = fc.constraint_object_id
