CREATE TABLE [data_mart_metrix].[t_dim_purchaser] (
    [purchaser_id]       INT          NULL,
    [purchaser_name]     VARCHAR (50) NULL,
    [purchaser_grouping] VARCHAR (50) NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

