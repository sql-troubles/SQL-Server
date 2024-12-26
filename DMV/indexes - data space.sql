/*
Description: Data & Index File details
Created: 08.10.2009
Created by: ?
Modified: 28.06.2010
Modified by: A. Nastase
Source: http://gallery.technet.microsoft.com/ScriptCenter/en-us/c973df58-d975-4f4c-aae0-07b31ed7d832
Notes: 
*/

select 'table_name'=object_name(i.id)
, i.indid
, 'index_name'=i.name
, i.groupid
, 'filegroup'=f.name
, 'file_name'=d.physical_name
, 'dataspace'=s.name
from sys.sysindexes i
	 JOIN sys.filegroups f
	   ON f.data_space_id = i.groupid
          JOIN sys.database_files d
            ON f.data_space_id = d.data_space_id
	      JOIN sys.data_spaces s
	        ON f.data_space_id = s.data_space_id
where objectproperty(i.id,'IsUserTable') = 1
order by f.name
, table_name
, groupid

