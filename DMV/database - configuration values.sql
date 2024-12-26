/*
Description: Database configuration values
Created by: A.Nastase
Created: ?
Modified by: A.Nastase
Modified: 19.01.2010 
Notes: 
For audits focus on:
1. backup compression default
2. clr enabled (only enable if it is needed)
3. lightweight pooling (should be zero)
4. max degree of parallelism 
5. max server memory (MB) (set to an appropriate value)
6. optimize for ad hoc workloads (should be 1)
7. priority boost (should be zero)
*/


-- Get sp_configure values for instance
EXEC sp_configure 'Show Advanced Options', 1;
GO
RECONFIGURE;
GO
EXEC sp_configure;

-- database configuration values
SELECT cnf.configuration_id
, cnf.name
, cnf.description
, cnf.value 
, cnf.minimum 
, cnf.maximum 
, cnf.value_in_use 
, cnf.is_dynamic 
, cnf.is_advanced 
FROM sys.configurations cnf
--WHERE cnf.value != cnf.value_in_use 
WHERE name LIKE '%time%'
ORDER BY cnf.name 
