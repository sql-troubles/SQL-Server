/*
Description: Compressed Objects
Created: 06.10.2009
Created by: A. Nastase
Modified: 06.09.2010
Modified by: A. Nastase
Source: http://blogs.msdn.com/b/sqlserverfaq/archive/2010/09/03/how-to-identify-compressed-tables-before-restoring-migrating-database-to-any-edition-other-than-enterprise-edition-of-sql-server-2008.aspx
Notes: 
*/

SELECT  SCHEMA_NAME(o.schema_id) AS [SchemaName]  
, o.name AS [ObjectName]  
, p.[rows]
, p.[data_compression_desc]  
, p.[index_id] as [IndexID_on_Table]
FROM sys.partitions p
     JOIN sys.objects o
       ON o.object_id = o.object_id  
     JOIN sys.tables t
       ON o.object_id = t.object_id 
WHERE p.data_compression > 0  
  AND SCHEMA_NAME(o.schema_id) <> 'SYS'  
ORDER BY SchemaName, ObjectName
