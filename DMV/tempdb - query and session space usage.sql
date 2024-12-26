/*
Description: tempdb - query and session space usage
Created by: P.K. Karthick
Created: 13.01.2010
Modified by: A. Nastase
Modified: 26.09.2011
Source: http://mssqlwiki.com/2010/01/13/how-to-monitor-the-session-and-query-which-consumes-tempdb/
Notes: 
*/

--tempdb - query and session space usage
SELECT R1.session_id, R1.request_id
, R1.Task_request_internal_objects_alloc_page_count
, R1.Task_request_internal_objects_dealloc_page_count
, R1.Task_request_user_objects_alloc_page_count
, R1.Task_request_user_objects_dealloc_page_count
, R3.Session_request_internal_objects_alloc_page_count 
, R3.Session_request_internal_objects_dealloc_page_count
, R3.Session_request_user_objects_alloc_page_count
, R3.Session_request_user_objects_dealloc_page_count
, R2.sql_handle
, RL2.text as SQLText
, R2.statement_start_offset
, R2.statement_end_offset
, R2.plan_handle
FROM ( -- query space usage
	SELECT session_id
	, request_id 
	, SUM(internal_objects_alloc_page_count) AS Task_request_internal_objects_alloc_page_count
	, SUM(internal_objects_dealloc_page_count)AS Task_request_internal_objects_dealloc_page_count
	, SUM(user_objects_alloc_page_count) AS Task_request_user_objects_alloc_page_count
	, SUM(user_objects_dealloc_page_count)AS Task_request_user_objects_dealloc_page_count
	FROM sys.dm_db_task_space_usage 
	GROUP BY session_id
	, request_id
    ) R1
    JOIN ( -- session space usage
		SELECT session_id
		, SUM(internal_objects_alloc_page_count) AS Session_request_internal_objects_alloc_page_count
		, SUM(internal_objects_dealloc_page_count)AS Session_request_internal_objects_dealloc_page_count
		, SUM(user_objects_alloc_page_count) AS Session_request_user_objects_alloc_page_count
		, SUM(user_objects_dealloc_page_count)AS Session_request_user_objects_dealloc_page_count
		FROM sys.dm_db_Session_space_usage 
		GROUP BY session_id
    ) R3 
      on R1.session_id = R3.session_id 
    JOIN sys.dm_exec_requests R2 
      ON R1.session_id = R2.session_id 
     and R1.request_id = R2.request_id
    OUTER APPLY sys.dm_exec_sql_text(R2.sql_handle) AS RL2
WHERE R1.session_id>50
