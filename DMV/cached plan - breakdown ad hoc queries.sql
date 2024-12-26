/*
Description: Find single-use, ad-hoc queries that are bloating the plan cache
Created by: SQL Server Books Online
Created: ?
Modified by: A. Nastase
Modified: 02.08.2010
Notes: Gives you the text and size of single-use ad-hoc queries that waste space in plan cache
-- Enabling 'optimize for ad hoc workloads' for the instance can help (SQL Server 2008 only)
-- Enabling forced parameterization for the database can help 
*/

SELECT top (100) [text]
--, ecp.plan_handle
--, ecp.memory_object_address AS CompiledPlan_MemoryObject
, omo.memory_object_address
, ecp.size_in_bytes
, omo.pages_allocated_count
, omo.type
, omo.page_size_in_bytes 
FROM sys.dm_exec_cached_plans AS ecp 
    JOIN sys.dm_os_memory_objects AS omo 
      ON ecp.memory_object_address = omo.memory_object_address 
      OR ecp.memory_object_address = omo.parent_address
     CROSS APPLY sys.dm_exec_sql_text(plan_handle) 
WHERE cacheobjtype = 'Compiled Plan'
  AND ecp.objtype = N'Adhoc' 
  --AND ecp.usecounts = 1
--ORDER BY ecp.size_in_bytes DESC;
ORDER BY omo.pages_allocated_count DESC;
