/*
Description: Find single-use, ad-hoc queries that are bloating the plan cache
Created by: G. Berry
Created: ?
Modified by: A. Nastase
Modified: 02.08.2010
Notes: Gives you the text and size of single-use ad-hoc queries that waste space in plan cache
-- Enabling 'optimize for ad hoc workloads' for the instance can help (SQL Server 2008 only)
-- Enabling forced parameterization for the database can help 
*/

SELECT TOP(100) [text]
, cp.size_in_bytes
, usecounts use_counts
, refcounts reference_counts
, objtype object_type
, cacheobjtype cache_object_type
FROM sys.dm_exec_cached_plans AS cp
     CROSS APPLY sys.dm_exec_sql_text(plan_handle) 
WHERE cp.cacheobjtype = N'Compiled Plan' 
  AND cp.objtype = N'Adhoc' 
  --AND cp.usecounts = 1
ORDER BY cp.size_in_bytes DESC;

SELECT *
FROM sys.dm_exec_cached_plans AS cp
