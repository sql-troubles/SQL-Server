/*
Description: events and columns traced
Created: 
Created by: P.Nielsen, M. White, U. Parui
Modified: 
Modified by: 
Source: Microsoft SQL Server 2008 Bible
Notes: 
*/

 SELECT tca.name trace_category
 , tev.name event_name
 , tco.name column_name 
 FROM fn_trace_geteventinfo(2) tei
      JOIN sys.trace_events tev
        ON tei.eventid = tev.trace_event_id
           JOIN sys.trace_categories tca
             ON tev.category_id = tca.category_id
      JOIN sys.trace_columns tco
        ON tei.columnid = tco.trace_column_id
