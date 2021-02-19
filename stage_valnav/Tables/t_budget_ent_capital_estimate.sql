CREATE TABLE [stage_valnav].[t_budget_ent_capital_estimate] (
    [PARENT_ID]         NVARCHAR (50)  NOT NULL,
    [AFE_ID]            NVARCHAR (50)  NOT NULL,
    [AFE_NUM]           NVARCHAR (100) NULL,
    [COST_TYPE]         NVARCHAR (50)  NULL,
    [APPROVED_ESTIMATE] FLOAT (53)     NULL,
    [REVISED_ESTIMATE]  FLOAT (53)     NULL,
    [END_DATE]          DATETIME2 (7)  NULL,
    [INCURRED_TOTAL]    FLOAT (53)     NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

