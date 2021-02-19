CREATE TABLE [data_mart_metrix].[t_dim_purchaser_sequence] (
    [purchaser_sequence] VARCHAR (10) NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

