/*
Description: extended events sessions
Created: 19.01.2010
Created by: J. Kehayias
Modified: 19.01.2010
Modified by: A. Nastase
Source: http://msdn.microsoft.com/en-us/library/dd822788.aspx
Notes: 
Warnings: 
*/ 

SELECT name
, event_retention_mode_desc  event_retention_mode
, max_dispatch_latency
, max_memory
, max_event_size
, memory_partition_mode_desc memory_partition_mode
, track_causality
, startup_state
FROM sys.server_event_sessions
WHERE name = 'system_health'

SELECT package
, e.name
, predicate
, ( --events session action
	SELECT package + '.' + name + ', '
	FROM sys.server_event_session_actions a
	WHERE a.event_session_id = e.event_session_id
	  AND a.event_id = e.event_id
	ORDER BY package, name
	FOR XML PATH('')
) AS Actions
FROM sys.server_event_session_events e
     JOIN sys.server_event_sessions es 
       ON e.event_session_id = es.event_session_id
WHERE es.name = 'system_health';

SELECT package
, t.name
, (
	SELECT name + '=' + cast(value AS varchar) + ', '
	FROM sys.server_event_session_fields f
	WHERE f.event_session_id = t.event_session_id
	  AND f.object_id = t.target_id
	FOR XML PATH('')
) AS options
FROM sys.server_event_session_targets t
     JOIN sys.server_event_sessions es 
       ON t.event_session_id = es.event_session_id
WHERE es.name = 'system_health';
