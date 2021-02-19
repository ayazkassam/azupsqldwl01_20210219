CREATE TABLE [data_mart_metrix].[t_dim_sales_type] (
    [op_non_op]           VARCHAR (30)  NULL,
    [sales_type_code]     VARCHAR (30)  NULL,
    [sales_type]          VARCHAR (100) NULL,
    [sales_type_sort_key] INT           NULL,
    [is_sales]            INT           NULL,
    [is_royalty]          INT           NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

