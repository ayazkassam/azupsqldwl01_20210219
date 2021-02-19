CREATE TABLE [stage_valnav].[t_typecurves_ent_reserves_cache] (
    [PARENT_ID]             NVARCHAR (50) NOT NULL,
    [ENTITY_ID]             NVARCHAR (50) NOT NULL,
    [PLAN_DEFINITION_ID]    NVARCHAR (50) NOT NULL,
    [RESERVE_CATEGORY_ID]   INT           NOT NULL,
    [FORECAST_START_DATE]   DATETIME2 (7) NULL,
    [SURFACE_LOSS]          FLOAT (53)    NOT NULL,
    [FUEL_LOSS]             FLOAT (53)    NOT NULL,
    [PROCESS_LOSS]          FLOAT (53)    NOT NULL,
    [TOTAL_GAS_LOSS]        FLOAT (53)    NOT NULL,
    [ON_TIME]               FLOAT (53)    NOT NULL,
    [CACHED_ON_TIME_TYPE]   INT           NOT NULL,
    [ENERGY_CONTENT]        FLOAT (53)    NOT NULL,
    [TECHNICAL_WI]          FLOAT (53)    NOT NULL,
    [REMAINING_SALES_GAS]   FLOAT (53)    NOT NULL,
    [RGIP]                  FLOAT (53)    NOT NULL,
    [HAS_VOLUMETRICS]       TINYINT       NOT NULL,
    [ACTUAL_FORECAST_START] DATETIME2 (7) NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

