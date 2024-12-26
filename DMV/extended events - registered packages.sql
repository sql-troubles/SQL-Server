/*
Description: extended events for registered packages
Created: 19.01.2010
Created by: A. Nastase
Modified: 19.01.2010
Modified by: A. Nastase
Source: (How to: View the Events for Registered Packages) http://technet.microsoft.com/en-us/library/bb677307(SQL.100).aspx
Notes: uses MSDB
   see also http://msdn.microsoft.com/en-us/library/dd822788.aspx
Warnings: 
*/

USE msdb
SELECT p.name
, c.event
, k.keyword
, c.channel
, c.description 
FROM
(
	SELECT o.package_guid event_package
	, o.description 
	, c.object_name event
	, v.map_value channel
	FROM sys.dm_xe_objects o
		 LEFT JOIN sys.dm_xe_object_columns c 
		   ON o.name=c.object_name
		 JOIN sys.dm_xe_map_values v 
		   ON c.type_name=v.name 
		  AND c.column_value=cast(v.map_key AS nvarchar)
	WHERE object_type='event' 
	  AND (c.name='CHANNEL' 
	   or c.name IS NULL)
   ) c 
   LEFT JOIN (
	SELECT c.object_package_guid event_package
	, c.object_name event
	, v.map_value keyword
	FROM sys.dm_xe_object_columns c 
		JOIN sys.dm_xe_map_values v 
		  ON c.type_name=v.name 
		 AND c.column_value=v.map_key 
		 AND c.type_package_guid=v.object_package_guid
		JOIN sys.dm_xe_objects o 
		  ON o.name=c.object_name 
		 AND o.package_guid=c.object_package_guid
	WHERE object_type='event' AND c.name='KEYWORD' 
   ) k
    ON k.event_package=c.event_package 
   AND (k.event=c.event 
    OR k.event IS NULL)
   JOIN sys.dm_xe_packages p ON p.guid=c.event_package
ORDER BY keyword desc
, channel
, event
