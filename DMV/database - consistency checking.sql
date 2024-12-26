/*
Description: Database Consistency Checking (Datenbank Konsistenzpr fung) 
Created by: A. Nastase
Created: 08.04.2014
Modified by: A. Nastase
Modified: 15.07.2015
Notes: das Befehl sollte f r jede Benutzer/System Datenbank ausgef hrt werden 
*/

-- Konsistenzpr fung f r ganzen Datenbank
DBCC CHECKDB WITH ALL_ERRORMSGS, NO_INFOMSGS

-- Konsistenzpr fung f r einen Tabelle
DBCC CHECKTABLE ('dbo.InventDim') WITH ALL_ERRORMSGS, NO_INFOMSGS




-- Konsistenz mit Datenverlust reparieren (Vorsicht!!!!)
--DBCC CHECKTABLE ('dbo.QURWIOUTLOG') WITH REPAIR_ALLOW_DATA_LOSS
