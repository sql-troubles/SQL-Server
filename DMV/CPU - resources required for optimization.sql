/*
Description: CPU Resources Required for Optimization
Created: 08.10.2009
Created by: ?
Modified: 
Modified by: 
Source: http://gallery.technet.microsoft.com/ScriptCenter/en-us/c973df58-d975-4f4c-aae0-07b31ed7d832
Notes: 
*/

Select * 
from sys.dm_exec_query_optimizer_info
where counter in ('optimizations'
,'elapsed time'
,'trivial plan'
,'tables'
,'insert stmt'
,'update stmt'
,'delete stmt')
