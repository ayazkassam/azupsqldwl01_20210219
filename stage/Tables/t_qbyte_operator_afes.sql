﻿CREATE TABLE [stage].[t_qbyte_operator_afes] (
    [CREATE_DATE]      DATETIME     NULL,
    [CREATE_USER]      VARCHAR (32) NULL,
    [AFE_NUM]          VARCHAR (10) NULL,
    [CLIENT_ID]        NUMERIC (6)  NULL,
    [OPERATOR_AFE_NUM] VARCHAR (17) NULL,
    [LAST_UPDATE_USER] VARCHAR (30) NULL,
    [LAST_UPDATE_DATE] DATETIME     NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

