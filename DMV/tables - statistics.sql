/*
Description: tables - statistics
Created by: P. Dave
Created: 
Modified by: A. Nastase
Modified: 31.03.2015
Source: http://blog.sqlauthority.com/2011/06/29/sql-server-find-details-for-statistics-of-whole-database-dmv-t-sql-script/
Notes: 
*/

-- tables - statistics
SELECT DISTINCT obj.name AS TableName
, c.name AS ColumnName
, s.name AS StatName
, s.auto_created
, s.user_created
, s.no_recompute
, s.[object_id]
, s.stats_id
, sc.stats_column_id
, sc.column_id
, STATS_DATE(s.[object_id], s.stats_id) AS LastUpdated
FROM sys.stats s 
     JOIN sys.stats_columns sc 
       ON sc.[object_id] = s.[object_id] 
      AND sc.stats_id = s.stats_id
     JOIN sys.columns c 
       ON c.[object_id] = sc.[object_id] 
       AND c.column_id = sc.column_id
     JOIN sys.partitions par 
      ON par.[object_id] = s.[object_id]
     JOIN sys.objects obj 
       ON par.[object_id] = obj.[object_id]
WHERE OBJECTPROPERTY(s.OBJECT_ID,'IsUserTable') = 1
AND (s.auto_created = 1 OR s.user_created = 1)
AND s.[object_id] = object_id('dbo.inventtable')
