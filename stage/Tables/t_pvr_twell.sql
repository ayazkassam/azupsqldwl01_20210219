﻿CREATE TABLE [stage].[t_pvr_twell] (
    [COMPANY_ID]                VARCHAR (30)     NOT NULL,
    [BATTERY_ID]                VARCHAR (30)     NOT NULL,
    [WELL_ID]                   VARCHAR (30)     NOT NULL,
    [WELL_NAME]                 VARCHAR (40)     NOT NULL,
    [WELL_TYPE]                 VARCHAR (10)     NOT NULL,
    [SURVEY_SYSTEM]             VARCHAR (1)      NOT NULL,
    [WELL_LOCATION]             VARCHAR (26)     NOT NULL,
    [FIELD_LOCATION]            VARCHAR (26)     NOT NULL,
    [TEST_MEASURE_FLAG]         VARCHAR (1)      NOT NULL,
    [NEW_OLD_OIL]               VARCHAR (1)      NULL,
    [TESTS_REQUIRED]            NUMERIC (18)     NOT NULL,
    [WATER_GAS_RATIO]           NUMERIC (12, 5)  NOT NULL,
    [GAS_OIL_RATIO]             NUMERIC (12, 5)  NOT NULL,
    [COND_GAS_RATIO]            NUMERIC (12, 5)  NOT NULL,
    [ROYALTY_HOLIDAY]           VARCHAR (1)      NOT NULL,
    [HORIZONTAL_WELL]           VARCHAR (1)      NOT NULL,
    [COST_CENTRE_ID]            VARCHAR (12)     NOT NULL,
    [HORIZON_POOL]              VARCHAR (30)     NULL,
    [ENTRY_SEQUENCE_NUMBER]     NUMERIC (18)     NOT NULL,
    [GAS_CHARTS]                VARCHAR (1)      NOT NULL,
    [METER_TYPE]                VARCHAR (10)     NOT NULL,
    [TEST_METHOD]               VARCHAR (1)      NOT NULL,
    [WELL_STATUS]               VARCHAR (1)      NOT NULL,
    [LEASE_FUEL_RATE]           NUMERIC (12, 5)  NOT NULL,
    [TRACT_PERCENT]             NUMERIC (11, 8)  NOT NULL,
    [MONITOR_WELL_FLAG]         VARCHAR (1)      NOT NULL,
    [MERAK_LOCATION]            VARCHAR (26)     NULL,
    [ON_PRODUCTION_DATE]        DATE             NOT NULL,
    [SATELLITE_SEQ_ID]          NUMERIC (18)     NULL,
    [PA_INTERFACE]              VARCHAR (30)     NULL,
    [PA_ID]                     VARCHAR (40)     NULL,
    [SUB_CAT_SEQ_ID]            NUMERIC (18)     NULL,
    [INFO_1]                    VARCHAR (40)     NULL,
    [INFO_2]                    VARCHAR (40)     NULL,
    [INFO_3]                    VARCHAR (40)     NULL,
    [OIL_CAPABILITY_PER_DAY]    NUMERIC (20, 10) NULL,
    [OIL_DECLINE_RATE_PER_YEAR] NUMERIC (20, 10) NULL,
    [OIL_CAPABILITY_DATE]       DATE             NULL,
    [GAS_CAPABILITY_PER_DAY]    NUMERIC (20, 10) NULL,
    [GAS_DECLINE_RATE_PER_YEAR] NUMERIC (20, 10) NULL,
    [GAS_CAPABILITY_DATE]       DATE             NULL,
    [DAILY_ALLOWABLE]           NUMERIC (20, 10) NOT NULL,
    [NATIVE_CO2_FRACTION]       NUMERIC (20, 10) NOT NULL,
    [DELIVERY_METER_ID]         VARCHAR (30)     NULL,
    [GOV_BATTERY_CODE]          VARCHAR (10)     NULL,
    [AUTO_LOAD_WIO]             VARCHAR (10)     NOT NULL,
    [OP_NONOP_INDICATOR]        VARCHAR (1)      NOT NULL,
    [RECOMB_LIQ]                VARCHAR (1)      NOT NULL,
    [FLOW_HOURS]                VARCHAR (1)      NOT NULL,
    [UPDT_USER]                 VARCHAR (30)     NOT NULL,
    [UPDT_DTE]                  DATE             NOT NULL,
    [PM_GUID]                   BINARY (32)      NOT NULL,
    [WET_MEASURED_GAS]          VARCHAR (1)      NOT NULL,
    [LINK_FACILITY_SEQ_ID]      NUMERIC (18)     NULL,
    [LINK_FUNC_UNIT_SEQ_ID]     NUMERIC (18)     NULL,
    [OIL_TYPE]                  VARCHAR (1)      NULL,
    [RETURN_FUEL_METER_ID]      VARCHAR (30)     NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

