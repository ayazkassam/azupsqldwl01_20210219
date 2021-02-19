CREATE TABLE [stage_valnav].[t_budget_ent_capital_actual] (
    [PARENT_ID] NVARCHAR (50) NOT NULL,
    [AFE_ID]    NVARCHAR (50) NOT NULL,
    [COST_DATE] DATETIME2 (7) NOT NULL,
    [VALUE]     FLOAT (53)    NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

