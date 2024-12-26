/*
Description: CPU - NUMA Node Imbalance
Created by: A. Nastase
Created: 
Modified by: A. Nastase
Modified: 02.10.2015
Notes: 
Source: http://blogs.msdn.com/b/sqlcan/archive/2015/10/01/sql-server-2012-numa-node-imbalance-cont-d.aspx
*/


select session_id, wait_type, wait_time, cpu_time, scheduler_id 
  from sys.dm_exec_requests 
where command = 'lazy writer' 
order by scheduler_id
