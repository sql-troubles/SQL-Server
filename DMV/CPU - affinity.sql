/*
Description: processor affinity, NUMA node and processor group information
Created by: G. Berry
Created: ?
Modified by: A. Nastase
Modified: 04.08.2010
Source: adapted after http://www.sqlservercentral.com/blogs/glennberry/archive/2010/05/11/some-new-dmv-queries-for-sql-server-2008-r2.aspx
Notes:      
*/

-- SQL Server 2008 version
SELECT mn.memory_node_id
, CAST(osn.cpu_affinity_mask AS BINARY(8)) AS [CPUMask]
, osn.online_scheduler_count
, osn.active_worker_count
, mn.virtual_address_space_committed_kb
, mn.virtual_address_space_reserved_kb
, mn.shared_memory_committed_kb
, mn.shared_memory_reserved_kb
, osn.avg_load_balance 
FROM sys.dm_os_memory_nodes AS mn
     JOIN sys.dm_os_nodes AS osn
       ON mn.memory_node_id = osn.memory_node_id
WHERE osn.node_state_desc NOT LIKE '%DAC%'
ORDER BY osn.cpu_affinity_mask;

-- SQL Server 2008 R2 Only version
SELECT mn.memory_node_id,
CAST(osn.cpu_affinity_mask AS BINARY(8)) AS [CPUMask],
CAST(osn.online_scheduler_mask AS BINARY(8)) AS [OnlineSchedulerMask]
, osn.online_scheduler_count
, osn.active_worker_count
, osn.processor_group
FROM sys.dm_os_memory_nodes AS mn
     JOIN sys.dm_os_nodes AS osn
       ON mn.memory_node_id = osn.memory_node_id
WHERE osn.node_state_desc NOT LIKE '%DAC%'
ORDER BY osn.processor_group, osn.cpu_affinity_mask;
