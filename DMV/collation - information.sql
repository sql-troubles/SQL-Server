/*
Description: collation information
Created: 20.01.2010
Created by: A. Nastase
Modified: 20.01.2010
Modified by: A. Nastase
Source: 
Notes: for windows collations see: http://technet.microsoft.com/en-us/library/ms143515.aspx
Warnings: 
*/ 

-- collation information
SELECT Name
, Description 
FROM fn_helpcollations()
WHERE name IN ('Latin1_General_CI_AS', 'SQL_Latin1_General_CP1_CI_AS')



--example differences between Latin1_General_CI_AS vs. SQL_Latin1_General_CP1_CI_AS
-- source: http://www.sqlnewsgroups.net/sqlserver/t21181-difference-between-sql-latin1-general-cp1-ci-latin1-general.aspx
SELECT CASE 
	WHEN ('ab' COLLATE SQL_Latin1_General_CP1_CI_AS) > ('a-b' COLLATE SQL_Latin1_General_CP1_CI_AS) THEN 0 
	ELSE 1 
END [SQL_Latin1_General_CP1_CI_AS Comparison]
, CASE 
	WHEN ('ab' COLLATE Latin1_General_CI_AS) > ('a-b' COLLATE Latin1_General_CI_AS) THEN 0 
	ELSE 1 
END [Latin1_General_CI_AS Comparison]
