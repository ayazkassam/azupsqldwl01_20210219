﻿CREATE TABLE [stage].[t_qbyte_cost_estimate_items] (
    [CREATE_DATE]        DATETIME        NULL,
    [CREATE_USER]        VARCHAR (30)    NULL,
    [LAST_UPDATE_USER]   VARCHAR (30)    NULL,
    [LAST_UPDATE_DATE]   DATETIME        NULL,
    [AFE_NUM]            VARCHAR (10)    NULL,
    [AFE_SUPPLEMENT_NUM] NUMERIC (4)     NULL,
    [AFE_REVISION_NUM]   NUMERIC (4)     NULL,
    [MAJOR_ACCT]         VARCHAR (4)     NULL,
    [MINOR_ACCT]         VARCHAR (4)     NULL,
    [GROSS_COST_EST_AMT] NUMERIC (14, 2) NULL,
    [NET_COST_EST_AMT]   NUMERIC (14, 2) NULL,
    [AFE_ITEM_NUM]       VARCHAR (6)     NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

