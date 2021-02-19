CREATE TABLE [stage_valnav].[t_budget_fisc_op_cost] (
    [OBJECT_ID]               NVARCHAR (50) NOT NULL,
    [NAME]                    NVARCHAR (50) NOT NULL,
    [COST_TYPE]               INT           NOT NULL,
    [INTEREST_TYPE]           INT           NOT NULL,
    [CALC_BEHAVIOUR]          INT           NOT NULL,
    [COUNTRY_ID]              NVARCHAR (50) NULL,
    [IS_INTERNATIONAL]        TINYINT       NOT NULL,
    [OVERRIDES_ID]            NVARCHAR (50) NULL,
    [INCLUDE_IN_GCA_CALC]     TINYINT       NOT NULL,
    [IS_VISIBLE]              TINYINT       NOT NULL,
    [OP_COST_TYPE]            INT           NOT NULL,
    [PRODUCT_LIST_TYPE]       INT           NOT NULL,
    [SEPARATE_MAJOR_PRODUCTS] TINYINT       NOT NULL,
    [SORT_INDEX]              INT           NOT NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

