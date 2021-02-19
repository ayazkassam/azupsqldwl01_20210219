CREATE TABLE [data_mart].[t_dim_scenario_fdc_downtime] (
    [scenario_key]  INT           NULL,
    [scenario_id]   VARCHAR (500) NULL,
    [scenario_desc] VARCHAR (500) NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

