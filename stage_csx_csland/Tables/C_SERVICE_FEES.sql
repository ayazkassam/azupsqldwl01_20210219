﻿CREATE TABLE [stage_csx_csland].[C_SERVICE_FEES] (
    [FILE_NUMBER]       CHAR (10)       NOT NULL,
    [LOC_OCCURRENCE]    NUMERIC (6)     NOT NULL,
    [FEE_OCCURRENCE]    NUMERIC (6)     NOT NULL,
    [HIST_OCCURRENCE]   NUMERIC (6)     NOT NULL,
    [EFFECTIVE_DATE]    DATE            NULL,
    [TERMINATION_DATE]  DATE            NULL,
    [PROC_WL]           CHAR (1)        NULL,
    [PROC_WELL_NUMBER]  CHAR (10)       NULL,
    [PROC_UWI]          VARCHAR (16)    NULL,
    [PROC_SORTED_UWI]   VARCHAR (16)    NULL,
    [PROC_DESCRIPTION]  VARCHAR (1910)  NULL,
    [PROC_PROJECT]      VARCHAR (16)    NULL,
    [SERVICE_TYPE]      CHAR (10)       NULL,
    [SERVICE_TERM_DATE] DATE            NULL,
    [FEE_CAPITAL]       NUMERIC (11, 4) NULL,
    [FEE_OPERATING]     NUMERIC (11, 4) NULL,
    [FEE_BASIS]         CHAR (10)       NULL,
    [FEE_EFFECT_DATE]   DATE            NULL,
    [INPUT_DATE]        DATE            NULL,
    [REASON_FOR_CHANGE] VARCHAR (40)    NULL,
    [ASC_YN]            VARCHAR (10)    NULL,
    [GROSS_NET_GN]      VARCHAR (1)     NULL,
    [PA_FACILITY_ID]    VARCHAR (6)     NULL,
    [VOLUME_BASIS_GIS]  VARCHAR (1)     NULL,
    [VARIABLE_FEE]      VARCHAR (1)     NOT NULL,
    [COMMENTS]          VARCHAR (120)   NULL,
    [DP_UWI]            VARCHAR (16)    NULL,
    [DP_DESC]           VARCHAR (40)    NULL,
    [AP_UWI]            VARCHAR (16)    NULL,
    [AP_DESC]           VARCHAR (40)    NULL,
    [COST_CENTRE_NUM]   VARCHAR (16)    NULL,
    [NET_PCT]           NUMERIC (11, 8) NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

