/*
Description: cached plan - guides
Created by: A. Nastase
Created: 30.11.2012
Modified by: A. Nastase
Modified: 30.11.2012
Notes: 
*/

-- cached plan - guides
 SELECT pg.plan_guide_id
 , pg.name 
 , pg.create_date 
 , pg.modify_date 
 , pg.is_disabled 
 , pg.query_text 
 , pg.scope_type_desc 
 , pg.scope_object_id 
 , pg.scope_batch 
 , pg.parameters 
 , pg.hints 
 FROM sys.plan_guides pg
