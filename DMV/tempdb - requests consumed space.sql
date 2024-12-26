/*
Description: space consumed by internal objects in the current requests
Created by: A. Nastase
Created: 02.08.2010
Modified by: A. Nastase
Modified: 02.08.2010
Notes: adapted after all_request_usage view from http://technet.microsoft.com/en-us/library/ms176029(SQL.90).aspx
*/

SELECT TSU.session_id
, TSU.request_id 
, ES.[program_name] 
, ES.[host_name] 
, ES.client_interface_name 
, ES.login_name 
, ES.nt_domain
, ES.nt_user_name 
--, ES.Status
, ER.start_time 
, EST.text 
, TSU.request_internal_objects_alloc_page_count
, TSU.request_internal_objects_dealloc_page_count
, ER.statement_start_offset
, ER.statement_end_offset
FROM (
  SELECT session_id
  , request_id
  , SUM(internal_objects_alloc_page_count) AS request_internal_objects_alloc_page_count
  , SUM(internal_objects_dealloc_page_count)AS request_internal_objects_dealloc_page_count 
  FROM sys.dm_db_task_space_usage 
  GROUP BY session_id
  , request_id
  ) TSU
  JOIN sys.dm_exec_sessions ES 
    ON TSU.session_id = ES.session_id 
  JOIN sys.dm_exec_requests ER
    ON TSU.request_id = ER.request_id
   AND TSU.session_id = ER.session_id 
       OUTER APPLY sys.dm_exec_sql_text(ER.sql_handle) EST
--WHERE ISNULL(NullIf(TSU.request_internal_objects_alloc_page_count, 0)
-- , NullIf(TSU.request_internal_objects_dealloc_page_count, 0)) IS NOT NULL
 ORDER BY ES.last_request_start_time
 
