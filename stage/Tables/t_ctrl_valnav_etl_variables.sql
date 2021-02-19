CREATE TABLE [stage].[t_ctrl_valnav_etl_variables] (
    [variable_name]     VARCHAR (200)  NULL,
    [variable_value]    VARCHAR (200)  NULL,
    [comments]          VARCHAR (2000) NULL,
    [cube_dimension]    VARCHAR (200)  NULL,
    [cube_child_member] VARCHAR (200)  NULL,
    [sign_flip_flag]    VARCHAR (1)    NULL,
    [archive_scenario]  VARCHAR (200)  NULL,
    [date_value]        DATETIME       NULL,
    [int_value]         INT            NULL,
    [TEXT1]             VARCHAR (1000) NULL,
    [TEXT2]             VARCHAR (1000) NULL,
    [description]       VARCHAR (1000) NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

