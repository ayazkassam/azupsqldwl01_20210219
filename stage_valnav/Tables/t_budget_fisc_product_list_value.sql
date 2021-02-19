CREATE TABLE [stage_valnav].[t_budget_fisc_product_list_value] (
    [PARENT_ID]     NVARCHAR (50) NOT NULL,
    [PRODUCT_ID]    NVARCHAR (50) NOT NULL,
    [PRODUCT_INDEX] INT           NOT NULL,
    [PRODUCT_CLASS] INT           NOT NULL,
    [IS_PRIMARY]    TINYINT       NOT NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

