/*
Description: extended events object columns
Created: 19.01.2010
Created by: A. Nastase
Modified: 19.01.2010
Modified by: A. Nastase
Source: (How to: Get the Configurable Parameters for the ADD TARGET Argument) http://technet.microsoft.com/en-us/library/bb677176(SQL.100).aspx
Notes: 
Warnings: 
*/ 
 
SELECT p.name package_name
, o.name target_name
, c.name parameter_name
, c.type_name parameter_type
, c.capabilities_desc
, CASE 
	c.capabilities_desc WHEN 'mandatory' THEN 'yes' 
	ELSE 'no' 
END Mandatory 
, c.column_type
, c.description 
FROM sys.dm_xe_object_columns c 
     JOIN sys.dm_xe_objects o 
       ON o.name = c.object_name 
          JOIN sys.dm_xe_packages p 
            ON o.package_guid = p.guid 
/* -- configurable parameters for the ADD TARGET argument
WHERE o.object_type = 'target' 
  AND c.column_type = 'customizable'
*/
WHERE o.object_type = 'event'
ORDER BY p.name --package_name
, o.name --target_name
, c.name --parameter_name
