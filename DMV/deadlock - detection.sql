/*
Description: deadlock detection
Created by: S. Oks
Created: 14.11.2006
Modified by: A. Nastase
Modified: 24.01.2011
Source: http://blogs.msdn.com/b/slavao/archive/2006/11/14/sqlosdmv-s-continue.aspx
Notes: was developed for SQL Server 2005
*/

WITH TaskChain ( 
  waiting_task_address
, blocking_task_address
, ChainId
, Level)
AS
(
	-- Anchor member definition: use self join so that we output 
	-- Only tasks that blocking others and remove dupliates
	SELECT DISTINCT A.waiting_task_address 
	, A.blocking_task_address
	, A.waiting_task_address As ChainId
	, 0 AS Level
	FROM sys.dm_os_waiting_tasks as A
		 JOIN sys.dm_os_waiting_tasks as B
		   ON A.waiting_task_address = B.blocking_task_address
	WHERE  A.blocking_task_address IS NULL
	UNION ALL
	-- Recursive member definition: Get to the next level waiting
	-- tasks
	SELECT A.waiting_task_address
	, A.blocking_task_address
	, B.ChainId
	, Level + 1
	FROM sys.dm_os_waiting_tasks AS A
		 JOIN TaskChain AS B 
		   ON B.waiting_task_address = A.blocking_task_address
)
select waiting_task_address
, blocking_task_address
, ChainId
, Level  
from TaskChain
order by ChainId 
