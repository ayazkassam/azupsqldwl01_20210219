CREATE TABLE [data_mart].[t_dim_valnav_reserve_category] (
    [reserve_category_id]    VARCHAR (50)  NULL,
    [parent_id]              VARCHAR (50)  NULL,
    [reserve_category_alias] VARCHAR (100) NULL,
    [unary_operator]         VARCHAR (5)   NULL,
    [sort_key]               VARCHAR (5)   NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

