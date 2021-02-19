CREATE TABLE [data_mart_metrix].[t_dim_control_group] (
    [control_group_id]                  VARCHAR (50)  NULL,
    [control_group_name]                VARCHAR (150) NULL,
    [control_group_region]              VARCHAR (50)  NULL,
    [pa_responsible_user_id]            VARCHAR (50)  NULL,
    [control_group_pa_responsible_user] VARCHAR (250) NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

