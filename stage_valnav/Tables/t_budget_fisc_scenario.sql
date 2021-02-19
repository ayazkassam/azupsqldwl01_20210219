CREATE TABLE [stage_valnav].[t_budget_fisc_scenario] (
    [OBJECT_ID]                NVARCHAR (50)   NOT NULL,
    [NAME]                     NVARCHAR (205)  NOT NULL,
    [DESCRIPTION]              NVARCHAR (2000) NULL,
    [SCENARIO_TYPE]            INT             NOT NULL,
    [LAST_CHANGE_DATE]         BIGINT          NOT NULL,
    [OWNED_BY]                 NVARCHAR (50)   NULL,
    [OVERRIDE_PLAN_PARAMETERS] TINYINT         NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

