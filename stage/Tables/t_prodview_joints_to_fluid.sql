CREATE TABLE [stage].[t_prodview_joints_to_fluid] (
    [keymigrationsource] VARCHAR (100) NULL,
    [compida]            VARCHAR (100) NULL,
    [cc_num]             VARCHAR (50)  NULL,
    [dttm]               DATE          NULL,
    [calc_dttm_start]    DATE          NULL,
    [calc_dttm_end]      DATE          NULL,
    [joints_to_fluid]    FLOAT (53)    NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

