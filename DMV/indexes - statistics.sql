/*
Description: Index Statistics
Created: 18.10.2010
Created by: A. Nastase
Modified: 18.10.2010
Modified by: A. Nastase
Source: adapted after http://www.sqlservercentral.com/blogs/glennberry/archive/2010/8/30/how-old-are-your-database-statistics_3F00_.aspx
Notes: 
*/ 
SELECT o.schema_id "Schema Id"
, o.object_id "Object Id"
, sch.name [Schema Name]
, o.name
, i.name AS [Index Name]
, STATS_DATE(i.[object_id], i.index_id) AS [Statistics Date]
, s.auto_created
, s.no_recompute
, s.user_created
, i.fill_factor 
FROM sys.objects AS o WITH (NOLOCK)
     JOIN sys.schemas sch WITH (NOLOCK)
       ON o.schema_id = sch.schema_id
     JOIN sys.indexes AS i WITH (NOLOCK)
       ON o.[object_id] = i.[object_id]
     JOIN sys.stats AS s WITH (NOLOCK)
       ON i.[object_id] = s.[object_id] 
     AND i.index_id = s.stats_id
WHERE o.[type] = 'U'
  AND sch.name = 'dbo'
 AND o.name = 'TaxTrans'
ORDER BY [Statistics Date] ASC; 



SELECT o.object_id [Id]
, sch.name [Schema]
, o.name [Tabelle]
, i.name AS [Index]
, i.type_desc [Indexart]
, Cast(STATS_DATE(i.[object_id], i.index_id) as Date) AS [Datum Statistik]
, i.fill_factor [F llungsfaktor]
FROM sys.objects AS o WITH (NOLOCK)
     JOIN sys.schemas sch WITH (NOLOCK)
       ON o.schema_id = sch.schema_id
     JOIN sys.indexes AS i WITH (NOLOCK)
       ON o.[object_id] = i.[object_id]
     JOIN sys.stats AS s WITH (NOLOCK)
       ON i.[object_id] = s.[object_id] 
     AND i.index_id = s.stats_id
WHERE o.[type] = 'U'
  AND sch.name = 'dbo'
ORDER BY sch.name 
, o.name
, i.name 
