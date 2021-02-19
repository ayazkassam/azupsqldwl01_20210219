CREATE TABLE [stage_valnav].[t_budget_ent_manual_forecast_value] (
    [PARENT_ID]    NVARCHAR (50) NOT NULL,
    [MANUAL_DATE]  DATETIME2 (7) NOT NULL,
    [MANUAL_VALUE] FLOAT (53)    NOT NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

