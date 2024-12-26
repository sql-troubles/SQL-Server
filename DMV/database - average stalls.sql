/*
Description: Average Stalls
Created: 08.10.2009
Created by: ?
Modified: 28.06.2010
Modified by: A. Nastase
Source: http://gallery.technet.microsoft.com/ScriptCenter/en-us/04f3b143-7a84-462e-bb5d-8373c5bde88e
Notes: 
*/

select fs.database_id
, DB_NAME(fs.database_id) database_name
, fs.file_id
, mf.physical_name
, fs.io_stall_read_ms
, fs.num_of_reads
, cast(fs.io_stall_read_ms/(1.0+fs.num_of_reads) as numeric(10,1)) as 'avg_read_stall_ms'
, fs.io_stall_write_ms
, fs.num_of_writes
, cast(fs.io_stall_write_ms/(1.0+fs.num_of_writes) as numeric(10,1)) as 'avg_write_stall_ms'
, fs.io_stall_read_ms + fs.io_stall_write_ms as io_stalls
, fs.num_of_reads + fs.num_of_writes as total_io
, cast((fs.io_stall_read_ms+fs.io_stall_write_ms)/(1.0+fs.num_of_reads + fs.num_of_writes) as numeric(10,1)) as 'avg_io_stall_ms'
from sys.dm_io_virtual_file_stats(null,null) fs
     JOIN sys.master_files AS mf
       ON fs.database_id = mf.database_id
      AND fs.[file_id] = mf.[file_id]
WHERE fs.database_id = db_id()
order by avg_io_stall_ms desc
