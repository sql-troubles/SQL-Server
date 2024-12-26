/*
Description: tables - statistics details 
Created by: A. Nastase 
Created: 31.03.2015
Modified by: A. Nastase
Modified: 31.03.2015
Source: 
Notes: 
*/


-- tables - statistics details 
DBCC SHOW_STATISTICS (N'dbo.inventtable', '_WA_Sys_0000002E_0E0FCABA')

-- tables - statistcis for a column
DBCC SHOW_STATISTICS (N'dbo.inventtrans', InventDimId)
