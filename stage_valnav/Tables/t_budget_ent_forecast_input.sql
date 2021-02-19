CREATE TABLE [stage_valnav].[t_budget_ent_forecast_input] (
    [OBJECT_ID]              NVARCHAR (50) NOT NULL,
    [PARENT_ID]              NVARCHAR (50) NOT NULL,
    [FORECAST_PRODUCT_ID]    NVARCHAR (50) NOT NULL,
    [CONSTANT_VALUE]         FLOAT (53)    NULL,
    [CONSTANT_FORECAST_TYPE] INT           NULL,
    [IS_ACTIVE]              TINYINT       NOT NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

