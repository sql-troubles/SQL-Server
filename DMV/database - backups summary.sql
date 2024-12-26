Created by: A. Nastase
Created: 29.07.2010
Modified by: A. Nastase
Modified: 17.02.2011
Source: adapted after http://sqlserverpedia.com/blog/sql-server-bloggers/database-backup-disk-space-capacity-planning/
Notes: 
*/ 

SELECT  [Database Name]
, [Start Date]
, [All Types]
, ISNULL([Full],'') AS [Full]
, ISNULL([Differential],'') AS [Differential]
, ISNULL([Transaction Log],'') AS [Transaction Log] 
FROM(   
SELECT       
ISNULL(bu.database_name,'*All Databases')AS [Database Name]
, CASE bu.type            
	WHEN 'D' THEN 'Full'           
	WHEN 'I' THEN 'Differential'           
	WHEN 'L' THEN 'Transaction Log'            
	ELSE 'All Types'      
  END as [Backup Type]
  , ISNULL(convert(char(10), backup_start_date, 120),'All Dates' )as [Start Date]
  , CAST((SUM(bu.backup_size/1024/1024)) AS int) AS [Size in MB]    
FROM msdb.dbo.backupset as bu     
WHERE DATEDIFF(d, backup_start_date, GETDATE()) <= 6    
GROUP BY bu.database_name
, convert(char(10), backup_start_date, 120)
, bu.type    
WITH CUBE
) AS SourceTable 
PIVOT(SUM([Size in MB]) FOR [Backup Type] IN ([All Types], [Full], [Differential], [Transaction Log])) AS PivotTable 
ORDER BY [Database Name] ASC, convert(char(10), [Start Date], 120) DESC
