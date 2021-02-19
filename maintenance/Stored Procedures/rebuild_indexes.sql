CREATE PROC [maintenance].[rebuild_indexes] AS

BEGIN

DECLARE @i INT              = 1
,       @t INT 
,       @sql NVARCHAR(4000)   = N''



IF OBJECT_ID('tempdb..#index_ddl') IS NOT NULL
BEGIN
    DROP TABLE #index_ddl
END

CREATE TABLE #index_ddl
WITH
(
    DISTRIBUTION = HASH([seq_nmbr])
)
AS
WITH T
AS
(

SELECT 
     [database_name],
	 [schema_name],
	 [table_name],
	 [COMPRESSED_rowgroup_rows_AVG],
	 [Rebuild_Index_SQL],
     ROW_NUMBER()
        OVER(ORDER BY (SELECT NULL))                                            AS [seq_nmbr]
FROM
(
SELECT
    -- This query is from Microsoft site. Other columns as well. Search for: Indexing tables in Synapse SQL pool
	--
       DB_Name()                                                                AS [database_name]
,       s.name                                                                  AS [schema_name]
,       t.name                                                                  AS [table_name]
,       AVG(CASE WHEN rg.[State] = 3 THEN rg.[total_rows]     ELSE NULL END)    AS [COMPRESSED_rowgroup_rows_AVG]
,       'ALTER INDEX ALL ON ' + s.name + '.' + t.NAME + ' REBUILD;'             AS [Rebuild_Index_SQL]

FROM    sys.[pdw_nodes_column_store_row_groups] rg
JOIN    sys.[pdw_nodes_tables] nt                   ON  rg.[object_id]          = nt.[object_id]
                                                    AND rg.[pdw_node_id]        = nt.[pdw_node_id]
                                                    AND rg.[distribution_id]    = nt.[distribution_id]
JOIN    sys.[pdw_table_mappings] mp                 ON  nt.[name]               = mp.[physical_name]
JOIN    sys.[tables] t                              ON  mp.[object_id]          = t.[object_id]
JOIN    sys.[schemas] s                             ON t.[schema_id]            = s.[schema_id]
GROUP BY
        s.[name]
,       t.[name]
 )xx
 
 where [COMPRESSED_rowgroup_rows_AVG] > 100000
)
SELECT
    [Rebuild_Index_SQL]
	,   [seq_nmbr]
FROM    T;

SET @t = (SELECT COUNT(*) FROM #index_ddl)


WHILE @i <= @t
BEGIN
    SET @sql=(SELECT [Rebuild_Index_SQL] FROM #index_ddl WHERE seq_nmbr = @i);

    --PRINT @s
    EXEC sp_executesql @sql
    SET @i+=1;
END

DROP TABLE #index_ddl;

END