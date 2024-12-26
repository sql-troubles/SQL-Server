/*
Description: cached plan - multipage allocation space size
Created by: G. Outcalt
Created: 20.09.2011
Modified by: A. Nastase
Modified: 02.08.2010
Source: http://www.sqlservercentral.com/articles/Memory/74867/
Notes: 
*/


-- cached plan - multipage allocation space size
; WITH MPAPlans 
AS (
	SELECT plan_handle
	, SUM(size_in_bytes)/1024/8 AS numPages
	FROM sys.dm_exec_cached_plans
	GROUP BY plan_handle 
)
-- MPA - cached execution plans size
SELECT ISNULL(DB_NAME(dbid), 'resourcedb') [database]
, objectid, numpages/128.0 AS size_in_mb
, size_in_bytes
, text
FROM sys.dm_exec_cached_plans cp
    JOIN MPAPlans mpa 
      ON cp.plan_handle = mpa.plan_handle
    JOIN (
		SELECT DISTINCT sql_handle, plan_handle 
		FROM sys.dm_exec_query_stats
	 ) qs 
	  ON mpa.plan_handle = qs.plan_handle
-- cross APPLY sys.dm_exec_query_plan(mpa.plan_handle) -- you could get the plan here if you wanted.
 CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle)
ORDER BY numPages DESC
