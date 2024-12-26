/*
Description: the space consumed by internal objects in all currently running tasks in each session
Created by: A. Nastase
Created: 02.08.2010
Modified by: A. Nastase
Modified: 02.08.2010
Notes: adapted after all_task_usage view from http://technet.microsoft.com/en-us/library/ms176029(SQL.90).aspx
*/

SELECT TSU.session_id
, ES.[program_name] 
, ES.[host_name] 
, ES.client_interface_name 
, ES.login_name 
, ES.nt_domain
, ES.nt_user_name 
, ES.last_request_start_time
--, ES.Status
, TSU.task_internal_objects_alloc_page_count
, TSU.task_internal_objects_dealloc_page_count
FROM (
	SELECT session_id, 
	  SUM(internal_objects_alloc_page_count) AS task_internal_objects_alloc_page_count,
	  SUM(internal_objects_dealloc_page_count) AS task_internal_objects_dealloc_page_count 
	FROM sys.dm_db_task_space_usage 
	GROUP BY session_id
	) TSU
    JOIN sys.dm_exec_sessions ES 
      ON TSU.session_id = ES.session_id 
ORDER BY ES.last_request_start_time
