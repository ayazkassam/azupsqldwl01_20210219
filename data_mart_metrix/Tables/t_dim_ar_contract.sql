CREATE TABLE [data_mart_metrix].[t_dim_ar_contract] (
    [ar_contract] VARCHAR (200) NULL,
    [sort_key]    VARCHAR (50)  NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

