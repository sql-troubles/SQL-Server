/*
Description: deadlock details
Created by: J. Kehayias
Created: 23.02.2009
Modified by: A. Nastase
Modified: 23.02.2009
Source: http://www.sqlservercentral.com/articles/deadlock/65658/
Notes: works only for SQL Server 2008
for details see the source article
*/

--Deadlock details
;WITH CTE(EventName, DeadlockTime, DeadlockGraph) 
AS ( -- deadlock data
SELECT XEventData.XEvent.value('(./@name)', 'varchar(1000)') as EventName
, XEventData.XEvent.value( '(./@timestamp)', 'DATETIME') AS DeadlockTime
, CAST(
			REPLACE(
				REPLACE(XEventData.XEvent.value('(data/value)[1]', 'varchar(max)'), 
				'<victim-list>', '<deadlock><victim-list>'),
			'<process-list>','</victim-list><process-list>')
		as xml) as DeadlockGraph
FROM
( -- retrieving session targets 
	SELECT CAST(Replace(Replace(target_data ,'<value>', '<value><![CDATA['),'</value>', ']]></value>') as xml) as TargetData
	FROM sys.dm_xe_session_targets st
		 JOIN sys.dm_xe_sessions s on s.address = st.event_session_address
	WHERE name = 'system_health'
) AS Data
CROSS APPLY TargetData.nodes ('//RingBufferTarget/event') AS XEventData (XEvent)
WHERE XEventData.XEvent.value('@name', 'varchar(4000)') = 'xml_deadlock_report'
)
SELECT DeadlockTime
--, EventName
, DeadlockGraph.value('(//@spid)[1]', 'varchar(50)') spid1
, DeadlockGraph.value('(//inputbuf)[1]', 'varchar(max)') query1
, DeadlockGraph.value('(//@lockMode)[1]', 'varchar(50)') lockMode1
, DeadlockGraph.value('(//@spid)[2]', 'varchar(50)') spid2
, DeadlockGraph.value('(//inputbuf)[2]', 'varchar(max)') query2
, DeadlockGraph.value('(//@lockMode)[2]', 'varchar(50)') lockMode2
, DeadlockGraph
FROM CTE
ORDER BY DeadlockTime DESC




