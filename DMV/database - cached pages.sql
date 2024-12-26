/*
Description: cached pages per database
Created: 07.07.2010
Created by: T. Larock
Modified: 07.07.2010
Modified by: A. Nastase
Source: DBA Survivor. Apress. ISBN: 978-1-4302-2788-5
Notes: 
*/

SELECT COUNT(1) cached_pages
, database_id
, CASE database_id
	WHEN 32767 THEN 'ResorceDb'
	ELSE DB_NAME(database_id)
  END database_name
FROM sys.dm_os_buffer_descriptors
GROUP BY DB_NAME(database_id), database_id
ORDER BY cached_pages DESC
