/*
Description: extended events distribution
Created by: P.Nielsen, M. White, U. Parui
Modified: 
Modified by: 
Source: Microsoft SQL Server 2008 Bible
Notes: 
*/


 SELECT [package]
 , pt.action
 , pt.event
 , pt.map
 , pt.pred_compare
 , pt.pred_source
 , pt.target_type
 FROM (--extended events 
	 SELECT o.name [object]
	 , p.name as [package]
	 , o.object_type
	 FROM sys.dm_xe_objects o
		  JOIN sys.dm_xe_packages p
			ON o.type_package_guid = p.guid
    ) sq
    PIVOT (
        COUNT(Object)
        FOR object_type IN (action, event, map, pred_compare, pred_source, target_type)
    ) AS pt;
