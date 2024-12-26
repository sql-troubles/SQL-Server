/*
Description: users
Created: 03.01.2010
Created by: A. Nastase
Modified: 03.01.2010
Modified by: A. Nastase
Source: 
Notes: 
*/

SELECT usr.uid [User Id]
, USER_NAME(usr.uid) [User Name]
, convert(varchar(10), usr.createdate, 105) [Create Date]
, usr.hasdbaccess [Has DB Access]
, usr.islogin [Is Login]
, usr.isntname [Is NT Name]
, usr.isntuser [Is NT User]
, usr.isntgroup [Is NT Group]
, usr.*
FROM sys.sysusers usr
WHERE usr.issqlrole = 0
