﻿CREATE TABLE [stage].[t_ihs_pden_production_month_incr] (
    [PDEN_ID]             VARCHAR (40)    NULL,
    [PDEN_TYPE]           VARCHAR (24)    NULL,
    [SOURCE]              VARCHAR (20)    NULL,
    [YEAR]                NUMERIC (4)     NULL,
    [MONTH]               NUMERIC (2)     NULL,
    [PROD_DATE]           DATETIME        NULL,
    [HOURS]               NUMERIC (6, 1)  NULL,
    [GAS]                 NUMERIC (9, 1)  NULL,
    [WATER]               NUMERIC (8, 1)  NULL,
    [OIL_BT]              NUMERIC (9, 1)  NULL,
    [COND]                NUMERIC (9, 1)  NULL,
    [CUM_GAS]             NUMERIC (11, 1) NULL,
    [CUM_OIL_BT]          NUMERIC (11, 1) NULL,
    [CUM_WATER]           NUMERIC (11, 1) NULL,
    [CUM_COND]            NUMERIC (11, 1) NULL,
    [CUM_HOURS]           NUMERIC (11, 1) NULL,
    [TOTAL_FLUID]         NUMERIC (11, 1) NULL,
    [GAS_CAL_DAY]         NUMERIC (11, 2) NULL,
    [OIL_CAL_DAY]         NUMERIC (11, 2) NULL,
    [WATER_CAL_DAY]       NUMERIC (11, 2) NULL,
    [COND_CAL_DAY]        NUMERIC (11, 2) NULL,
    [TOTAL_FLUID_CAL_DAY] NUMERIC (11, 2) NULL,
    [GAS_ACT_DAY]         NUMERIC (11, 2) NULL,
    [OIL_ACT_DAY]         NUMERIC (11, 2) NULL,
    [WATER_ACT_DAY]       NUMERIC (11, 2) NULL,
    [COND_ACT_DAY]        NUMERIC (11, 2) NULL,
    [TOTAL_FLUID_ACT_DAY] NUMERIC (11, 2) NULL,
    [GOR]                 NUMERIC (14, 6) NULL,
    [WGR]                 NUMERIC (14, 6) NULL,
    [WOR]                 NUMERIC (14, 6) NULL,
    [WCUT]                NUMERIC (14, 6) NULL,
    [OCUT]                NUMERIC (14, 6) NULL,
    [CCUT]                NUMERIC (14, 6) NULL,
    [CGR]                 NUMERIC (14, 6) NULL,
    [GAS_FLUID_RATIO]     NUMERIC (14, 6) NULL,
    [LAST_3_FLUID]        NUMERIC (11, 1) NULL,
    [LAST_3_CCUT]         NUMERIC (11, 1) NULL,
    [LAST_3_OCUT]         NUMERIC (11, 1) NULL,
    [LAST_3_CGR]          NUMERIC (11, 1) NULL,
    [PROVINCE_STATE]      VARCHAR (20)    NOT NULL,
    [ROW_CREATED_BY]      VARCHAR (30)    NULL,
    [ROW_CREATED_DATE]    DATETIME        NULL,
    [ROW_CHANGED_BY]      VARCHAR (30)    NULL,
    [ROW_CHANGED_DATE]    DATETIME        NULL,
    [LAST_PROCESS]        VARCHAR (20)    NULL,
    [BRK_WATER]           NUMERIC (8, 1)  NULL,
    [SRC_WATER]           NUMERIC (8, 1)  NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

