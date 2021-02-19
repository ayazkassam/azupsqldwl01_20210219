CREATE TABLE [stage].[t_ctrl_dim_desc_text_excptions] (
    [CUBE_NAME]          VARCHAR (200) NULL,
    [STRING]             VARCHAR (200) NULL,
    [REPLACEMENT_STRING] VARCHAR (200) NULL,
    [INFORMATION]        VARCHAR (200) NULL,
    [IS_ACTIVE]          VARCHAR (1)   NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

