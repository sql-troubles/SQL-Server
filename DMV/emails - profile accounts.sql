/*
Description: email profile accounts
Created by: A. Nastase
Created: 03.02.2011
Modified by: A. Nastase
Modified: 03.02.2011
Source: adapted after http://sqlwithmanoj.blogspot.com/2010/09/database-mail-setup-sql-server-2005.html
Notes: 
*/


SELECT pa.profile_id 
, pa.account_id 
, pa.sequence_number 
, pa.last_mod_datetime
, p.name [profile_name]
, p.description [profile_description]
, a.name [account_name]
, a.description [account_description]
, a.email_address 
, a.display_name 
, a.replyto_address 
FROM msdb.dbo.sysmail_profileaccount pa
     JOIN msdb.dbo.sysmail_profile p 
       ON pa.profile_id = p.profile_id
     JOIN msdb.dbo.sysmail_account a 
       ON pa.account_id = a.account_id
