﻿CREATE TABLE [stage].[t_qbyte_codes] (
    [CREATE_DATE]      DATETIME     NULL,
    [CREATE_USER]      VARCHAR (30) NULL,
    [LAST_UPDATE_USER] VARCHAR (30) NULL,
    [LAST_UPDATE_DATE] DATETIME     NULL,
    [CODE]             VARCHAR (30) NULL,
    [CODE_TYPE_CODE]   VARCHAR (30) NULL,
    [CODE_DESC]        VARCHAR (80) NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

