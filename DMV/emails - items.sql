/*
Description: email items
Created by: A. Nastase
Created: 03.02.2011
Modified by: A. Nastase
Modified: 03.02.2011
Source: 
Notes: not validated!
*/
 
SELECT smi.mailitem_id
, smi.profile_id
, smi.sent_account_id
, smi.recipients
, smi.copy_recipients
, smi.blind_copy_recipients
, smi.subject
, smi.body
, smi.body_format
, smi.importance
, smi.sensitivity
, smi.file_attachments
, smi.attachment_encoding
, smi.query
, smi.execute_query_database
, smi.attach_query_result_as_file
, smi.query_result_header
, smi.query_result_width
, smi.query_result_separator
, smi.exclude_query_output
, smi.append_query_error
, smp.name [profile_name]
, smp.description [profile_description]
, smi.send_request_date
, smi.send_request_user
, sma.name [sent_account_name]
, sma.description [sent_account_description]
, sma.email_address 
, smi.sent_status
, smi.sent_date
, smi.last_mod_date
, smi.last_mod_user
FROM msdb.dbo.sysmail_mailitems smi
     JOIN msdb.dbo.sysmail_profile smp 
       ON smi.profile_id = smp.profile_id
     JOIN msdb.dbo.sysmail_account sma 
       ON smi.sent_account_id = sma.account_id
