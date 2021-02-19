CREATE TABLE [stage].[t_ctrl_volumes_valnav_time_period] (
    [dates]      DATETIME     NULL,
    [year_month] VARCHAR (32) NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

