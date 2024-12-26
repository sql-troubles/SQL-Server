/*
Description: extended events maps available
Created: 19.01.2010
Created by: A. Nastase
Modified: 19.01.2010
Modified by: A. Nastase
Source: http://msdn.microsoft.com/en-us/library/dd822788.aspx
Notes: uses MSDB
  could be used to identify the supported lock/latch modes
Warnings: 
*/ 

-- uses MSDB
SELECT xpk.name package_name
, xmv.name map_name
, xmv.map_key
, xmv.map_value
FROM sys.dm_xe_map_values xmv
     JOIN sys.dm_xe_packages xpk
       ON xmv.object_package_guid = xpk.guid
WHERE xmv.name = 'lock_mode'
--WHERE name = 'latch_mode'
ORDER BY xmv.name
, xmv.map_key
