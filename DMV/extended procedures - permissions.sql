/*
Description: extended procedures permissions 
Created: 
Created by: ?
Modified: 28.06.2010
Modified by: A. Nastase
Source: http://gallery.technet.microsoft.com/ScriptCenter/en-us/04f3b143-7a84-462e-bb5d-8373c5bde88e
Notes: check http://iase.disa.mil/stigs/checklist/ for the last document
*/

SELECT o.name [object]
, u.name [user]
FROM master.sys.system_objects o
     JOIN master.sys.database_permissions p
       ON o.object_id = p.major_id
          JOIN master.sys.database_principals u
            ON p.grantee_principal_id = u.principal_id
WHERE o.name LIKE 'xp%'
AND P.type = 'EX'
ORDER BY o.name 
, u.name  
