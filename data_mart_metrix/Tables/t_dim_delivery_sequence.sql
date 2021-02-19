CREATE TABLE [data_mart_metrix].[t_dim_delivery_sequence] (
    [delivery_sequence] VARCHAR (10) NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

