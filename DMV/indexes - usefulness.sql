/*
Description: indexes usefulness 
Created by: A. Nastase
Created: 18.01.2011
Modified by: A. Nastase
Modified: 18.01.2011
Notes: adapted from Listing 7 "Measuring the usefulness of indexes" developed by Aaaron Bertrand (Ch. 29) , from "SQL Server MVP Deep Dives" book
 code available from: http://www.manning.com/nielsen/
 
 TO DO: consider also the size of the index in analysis
*/

WITH usage AS
( -- index usage statistics
	SELECT database_id 
    , [object_id]
	, index_id
    , user_seeks + user_scans + user_lookups reads
	, user_updates writes
    , CASE 
		WHEN IsNull(user_seeks + user_scans + user_lookups + user_updates, 0)!=0 THEN CONVERT(DECIMAL(10,2), user_updates * 100.0 /(user_seeks + user_scans + user_lookups + user_updates)) 
		ELSE 0
	  END perc
	FROM sys.dm_db_index_usage_stats
	WHERE database_id = DB_ID() -- current db
)
SELECT DB_NAME(database_id) [database name]
, OBJECT_NAME(usg.[object_id]) [table name]
, ind.Name [index name] 
, ind.type_desc [index type]
--, ind.is_primary_key [primary key flag]
, usg.reads [number reads]
, usg.writes [number writes]
, usg.perc [percent reads/writes]
, CASE
	WHEN usg.reads = 0 AND usg.writes = 0 THEN 'Consider dropping : not used at all'
	WHEN usg.reads = 0 AND usg.writes > 0 THEN 'Consider dropping : only writes'
	WHEN usg.perc = 50 THEN 'Reads and writes equal'	
	WHEN usg.writes > usg.reads THEN 'Consider dropping : more writes (' + RTRIM(usg.perc) + '% of activity)'
	ELSE 'n/a'
END [status] 
FROM usage usg WITH (NOLOCK)
     JOIN sys.indexes ind WITH (NOLOCK)
       ON usg.[object_id] = ind.[object_id]
      AND usg.index_id = ind.index_id
WHERE usg.writes >= usg.reads
  AND ind.type != 0 -- no HEAP Indexes
  AND ind.is_primary_key = 0 -- ignore primary keys
ORDER BY usg.perc DESC
, usg.reads
, usg.writes DESC
