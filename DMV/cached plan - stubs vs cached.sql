/*
Description: cached plan statistics
Created by: B. Beauchemin
Created: 09.06.2008
Modified by: 
Modified: 
Source: http://www.sqlskills.com/BLOGS/BOBB/post/Performance-features-in-SQL-Server-2008-RC0-Optimize-for-Adhoc-Workloads.aspx
Notes: 
*/

-- stub for the non-parameterized version, plan for the parameterized version
SELECT usecounts, cacheobjtype, objtype, [text]
FROM sys.dm_exec_cached_plans P
   CROSS APPLY sys.dm_exec_sql_text(plan_handle)
   WHERE [text] NOT LIKE '%dm_exec%'
ORDER BY p.usecounts DESC


-- query plan for stub query handle is not saved returns NULL
SELECT sql.text, p.query_plan 
FROM sys.dm_exec_query_stats AS qs 
CROSS APPLY sys.dm_exec_sql_text(sql_handle) sql
CROSS APPLY sys.dm_exec_query_plan(plan_handle) p
WHERE text NOT LIKE '%sys_dm_exec%' AND text NOT LIKE '%msparam_0%'
ORDER BY qs.EXECUTION_COUNT DESC
go 
