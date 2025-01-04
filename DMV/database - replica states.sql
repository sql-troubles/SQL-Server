-- https://learn.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-database-replica-states-azure-sql-database?view=azuresqldb-current

-- database that participates in primary and secondary replicas
SELECT db_name(database_id) db_name
--, DRS.database_id
--, DRS.group_id
--, DRS.replica_id
--, DRS.group_database_id
, DRS.is_local
, DRS.is_primary_replica
--, DRS.synchronization_state
, DRS.synchronization_state_desc
, DRS.is_commit_participant
--, DRS.synchronization_health
, DRS.synchronization_health_desc
--, DRS.database_state
, DRS.database_state_desc
, DRS.is_suspended
/*, DRS.suspend_reason
, DRS.suspend_reason_desc
, DRS.recovery_lsn
, DRS.truncation_lsn
, DRS.last_sent_lsn
, DRS.last_sent_time
, DRS.last_received_lsn
, DRS.last_received_time
, DRS.last_hardened_lsn
, DRS.last_hardened_time
, DRS.last_redone_lsn
, DRS.last_redone_time
, DRS.log_send_queue_size
, DRS.log_send_rate
, DRS.redo_queue_size
, DRS.redo_rate
, DRS.filestream_send_rate
, DRS.end_of_log_lsn
, DRS.last_commit_lsn
, DRS.last_commit_time
, DRS.low_water_mark_for_ghosts
, DRS.secondary_lag_seconds
, DRS.quorum_commit_lsn
, DRS.quorum_commit_time*/
FROM sys.dm_database_replica_states DRS
