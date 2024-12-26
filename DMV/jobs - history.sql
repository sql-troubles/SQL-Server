/*
Description: Jobs History
Created: 18.10.2010
Created by: A. Nastase
Modified: 21.10.2014
Modified by: A. Nastase
Source: adapted after http://www.mssqltips.com/tip.asp?tip=1054
Notes: 
*/ 

-- Jobs' history
SELECT jh.instance_id
, jh.instance_id
, j.[name] [Job Name]
, jc.name [Category Name]
, js.step_name [Step Name]
, jh.step_id
, jh.step_name
, msdb.dbo.agent_datetime(jh.run_date, jh.run_time) RunningDate 
--, jh.run_date
--, jh.run_time
, jh.sql_severity
, jh.message
, jh.server 
FROM msdb.dbo.sysjobhistory jh 
     JOIN msdb.dbo.sysjobs j 
       ON jh.job_id = j.job_id 
          JOIN msdb.dbo.syscategories jc
            ON j.category_id = jc.category_id
     JOIN msdb.dbo.sysjobsteps js 
       ON j.job_id = js.job_id
      AND jh.step_id = js.step_id
WHERE    jh.run_status = 0 -- Failure 
         --AND h.run_date >
ORDER BY jh.instance_id DESC 

SELECT *
FROM msdb.dbo.syscategories
