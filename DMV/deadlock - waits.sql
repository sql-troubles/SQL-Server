/*
Description: deadlock waits
Created by: ?
Created: 10.06.2011
Modified by: A. Nastase
Modified: 10.06.2011
Source: Performance Analyzer (CreateDynamicsPerfObjects.sql)
Notes: 
*/

-- deadlock waits
SELECT WAIT.blocking_session_id
, WAIT.session_id
, Rtrim(CONVERT(NVARCHAR(MAX), BLOCKED.context_info)) BlockedContext
, CASE BLOCKED.transaction_isolation_level
     WHEN 1 THEN 'Read Uncommitted'
     WHEN 2 THEN 'Read Committed'
     WHEN 3 THEN 'Repeatable Read'
     WHEN 4 THEN 'Serializable'
     WHEN 5 THEN 'Snapshot'
     ELSE Str(BLOCKED.transaction_isolation_level)
  END transaction_isolation_level
, WAIT.wait_duration_ms
, WAIT.wait_type
, CASE
     WHEN resource_description LIKE 'objectlock%' THEN 'Object'
     WHEN resource_description LIKE 'pagelock%' THEN 'Page'
     WHEN resource_description LIKE 'keylock%' THEN 'Key'
     WHEN resource_description LIKE 'ridlock%' THEN 'Row'
     ELSE 'N/A'
 END resource_description
, Db_name(BLOCKED.database_id)
, CASE
     WHEN resource_description LIKE '%associatedObjectId%' THEN CONVERT(BIGINT, Substring ( resource_description, Charindex('associatedObjectId=', resource_description)+19, (Len(resource_description)+1)-(Charindex('associatedObjectId=', resource_description)+19)))
     ELSE 0
  END AssociatedObject
, BLOCKEDSQL.TEXT
, BLOCKEDPLAN.query_plan
FROM   sys.dm_os_waiting_tasks WAIT
       JOIN sys.dm_exec_requests AS BLOCKED
         ON WAIT.session_id = BLOCKED.session_id
       OUTER APPLY sys.Dm_exec_sql_text(BLOCKED.sql_handle) AS BLOCKEDSQL
       OUTER APPLY sys.Dm_exec_query_plan(BLOCKED.plan_handle) AS BLOCKEDPLAN
WHERE  WAIT.wait_type LIKE 'LCK%' 
--AND			database_id = db_id()
