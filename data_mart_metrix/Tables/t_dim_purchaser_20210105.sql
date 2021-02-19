CREATE TABLE [data_mart_metrix].[t_dim_purchaser_20210105] (
    [purchaser_id]       INT          NULL,
    [purchaser_name]     VARCHAR (50) NULL,
    [purchaser_grouping] VARCHAR (50) NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);

