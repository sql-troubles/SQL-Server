/*
Description: CPU - Usage 
Created by: 
Created: 
Modified by: A. Nastase
Modified: 28.06.2013
Notes: 
Source: 
*/

;with ResPoolCpu as
(
	select
		instance_name as pool_name,
		counter_name,
		cntr_value
	from sys.dm_os_performance_counters
	where object_name like '%Resource Pool Stats%'
	and counter_name like 'CPU usage *% %' escape '*'
	and instance_name not like 'internal%'
),
ResPoolCpuTotal as
(
	select
		rcp1.pool_name,
		--rcp1.counter_name,
		convert
		(
			decimal(5, 2), 
			(rcp1.cntr_value * 1.0 / rcp2.cntr_value) * 100
		) as cpu_usage
	from ResPoolCpu rcp1
	inner join ResPoolCpu rcp2
	on rcp1.pool_name = rcp2.pool_name
	where rcp1.counter_name not like '%base%'
	and rcp2.counter_name like '%base%'
)
select
	rpct.pool_name,
	rpct.cpu_usage,
	dmrp.min_cpu_percent,
	dmrp.max_cpu_percent--,
	--dmrp.cap_cpu_percent
from ResPoolCpuTotal rpct
inner join sys.dm_resource_governor_resource_pools dmrp
on rpct.pool_name = dmrp.name;
