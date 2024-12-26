/*
Description: Breaks down buffers used by current database by object (table, index) in the buffer cache
Created by: G. Berry
Created: ?
Modified by: A. Nastase
Modified: 02.08.2010
Notes: Tells you what tables and indexes are using the most memory in the buffer cache
*/

SELECT OBJECT_NAME(p.[object_id]) AS [ObjectName]
, p.index_id
, COUNT(*)/128 AS [Buffer size(MB)]
, COUNT(*) AS [BufferCount]
, p.data_compression_desc AS [CompressionType]
FROM sys.allocation_units AS a
     JOIN sys.dm_os_buffer_descriptors AS b
       ON a.allocation_unit_id = b.allocation_unit_id
     JOIN sys.partitions AS p
       ON a.container_id = p.hobt_id
WHERE b.database_id = DB_ID()
AND p.[object_id] > 100
GROUP BY p.[object_id], p.index_id, p.data_compression_desc
ORDER BY [BufferCount] DESC;


