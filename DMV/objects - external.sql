/*
Description: objects external
Created by: A. Nastase
Created: 25.01.2010
Modified by: A. Nastase
Modified: 25.01.2010
Source: 
Notes:
*/

SELECT o.name AS [object name] 
, o.type [object type]
, o.type_desc [object type desc]
FROM master.sys.all_objects o 
     LEFT JOIN master.sys.database_permissions p 
       ON p.major_id = o.object_id 
          LEFT JOIN master.sys.database_principals u 
            ON p.grantee_principal_id = u.principal_id 
WHERE  o.type IN ('X', 'TA', 'PC', 'FS', 'FT', 'AF')
  AND u.name IS NULL 
ORDER BY o.name 
