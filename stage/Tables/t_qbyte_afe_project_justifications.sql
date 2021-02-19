CREATE TABLE [stage].[t_qbyte_afe_project_justifications] (
    [CREATE_DATE]           DATETIME     NULL,
    [CREATE_USER]           VARCHAR (30) NULL,
    [AFE_NUM]               VARCHAR (10) NULL,
    [AFE_PROJ_JUST_LINE_ID] NUMERIC (6)  NULL,
    [AFE_PROJ_JUST_DESC]    VARCHAR (80) NULL,
    [LAST_UPDATE_USER]      VARCHAR (30) NULL,
    [LAST_UPDATE_DATE]      DATETIME     NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

