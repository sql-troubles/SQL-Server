/*
Description: extended Events sessions with actions 
Created: 19.01.2010
Created by: J. Kehayias
Modified: 19.01.2010
Modified by: A. Nastase
Source: http://sqlblog.com/blogs/jonathan_kehayias/archive/2010/12/04/an-xevent-a-day-4-31-querying-the-session-definition-and-active-session-dmv-s.aspx
Notes: 
Warnings: 
*/ 
 
SELECT s.name AS session_name
, e.event_name AS event_name
, e.event_predicate AS event_predicate
, ea.action_name AS action_name
FROM sys.dm_xe_sessions AS s
     JOIN sys.dm_xe_session_events AS e     
       ON s.address = e.event_session_address
     JOIN sys.dm_xe_session_event_actions AS ea     
       ON e.event_session_address = ea.event_session_address    
      AND e.event_name = ea.event_name
