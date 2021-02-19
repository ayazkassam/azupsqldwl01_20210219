﻿CREATE TABLE [stage_valnav].[t_budget_ent_plan] (
    [OBJECT_ID]            NVARCHAR (50) NOT NULL,
    [PARENT_ID]            NVARCHAR (50) NOT NULL,
    [PLAN_DEFINITION_ID]   NVARCHAR (50) NOT NULL,
    [FORECAST_CHANGE_DATE] BIGINT        NOT NULL,
    [ECON_CHANGE_DATE]     BIGINT        NOT NULL,
    [LAST_MODIFIED_DATE]   BIGINT        NOT NULL,
    [REVIEW_STATE]         INT           NOT NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);
