﻿CREATE TABLE [stage].[t_ihs_pden_prod_zone] (
    [PDEN_ID]           VARCHAR (40)   NOT NULL,
    [PDEN_TYPE]         VARCHAR (24)   NOT NULL,
    [SOURCE]            VARCHAR (20)   NOT NULL,
    [STRAT_UNIT_ID]     VARCHAR (20)   NOT NULL,
    [TOP_DEPTH]         NUMERIC (9, 2) NULL,
    [BASE_DEPTH]        NUMERIC (9, 2) NULL,
    [COMPLETION_TOP]    NUMERIC (9, 2) NULL,
    [COMPLETION_BASE]   NUMERIC (9, 2) NULL,
    [PROVINCE_STATE]    VARCHAR (20)   NOT NULL,
    [ROW_CREATED_BY]    VARCHAR (30)   NULL,
    [ROW_CREATED_DATE]  DATE           NULL,
    [ROW_CHANGED_BY]    VARCHAR (30)   NULL,
    [ROW_CHANGED_DATE]  DATE           NULL,
    [ROW_QUALITY]       VARCHAR (20)   NULL,
    [STRAT_UNIT_AGE]    NUMERIC (12)   NULL,
    [BASE_STRAT_AGE]    NUMERIC (12)   NULL,
    [COMPLETION_DATE]   DATE           NULL,
    [PLUGBACK_DATE]     DATE           NULL,
    [STRAT_NAME_SET_ID] VARCHAR (20)   NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

