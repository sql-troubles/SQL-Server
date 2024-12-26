/*
Description: tables - page splits
Created by: D. Adeniji
Created: 29.06.2012
Modified by: A. Nastase
Modified: 02.07.2012
Source: http://danieladeniji.wordpress.com/2011/01/29/microsoft-sqlserver-page-splits/
Notes: 
*/ 

-- tables - page splits
select Operation
, AllocUnitName
, COUNT(*) as NumberofIncidents
from   ::fn_dblog(null, null)
where Operation = 'LOP_DELETE_SPLIT'
group by Operation, AllocUnitName



-- tables - page splits details
select Operation
, AllocUnitName
, dbl.[New Split Page]
, dbl.[Rows Deleted]
, dbl.Description 
, [Begin Time]
from   ::fn_dblog(null, null) dbl
where Operation = 'LOP_DELETE_SPLIT'
