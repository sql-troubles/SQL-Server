/*
Description: space consumed by internal objects in the current session for both running and completed tasks
Created by: A. Nastase
Created: 02.08.2010
Modified by: A. Nastase
Modified: 02.08.2010
Notes: adapted after all_sessions_usage view from http://technet.microsoft.com/en-us/library/ms176029(SQL.90).aspx
It could be a problem when pages that are not allocated are not deallocated.
*/

SELECT SPU.session_id
, ES.[program_name] 
, ES.[host_name] 
, ES.client_interface_name 
, ES.login_name 
, ES.nt_domain
, ES.nt_user_name 
--, ES.Status
, ES.last_request_start_time
, SPU.internal_objects_alloc_page_count  + TSU.task_internal_objects_alloc_page_count AS session_internal_objects_alloc_page_count
, SPU.internal_objects_dealloc_page_count  + TSU.task_internal_objects_dealloc_page_count AS session_internal_objects_dealloc_page_count
FROM sys.dm_db_session_space_usage AS SPU 
     JOIN (
 	SELECT session_id, 
	  SUM(internal_objects_alloc_page_count) AS task_internal_objects_alloc_page_count,
	  SUM(internal_objects_dealloc_page_count) AS task_internal_objects_dealloc_page_count 
	FROM sys.dm_db_task_space_usage 
	GROUP BY session_id    
     ) TSU 
       ON SPU.session_id = TSU.session_id
     JOIN sys.dm_exec_sessions ES 
       ON SPU.session_id = ES.session_id 
 WHERE ISNULL(NullIf(SPU.internal_objects_alloc_page_count  + TSU.task_internal_objects_alloc_page_count, 0)
 , NullIf(SPU.internal_objects_dealloc_page_count  + TSU.task_internal_objects_dealloc_page_count, 0)) IS NOT NULL
 ORDER BY ES.last_request_start_time
 
