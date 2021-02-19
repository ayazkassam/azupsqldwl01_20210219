CREATE TABLE [stage_valnav].[t_budget_ent_manual_forecast] (
    [OBJECT_ID]     NVARCHAR (50) NOT NULL,
    [PARENT_ID]     NVARCHAR (50) NOT NULL,
    [FORECAST_TYPE] INT           NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

