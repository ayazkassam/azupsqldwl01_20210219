CREATE TABLE [data_mart].[t_dim_valnav_normalized_time] (
    [normalized_time_key] VARCHAR (5)  NULL,
    [day_number]          INT          NULL,
    [day_name]            VARCHAR (26) NOT NULL,
    [week_number]         INT          NULL,
    [week_name]           VARCHAR (22) NULL,
    [month_name]          VARCHAR (8)  NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

