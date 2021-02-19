﻿CREATE TABLE [stage_valnav].[t_typecurves_ent_reserves_category] (
    [OBJECT_ID]               NVARCHAR (50) NOT NULL,
    [PARENT_ID]               NVARCHAR (50) NOT NULL,
    [ENTITY_ID]               NVARCHAR (50) NOT NULL,
    [PLAN_DEFINITION_ID]      NVARCHAR (50) NOT NULL,
    [RESERVE_CATEGORY_ID]     INT           NOT NULL,
    [PRICE_SET_ID]            NVARCHAR (50) NULL,
    [FORECAST_CHANGE_DATE]    BIGINT        NOT NULL,
    [ECON_CHANGE_DATE]        BIGINT        NOT NULL,
    [CALCULATION_DATE]        BIGINT        NULL,
    [AUTOCALC_PROCESS_LOSS]   TINYINT       NULL,
    [CHANCE_OF_SUCCESS]       FLOAT (53)    NULL,
    [CHANCE_OF_OCCURRENCE]    FLOAT (53)    NULL,
    [ECONOMIC_LIMIT_APPLY]    TINYINT       NULL,
    [TERMINATION_DATE]        DATETIME2 (7) NULL,
    [ABANDONMENT_DELAY]       INT           NOT NULL,
    [ABANDONMENT_VALUE]       FLOAT (53)    NOT NULL,
    [SALVAGE_DELAY]           INT           NOT NULL,
    [SALVAGE_VALUE]           FLOAT (53)    NOT NULL,
    [FORECAST_CHANGE_USER_ID] NVARCHAR (50) NULL,
    [HAS_ECONOMIC_RESULTS]    TINYINT       NULL,
    [PROJECT_START]           DATETIME2 (7) NULL,
    [ECONOMIC_LIMIT_DELAY]    INT           NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

