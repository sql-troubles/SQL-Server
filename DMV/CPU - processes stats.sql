/*
Description: CPU - Processes Stats 
Created by: 
Created: 
Modified by: A. Nastase
Modified: 28.06.2013
Notes: 
Source: 
*/

declare @ts_now bigint;
select 
	@ts_now = ms_ticks 
from sys.dm_os_sys_info;

select top 1
	--record_id, 
	--dateadd (ms, (y.[timestamp] -@ts_now), GETDATE()) as EventTime,
	SQLProcessUtilization as SqlProcessCpu, 
	SystemIdle as SystemIdleCpu, 
	100 - SystemIdle - SQLProcessUtilization as OtherProcessesCpu
from 
( 
	select 
	record.value('(./Record/@id)[1]', 'int') as record_id, 
	record.value('(./Record/SchedulerMonitorEvent/SystemHealth/SystemIdle)[1]', 'int') 
	as SystemIdle, 
	record.value('(./Record/SchedulerMonitorEvent/SystemHealth/ProcessUtilization)[1]', 
	'int') as SQLProcessUtilization, 
	timestamp 
	from ( 
		select timestamp, convert(xml, record) as record 
		from sys.dm_os_ring_buffers 
		where ring_buffer_type = N'RING_BUFFER_SCHEDULER_MONITOR' 
		and record like '%<SystemHealth>%'
	) as x 
) as y 
order by record_id desc;
