/*
Description: email event log
Created by: A. Nastase
Created: 03.02.2011
Modified by: A. Nastase
Modified: 03.02.2011
Source: 
Notes: not validated!
*/

SELECT err.log_id
, err.process_id 
, err.mailitem_id
, err.account_id 
, err.event_type 
, err.log_date 
, err.description 
, a.name account_name
, a.description account_description
, a.email_address 
, smi.recipients
, smi.copy_recipients
, smi.blind_copy_recipients
, smi.subject
FROM msdb.dbo.sysmail_event_log err
     JOIN msdb.dbo.sysmail_account a 
       ON err.account_id = a.account_id
     JOIN msdb.dbo.sysmail_mailitems smi
       ON err.mailitem_id = smi.mailitem_id
