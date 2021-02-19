CREATE TABLE [data_mart].[t_dim_gross_net] (
    [gross_net_key]      INT          NULL,
    [gross_net_id]       VARCHAR (50) NULL,
    [gross_net_alias]    VARCHAR (50) NULL,
    [gross_net_property] VARCHAR (5)  NULL,
    [sort_key]           VARCHAR (5)  NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

