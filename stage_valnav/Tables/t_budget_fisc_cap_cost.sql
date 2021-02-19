CREATE TABLE [stage_valnav].[t_budget_fisc_cap_cost] (
    [OBJECT_ID]                 NVARCHAR (50) NOT NULL,
    [NAME]                      NVARCHAR (50) NOT NULL,
    [COST_TYPE]                 INT           NOT NULL,
    [INTEREST_TYPE]             INT           NOT NULL,
    [CALC_BEHAVIOUR]            INT           NOT NULL,
    [COUNTRY_ID]                NVARCHAR (50) NULL,
    [IS_INTERNATIONAL]          TINYINT       NOT NULL,
    [OVERRIDES_ID]              NVARCHAR (50) NULL,
    [INCLUDE_IN_GCA_CALC]       TINYINT       NOT NULL,
    [IS_VISIBLE]                TINYINT       NOT NULL,
    [CAP_COST_CATEGORY]         INT           NOT NULL,
    [SUCCESS_TAX_POOL_ID]       NVARCHAR (50) NULL,
    [FAILURE_TAX_POOL_ID]       NVARCHAR (50) NULL,
    [INCLUDE_IN_REVERSION_CALC] TINYINT       NOT NULL,
    [SORT_INDEX]                INT           NOT NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

