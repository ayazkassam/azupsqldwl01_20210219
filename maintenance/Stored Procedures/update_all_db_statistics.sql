CREATE PROC [maintenance].[update_all_db_statistics] @update_type [tinyint],@sample_pct [tinyint] AS

BEGIN

DECLARE @i INT              = 1
,       @t INT 
,       @s NVARCHAR(4000)   = N''

IF @update_type NOT IN (1,2,3,4)
BEGIN;
    THROW 151000,'Invalid value for @update_type parameter. Valid range 1 (default), 2 (fullscan), 3 (sample) or 4 (resample).',1;
END;

IF @sample_pct IS NULL
BEGIN;
    SET @sample_pct = 20;
END;

IF OBJECT_ID('tempdb..#stats_ddl') IS NOT NULL
BEGIN
    DROP TABLE #stats_ddl
END

CREATE TABLE #stats_ddl
WITH
(
    DISTRIBUTION = HASH([seq_nmbr])
)
AS
WITH T
AS
(

SELECT s.name schema_name,
       t.name table_name,
	   s.name + '.' + t.name two_part_name,
	   ROW_NUMBER()
        OVER(ORDER BY (SELECT NULL))                                            AS [seq_nmbr]
FROM  sys.tables t
JOIN sys.schemas s ON t.schema_id = s.schema_id 
JOIN (
      -- tables with statistics created
			select distinct object_id from sys.stats where stats_id > 1
			) objIdsWithStats
      on t.object_id = objIdsWithStats.object_id
WHERE t.is_external=0
-- exclude external tables

)
SELECT
    CASE @update_type
    WHEN 1
    THEN 'UPDATE STATISTICS '+[two_part_name]+';'
    WHEN 2
    THEN 'UPDATE STATISTICS '+[two_part_name]+' WITH FULLSCAN;'
    WHEN 3
    THEN 'UPDATE STATISTICS '+[two_part_name]+' WITH SAMPLE '+CAST(@sample_pct AS VARCHAR(20))+' PERCENT;'
    WHEN 4
    THEN 'UPDATE STATISTICS '+[two_part_name]+' WITH RESAMPLE;'
    END AS [update_stats_ddl]
	,   [seq_nmbr]
FROM    T;

SET @t = (SELECT COUNT(*) FROM #stats_ddl)


WHILE @i <= @t
BEGIN
    SET @s=(SELECT [update_stats_ddl] FROM #stats_ddl WHERE seq_nmbr = @i);

    --PRINT @s
    EXEC sp_executesql @s
    SET @i+=1;
END

DROP TABLE #stats_ddl;

END