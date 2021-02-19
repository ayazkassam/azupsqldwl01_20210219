CREATE TABLE [data_mart_metrix].[t_dim_product] (
    [product_code]        VARCHAR (30)  NULL,
    [product_description] VARCHAR (100) NULL,
    [product_sort_order]  INT           NULL,
    [product_group]       VARCHAR (100) NULL,
    [product_group_sort]  INT           NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

