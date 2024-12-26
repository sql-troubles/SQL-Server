/*
Description: Table Columns 
Created: 11.06.2010
Created by: A. Nastase
Modified: 20.07.2010
Modified by: A. Nastase
Notes: 
*/

SELECT T.name TableName
, C.name ColumnName
, S.Name SchemaName
, S.name + '.' + T.name SearchName
, CASE 
	WHEN C.is_ansi_padded = 1 and LEFT(ST.name , 1) = 'n' THEN C.max_length/2
	ELSE C.max_length
  END max_length
, C.precision 
, C.scale
, C.is_nullable 
, C.is_identity
, C.column_id
, UT.name as UserDataType
, ST.name system_type 
, ROW_NUMBER() OVER(PARTITION BY C.object_id  ORDER BY C.column_id) Ranking
FROM sys.columns C
     JOIN sys.types as UT
       on c.user_type_id= UT.user_type_id 
     JOIN sys.types ST 
      ON C.system_type_id = ST.user_type_id
	 JOIN sys.tables T
	   ON C.object_id = T.object_id
	 join sys.schemas as S
	   on S.schema_id = T.schema_id
/* -- columns available in an index
WHERE (UT.name IN ('text', 'ntext', 'xml', 'image')
        OR (UT.name IN ('varchar', 'nvarchar') AND C.max_length = 0))
  AND EXISTS ( SELECT 1
	FROM sys.index_columns inc
	WHERE c.object_id = inc.object_id 
	  AND C.column_id = inc.column_id)
*/
WHERE C.name LIKE 'QURItemActive%'
