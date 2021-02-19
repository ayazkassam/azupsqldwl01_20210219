CREATE TABLE [stage_valnav].[t_reserves_result_id] (
    [result_id] NVARCHAR (50) NOT NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);

