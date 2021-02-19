CREATE TABLE [data_mart].[t_dim_normalized_time] (
    [normalized_time_key] VARCHAR (5)  NULL,
    [day_number]          INT          NULL,
    [day_name]            VARCHAR (20) NOT NULL,
    [week_number]         INT          NULL,
    [week_name]           VARCHAR (22) NULL,
    [month_name]          VARCHAR (8)  NULL,
    [day_name2]           VARCHAR (20) NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

