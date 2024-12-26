/*
Description: cached plan statistics
Created by: A. Nastase
Created: 05.08.2010
Modified by: A. Nastase
Modified: 05.08.2010
Source: adapted after http://sqlserverpedia.com/blog/sql-server-bloggers/optimizing-for-ad-hoc-workloads/
Notes: 
*/


SELECT objtype object_type 
-- general statistics
, COUNT(1) plans_count
, SUM(CAST(size_in_bytes AS BIGINT))/1024/1024 Size_MB 
, AVG(usecounts) AS average_uses
, SUM(refcounts) reference_count
, SUM(usecounts) use_count
-- single runs
, SUM(Cast(CASE WHEN usecounts = 1 THEN size_in_bytes ELSE 0 END as bigint))/1024/1024 single_use_size_MB
, SUM(CASE WHEN usecounts = 1 THEN 1 ELSE 0 END) single_use_count
, SUM(CASE WHEN refcounts = 1 THEN 1 ELSE 0 END) single_reference_count
-- percentages single runs
, Cast(CASE
	WHEN SUM(CAST(size_in_bytes AS BIGINT))<>0 THEN 100.0*SUM(Cast(CASE WHEN usecounts = 1 THEN size_in_bytes ELSE 0 END as bigint))/SUM(CAST(size_in_bytes AS BIGINT))
	ELSE 0 
  END as decimal(5,2)) single_size_percent
, Cast(CASE
	WHEN SUM(usecounts) <>0 THEN 100.0*SUM(CASE WHEN usecounts = 1 THEN 1 ELSE 0 END)/SUM(usecounts) 
	ELSE 0
  END as decimal(5,2)) single_use_percent
, Cast(CASE 
	WHEN SUM(refcounts) <> 0 THEN 100.0*SUM(CASE WHEN refcounts = 1 THEN 1 ELSE 0 END)/SUM(refcounts)
	ELSE 0
  END as decimal(5,2)) single_reference_percent
FROM sys.dm_exec_cached_plans 
GROUP BY objtype; 
