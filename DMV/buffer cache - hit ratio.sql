/*
Description: Buffer cache hit ratio for default instance
Created by: G. Berry
Created: ?
Modified by: A. Nastase
Modified: 02.08.2010
Notes:  -- Shows the percentage that SQL Server is finding requested data in memory
-- A higher percentage is better than a lower percentage
-- Watch the trend, not the absolute value.
*/

 
SELECT (a.cntr_value * 1.0 / b.cntr_value) * 100.0 AS [Buffer Cache Hit Ratio]
FROM sys.dm_os_performance_counters AS a
     JOIN (
        SELECT cntr_value, [OBJECT_NAME]
        FROM sys.dm_os_performance_counters  
        WHERE counter_name = N'Buffer cache hit ratio base'
          --AND [OBJECT_NAME] = N'SQLServer:Buffer Manager'
     ) AS b -- Modify this if you have named instances
       ON a.[OBJECT_NAME] = b.[OBJECT_NAME]
WHERE a.counter_name = N'Buffer cache hit ratio'
--AND a.[OBJECT_NAME] = N'SQLServer:Buffer Manager'; -- Modify this if you have named instances
