/*
Description: retrieves the CPU Utilization History for last 30 minutes (in one minute intervals)
Created by: G. Berry
Created: ?
Modified by: A. Nastase
Modified: 02.08.2010
Notes: works with SQL Server 2008 and SQL Server 2008 R2 only, for 2005 version check http://www.sqlservercentral.com/blogs/glennberry/archive/2010/04/21/a-dmv-a-day-_1320_-day-21.aspx
       it can be used to show only statistics for max 256 min = about 4 hours
     
*/

DECLARE @ts_now bigint = (SELECT cpu_ticks/(cpu_ticks/ms_ticks)
        FROM sys.dm_os_sys_info); 

SELECT SQLProcessUtilization AS [SQL Server Process CPU Utilization]
, SystemIdle AS [System Idle Process]
, 100 - SystemIdle - SQLProcessUtilization AS [Other Process CPU Utilization]
, DATEADD(ms, -1 * (@ts_now - [timestamp]), GETDATE()) AS [Event Time] 
, AVG(SQLProcessUtilization) OVER(PARTITION BY 1) AS [Average SQL Server Process CPU Utilization]
, AVG(SystemIdle) OVER(PARTITION BY 1) AS [Average System Idle Process]
, AVG(100 - SystemIdle - SQLProcessUtilization) OVER(PARTITION BY 1) AS [Average SQL Server Process CPU Utilization]
FROM ( 
	SELECT record.value('(./Record/@id)[1]', 'int') AS record_id
	, record.value('(./Record/SchedulerMonitorEvent/SystemHealth/SystemIdle)[1]', 'int') AS [SystemIdle] 
	, record.value('(./Record/SchedulerMonitorEvent/SystemHealth/ProcessUtilization)[1]', 'int')AS [SQLProcessUtilization]
	, [timestamp] 
	FROM ( 
		SELECT [timestamp]
		, CONVERT(xml, record) AS [record] 
		FROM sys.dm_os_ring_buffers 
		WHERE ring_buffer_type = N'RING_BUFFER_SCHEDULER_MONITOR' 
		  AND record LIKE N'%<SystemHealth>%') AS x 
	) AS y 
ORDER BY record_id DESC;
