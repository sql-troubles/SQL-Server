/*
Description: tempdb - page allocation
Created by: 
Created: ?
Modified by: A. Nastase
Modified: 26.09.2011
Source: http://mssqlwiki.com/2010/01/13/how-to-monitor-the-session-and-query-which-consumes-tempdb/
Notes:  developed for SQL Server 2005 (cpu_ticks_in_ms is not available in 2008)
  requires to enable trace flag 1106, not recommended in production servers because affects SQL Server's performance!
  for 2005 should be considered also the following FIX: http://support.microsoft.com/default.aspx?scid=kb;EN-US;947204
*/




SELECT record.value('(Record/@id)[1]', 'int') AS record_id
--, CONVERT (varchar, DATEADD (ms, -1 * ((inf.cpu_ticks / inf.cpu_ticks_in_ms) - [timestamp]), GETDATE()), 126) AS EventTime -- work only on SQL Server 2005
, [timestamp] 
, record.value('(Record/@id)[1]', 'int') AS RingBuffer_Record_Id
, record.value('(Record/ALLOC/Event)[1]', 'int') AS AllocationEventType
, record.value('(Record/ALLOC/SpId)[1]', 'int') AS SpId
, record.value('(Record/ALLOC/EcId)[1]', 'int') AS EcId
, record.value('(Record/ALLOC/PageId)[1]', 'nvarchar(50)') AS AllocatedPageId
, record.value('(Record/ALLOC/AuId)[1]', 'nvarchar(50)') AS AllocationUnitId
, record.value('(Record/ALLOC/LsId)[1]', 'nvarchar(50)') AS LsId
FROM sys.dm_os_sys_info inf 
     CROSS JOIN (
		SELECT timestamp, CONVERT (xml, record) AS record 
		FROM sys.dm_os_ring_buffers 
		WHERE ring_buffer_type = 'RING_BUFFER_ALLOC_TRACE'
		AND ( record LIKE '%<Event>23</Event>%' -- uniform extent allocation
		OR record LIKE '%<Event>22</Event>%' -- uniform extent deallocation
		OR record LIKE '%<Event>24</Event>%' -- mixed extent allocation
		OR record LIKE '%<Event>25</Event>%' -- mixed extent deallocation
		OR record LIKE '%<Event>10</Event>%' -- page allocation
		OR record LIKE '%<Event>11</Event>%' -- page deallocation
		)
     ) AS t
ORDER BY record.value('(Record/@id)[1]', 'int') ASC 
