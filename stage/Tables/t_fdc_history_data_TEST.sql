﻿CREATE TABLE [stage].[t_fdc_history_data_TEST] (
    [SITE_ID]                 VARCHAR (30)  NULL,
    [ACTVY_DATE]              DATE          NULL,
    [PERIOD]                  VARCHAR (10)  NULL,
    [YEARS]                   VARCHAR (5)   NULL,
    [PRODUCTION_DAYS_ON]      NUMERIC (18)  NULL,
    [PRODUCTION_DAYS_ON_ID]   VARCHAR (5)   NULL,
    [CC_HIERARCHY]            VARCHAR (500) NULL,
    [WELL_STATUS]             VARCHAR (100) NULL,
    [PRIMARY_PRODUCT]         VARCHAR (100) NULL,
    [CC_TYPE]                 VARCHAR (100) NULL,
    [SCENARIO]                VARCHAR (50)  NULL,
    [DATA_TYPE]               VARCHAR (10)  NOT NULL,
    [ORGANIZATIONS]           VARCHAR (200) NULL,
    [GRS_NET]                 VARCHAR (12)  NULL,
    [OP_NONOP]                VARCHAR (25)  NULL,
    [CONTRACT_OP]             VARCHAR (25)  NULL,
    [BATTERY_NUM]             VARCHAR (5)   NULL,
    [ESSBASE_UWI]             VARCHAR (20)  NULL,
    [RUN_ID]                  VARCHAR (30)  NULL,
    [BASE_INCR]               VARCHAR (15)  NULL,
    [PLAY]                    VARCHAR (30)  NULL,
    [ACQUISITION]             VARCHAR (30)  NULL,
    [ONSTREAM_DATE]           DATE          NULL,
    [ONSTREAM_YEAR]           VARCHAR (30)  NULL,
    [OWNER_ID]                VARCHAR (10)  NULL,
    [HOURS_ON]                FLOAT (53)    NULL,
    [HOURS_DOWN]              FLOAT (53)    NULL,
    [GAS_MET_VOL_DLY]         FLOAT (53)    NULL,
    [GAS_IMP_VOL_DLY]         FLOAT (53)    NULL,
    [GAS_BOE_VOL_DLY]         FLOAT (53)    NULL,
    [GAS_MCFE_VOL_DLY]        FLOAT (53)    NULL,
    [OIL_MET_VOL_DLY]         FLOAT (53)    NULL,
    [OIL_IMP_VOL_DLY]         FLOAT (53)    NULL,
    [OIL_BOE_VOL_DLY]         FLOAT (53)    NULL,
    [OIL_MCFE_VOL_DLY]        FLOAT (53)    NULL,
    [NGL_MET_VOL_DLY]         FLOAT (53)    NULL,
    [NGL_IMP_VOL_DLY]         FLOAT (53)    NULL,
    [NGL_BOE_VOL_DLY]         FLOAT (53)    NULL,
    [NGL_MCFE_VOL_DLY]        FLOAT (53)    NULL,
    [CONDENSATE_MET_VOL_DLY]  FLOAT (53)    NULL,
    [CONDENSATE_IMP_VOL_DLY]  FLOAT (53)    NULL,
    [CONDENSATE_BOE_VOL_DLY]  FLOAT (53)    NULL,
    [CONDENSATE_MCFE_VOL_DLY] FLOAT (53)    NULL,
    [WATER_MET_VOL_DLY]       FLOAT (53)    NULL,
    [WATER_IMP_VOL_DLY]       FLOAT (53)    NULL,
    [WATER_BOE_VOL_DLY]       FLOAT (53)    NULL,
    [WATER_MCFE_VOL_DLY]      FLOAT (53)    NULL,
    [TOTAL_BOE_VOL_DLY]       FLOAT (53)    NULL,
    [WELL_HEAD_PRESSURE]      FLOAT (53)    NULL,
    [INJECTED_SRC_WATER]      FLOAT (53)    NULL,
    [INJECTED_PROD_WATER]     FLOAT (53)    NULL,
    [INJECTED_GAS]            FLOAT (53)    NULL,
    [INJECTED_CO2]            FLOAT (53)    NULL,
    [CASING_PRESSURE]         FLOAT (53)    NULL,
    [TUBING_PRESSURE]         FLOAT (53)    NULL,
    [JOINTS_IN_HOLE]          FLOAT (53)    NULL,
    [INJECTION_PRESSURE]      FLOAT (53)    NULL,
    [CHOKE_SIZE]              FLOAT (53)    NULL,
    [SWB_WHEAD_BSW_CUT]       FLOAT (53)    NULL,
    [SWB_WHEAD_SAND_CUT]      FLOAT (53)    NULL,
    [STROKE_SPEED]            FLOAT (53)    NULL,
    [ROTARY_SPEED]            FLOAT (53)    NULL,
    [ELECTRIC_CURRENT]        FLOAT (53)    NULL,
    [USD]                     FLOAT (53)    NULL,
    [CAD]                     FLOAT (53)    NULL,
    [DATA_SOURCE]             VARCHAR (50)  NULL,
    [SITE_TYPE]               VARCHAR (50)  NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);
