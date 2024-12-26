/*
Description: Database Backups 
Created: 10.09.2008
Created by: T. Ford
Modified: 29.06.2010
Modified by: A. Nastase
Source: http://www.mssqltips.com/tip.asp?tip=1601
Notes: 
*/

SELECT CONVERT(CHAR(100), SERVERPROPERTY('Servername')) AS [Server]
, BS.database_name 
, BS.backup_start_date
, BS.backup_finish_date
, DATEDIFF(MI, BS.backup_start_date, BS.backup_finish_date) Duration
, BS.expiration_date 
, CASE BS.type  
   WHEN 'D' THEN 'Database'  
   WHEN 'L' THEN 'Log'  
  END AS backup_type  
, BS.backup_size  
, BMF.logical_device_name 
, BMF.physical_device_name   
, BS.name AS backupset_name 
, BS.description 
FROM msdb.dbo.backupmediafamily  BMF
    JOIN msdb.dbo.backupset BS
      ON BMF.media_set_id = BS.media_set_id  
WHERE  (CONVERT(datetime, BS.backup_start_date, 102) >= GETDATE() - 7)  
  AND BS.type  = 'D'
ORDER BY BS.database_name
, BS.backup_finish_date DESC
