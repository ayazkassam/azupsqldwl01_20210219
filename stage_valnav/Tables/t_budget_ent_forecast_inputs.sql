CREATE TABLE [stage_valnav].[t_budget_ent_forecast_inputs] (
    [OBJECT_ID]               NVARCHAR (50)   NOT NULL,
    [PARENT_ID]               NVARCHAR (50)   NOT NULL,
    [ENTITY_ID]               NVARCHAR (50)   NULL,
    [NAME]                    NVARCHAR (100)  NULL,
    [DESCRIPTION]             NVARCHAR (2000) NULL,
    [PLAN_DEFINITION_ID]      NVARCHAR (50)   NULL,
    [RESERVES_CATEGORY_ID]    INT             NOT NULL,
    [BASED_ON]                INT             NOT NULL,
    [FORECAST_SOURCE_ID]      NVARCHAR (50)   NULL,
    [FORECAST_SOURCE_FACTOR]  FLOAT (53)      NULL,
    [FORECAST_CREATE_DATE]    BIGINT          NOT NULL,
    [FORECAST_CREATE_USER_ID] NVARCHAR (50)   NULL,
    [FORECAST_CHANGE_DATE]    BIGINT          NOT NULL,
    [FORECAST_CHANGE_USER_ID] NVARCHAR (50)   NULL,
    [HAS_ERROR]               TINYINT         NOT NULL,
    [HISTORY_CUTOFF]          DATETIME2 (7)   NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

