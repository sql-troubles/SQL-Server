/*
Description: extended events objects
Created: 19.01.2010
Created by: A. Nastase
Modified: 19.01.2010
Modified by: A. Nastase
Source: (How to: View the Extended Events Targets for Registered Packages) http://technet.microsoft.com/en-us/library/bb677247(SQL.100).aspx
Notes: uses MSDB
see also http://msdn.microsoft.com/en-us/library/dd822788.aspx
Warnings: 
*/ 

use msdb
SELECT p.name package_name
--, p.description
, p.capabilities_desc
, o.name target_name
, o.object_type 
, o.type_name 
, o.type_size 
, o.description 
, o.capabilities_desc
FROM sys.dm_xe_objects o
/*
     LEFT join sys.dm_xe_packages p
      on o.package_guid = p.guid
*/
WHERE o.object_type = 'target' 
AND (p.capabilities IS NULL OR p.capabilities <> 1)
ORDER BY p.name --package_name
, o.name --target_name
