/*
Description: Index Fragmentation Statistics
Created by: A. Nastase
Created: 25.08.2010
Modified by: A. Nastase
Modified: 25.08.2010
Notes: Are considered only the indexes having page_count>0 for current database 
*/

SELECT DB_NAME(IPS.DATABASE_ID) AS [DatabaseName]
, IPS.INDEX_TYPE_DESC AS IndexType
, COUNT(1) IndexesCount
, SUM(CASE WHEN IPS.AVG_FRAGMENTATION_IN_PERCENT>=0 AND IPS.AVG_FRAGMENTATION_IN_PERCENT < 10 THEN 1 ELSE 0 END) AvgFragmentation0_10
, SUM(CASE WHEN IPS.AVG_FRAGMENTATION_IN_PERCENT>=10 AND IPS.AVG_FRAGMENTATION_IN_PERCENT < 30 THEN 1 ELSE 0 END) AvgFragmentation10_30
, SUM(CASE WHEN IPS.AVG_FRAGMENTATION_IN_PERCENT>=30 AND IPS.AVG_FRAGMENTATION_IN_PERCENT < 80 THEN 1 ELSE 0 END) AvgFragmentation30_80
, SUM(CASE WHEN IPS.AVG_FRAGMENTATION_IN_PERCENT>=80 AND IPS.AVG_FRAGMENTATION_IN_PERCENT < 90 THEN 1 ELSE 0 END) AvgFragmentation80_90
, SUM(CASE WHEN IPS.AVG_FRAGMENTATION_IN_PERCENT>=90 AND IPS.AVG_FRAGMENTATION_IN_PERCENT <= 100 THEN 1 ELSE 0 END) AvgFragmentation90_100
FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL , NULL, N'LIMITED') IPS
     JOIN sys.tables TBL WITH (nolock)
       ON IPS.object_id = TBL.object_id 
          JOIN sys.schemas SCH WITH (nolock)
            ON TBL.schema_id = SCH.schema_id 
WHERE SCH.name = 'dbo'
  AND IPS.page_count >0
GROUP BY IPS.DATABASE_ID
, IPS.INDEX_TYPE_DESC 
