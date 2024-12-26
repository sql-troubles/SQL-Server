/*
Description: resources locks
Created by: A. Nastase
Created: 06.08.2010
Modified by: A. Nastase
Modified: 06.08.2010
Notes: based on transactions locked query
*/

SELECT DISTINCT DB_NAME (tl.resource_database_id) resource_database
, o.name 
, o.type 
, o.type_desc 
, tl.REQUEST_SESSION_ID 
, ES.[host_name]
, ES.[program_name]
, ES.[client_interface_name]
, ES.login_name 
, ES.nt_domain 
, ES.nt_user_name 
, ES.status 
, ES.last_request_start_time  
, ES.last_request_end_time 
, ER.command 
, ER.sql_text 
, TL.NumberLocks
FROM ( -- objects locked
     SELECT tl.resource_type
     , tl.resource_database_id
     , tl.request_session_id 
	 , CASE 
		WHEN tl.resource_type = 'OBJECT' THEN tl.resource_associated_entity_id
		ELSE p.object_id 
	 END object_id 
	 , COUNT(1) NumberLocks
     FROM sys.dm_tran_locks tl (nolock)
          LEFT JOIN sys.partitions p (nolock)
	        ON tl.resource_associated_entity_id = p.hobt_id   
	       AND tl.resource_type IN ('KEY', 'PAGE', 'RID')  
     WHERE tl.resource_type IN ('OBJECT', 'KEY', 'PAGE', 'RID') --= 'OBJECT' 
     GROUP BY tl.resource_type
     , tl.resource_database_id
     , tl.request_session_id 
	 , CASE 
		WHEN tl.resource_type = 'OBJECT' THEN tl.resource_associated_entity_id
		ELSE p.object_id 
	 END 
    ) tl
    JOIN sys.all_objects o (nolock) 
      ON  tl.object_id = o.object_id 
     AND tl.resource_type IN ('OBJECT', 'KEY', 'PAGE', 'RID')
    JOIN sys.dm_exec_sessions ES (nolock) 
      ON tl.REQUEST_SESSION_ID = ES.session_id
		 LEFT JOIN   
			 ( -- last request information
				 SELECT r.session_id 
				 , r.command
				 , est.text sql_text
				 FROM sys.dm_exec_requests r (nolock)
				 CROSS APPLY sys.dm_exec_sql_text(sql_handle) est
			 ) ER
		  ON ES.session_id = ER.session_id
  --AND tl.REQUEST_SESSION_ID IN (123, 105)
ORDER BY o.name 
