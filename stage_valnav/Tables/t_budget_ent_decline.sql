CREATE TABLE [stage_valnav].[t_budget_ent_decline] (
    [OBJECT_ID]                NVARCHAR (50) NOT NULL,
    [PARENT_ID]                NVARCHAR (50) NOT NULL,
    [SLOPE_TYPE]               INT           NOT NULL,
    [FIT_START_DATE]           DATETIME2 (7) NULL,
    [FIT_END_DATE]             DATETIME2 (7) NULL,
    [FIT_INITIAL_RATE]         FLOAT (53)    NULL,
    [FIT_INITIAL_SLOPE]        FLOAT (53)    NULL,
    [FIT_FINAL_RATE]           FLOAT (53)    NULL,
    [FIT_EXPONENT]             FLOAT (53)    NULL,
    [FIT_ERROR]                FLOAT (53)    NULL,
    [FIT_METHOD]               INT           NULL,
    [INC_INITIAL_RATE_TYPE]    INT           NULL,
    [INC_INITIAL_RATE_VALUE]   FLOAT (53)    NULL,
    [INC_INITIAL_RATE_PERCENT] FLOAT (53)    NULL,
    [INC_FINAL_RATE_TYPE]      INT           NULL,
    [INC_FINAL_RATE_VALUE]     FLOAT (53)    NULL,
    [INC_FINAL_RATE_PERCENT]   FLOAT (53)    NULL,
    [INC_END_CUM_TYPE]         INT           NULL,
    [INC_END_CUM_VALUE]        FLOAT (53)    NULL,
    [INC_END_CUM_PERCENT]      FLOAT (53)    NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

