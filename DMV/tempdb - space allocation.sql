/*
Description: tempdb space allocation
Created by: A. Nastase
Created: 02.08.2010
Modified by: A. Nastase
Modified: 02.08.2010
Notes: adapted after http://social.msdn.microsoft.com/Forums/en-US/sqldisasterrecovery/thread/def964b2-b527-444e-b91b-b2f824c32299
"If the version store is using a lot of space in tempdb, you must determine what is the longest running transaction. Use this query to list the active transactions in order, by longest running transaction" (see: http://technet.microsoft.com/en-us/library/ms176029(SQL.90).aspx)
*/

SELECT DB_NAME (FSU.database_id) [database_name]
, DF.name [file_name]
, DF.physical_name
-- kb numbers 
, FSU.user_object_reserved_page_count * 8 user_object_reserved_page_count_kb
, FSU.internal_object_reserved_page_count * 8 internal_object_reserved_page_count_kb
, FSU.version_store_reserved_page_count * 8 version_store_reserved_page_count_kb
, FSU.unallocated_extent_page_count * 8 unallocated_extent_page_count_kb
, FSU.mixed_extent_page_count * 8 mixed_extent_page_count_kb
, DF.size*8 database_size_kb
, (DF.size - CAST(FILEPROPERTY(DF.name, 'SpaceUsed') as int)) * 8 database_available_space_kb
-- MB numbers 
, FSU.user_object_reserved_page_count/128.0 user_object_reserved_page_count_MB
, FSU.internal_object_reserved_page_count/128.0 internal_object_reserved_page_count_MB
, FSU.version_store_reserved_page_count/128.0 version_store_reserved_page_count_MB
, FSU.unallocated_extent_page_count/128.0 unallocated_extent_page_count_MB
, FSU.mixed_extent_page_count/128.0 mixed_extent_page_count_MB
, DF.size/128.0 AS [database_size_MB]
, DF.size/128.0 - CAST(FILEPROPERTY(DF.name, 'SpaceUsed') AS int)/128.0 AS [database_available_space_MB]
FROM (
	SELECT database_id
	, [file_id]
	, SUM (user_object_reserved_page_count) as user_object_reserved_page_count
	, SUM (internal_object_reserved_page_count) as internal_object_reserved_page_count
	, SUM (version_store_reserved_page_count)  as version_store_reserved_page_count
	, SUM (unallocated_extent_page_count) as unallocated_extent_page_count
	, SUM (mixed_extent_page_count)as mixed_extent_page_count
	FROM sys.dm_db_file_space_usage
	GROUP BY database_id
	, [file_id]
    ) FSU
     JOIN sys.database_files DF
       ON FSU.file_id = DF.file_id
ORDER BY [database_name]
, [file_name]   
