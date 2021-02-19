CREATE TABLE [stage_ihs].[t_fact_source_accumap_volumes] (
    [uwi]    VARCHAR (40)    NOT NULL,
    [oil]    NUMERIC (14, 4) NULL,
    [gas]    FLOAT (53)      NULL,
    [water]  FLOAT (53)      NULL,
    [cond]   FLOAT (53)      NULL,
    [p_hour] FLOAT (53)      NULL,
    [Date]   DATE            NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);

