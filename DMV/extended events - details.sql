/*
Description: event data 
Created by: P.Nielsen, M. White, U. Parui
Modified: 
Modified by: 
Source: Microsoft SQL Server 2008 Bible
Notes: 
*/

SELECT node.event_data.value('(data/value)[1]', 'BIGINT') AS source_database_id
, node.event_data.value('(timestamp)[1]', 'Datetime') AS test
FROM (--
   SELECT CONVERT(XML, st.target_data) as ring_buffer
   FROM sys.dm_xe_sessions s
        JOIN sys.dm_xe_session_targets st
          ON s.address = st.event_session_address
   WHERE name = 'wait_info') as sq
   CROSS APPLY sq.ring_buffer.nodes('//RingBufferTarget/event') node(event_data)
