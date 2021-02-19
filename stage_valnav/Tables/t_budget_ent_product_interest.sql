CREATE TABLE [stage_valnav].[t_budget_ent_product_interest] (
    [OBJECT_ID]             NVARCHAR (50)   NOT NULL,
    [PARENT_ID]             NVARCHAR (50)   NOT NULL,
    [PRODUCT]               NVARCHAR (50)   NOT NULL,
    [START_DATE]            DATETIME2 (7)   NULL,
    [CUSTOM_DATA]           NVARCHAR (4000) NULL,
    [USE_MANUAL_ROYALTY]    TINYINT         NULL,
    [AFFECTED_BY_CALC_DATE] TINYINT         NULL,
    [END_DATE]              DATETIME2 (7)   NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

