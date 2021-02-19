CREATE TABLE [data_mart].[t_dim_valnav_gross_net] (
    [gross_net_id]    VARCHAR (50) NULL,
    [parent_id]       VARCHAR (50) NULL,
    [gross_net_alias] VARCHAR (50) NULL,
    [unary_operator]  VARCHAR (5)  NULL,
    [sort_key]        VARCHAR (5)  NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

