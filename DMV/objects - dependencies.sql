 /*
Description: objects - dependencies 
Created by: A. Nastase
Created: 28.02.2012
Modified by: A. Nastase
Modified: 28.02.2012
Source: http://www.mssqltips.com/sqlservertip/1768/identifying-object-dependencies-in-sql-server/
Notes:      
*/

--objects - dependencies 
SELECT SCHEMA_NAME(obj.SCHEMA_ID) + '.'+ obj.name AS ReferencingObject
, sed.referenced_schema_name +'.'+sed.referenced_entity_name AS ReferencedObject
FROM sys.all_objects obj
     JOIN sys.sql_expression_dependencies sed 
       ON obj.OBJECT_ID = sed.REFERENCING_ID 
--WHERE obj.name = 'AllLookupRelationships'
WHERE sed.referenced_entity_name = 'ADDRESS'



--objects - dependencies 
SELECT *
FROM sys.dm_sql_referencing_entities('dbo.INVENTTABLE', 'Object')
