CREATE TABLE [data_mart_metrix].[t_dim_royalty_obligation_sequence] (
    [royalty_obligation_sequence] VARCHAR (10) NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

