﻿CREATE TABLE [stage_ihs].[t_ihs_pden] (
    [PDEN_ID]                    VARCHAR (40)    NOT NULL,
    [PDEN_TYPE]                  VARCHAR (24)    NOT NULL,
    [SOURCE]                     VARCHAR (20)    NOT NULL,
    [ACTIVE_IND]                 VARCHAR (1)     NULL,
    [COUNTRY]                    VARCHAR (20)    NULL,
    [CURRENT_OPERATOR]           VARCHAR (20)    NULL,
    [CURRENT_PROD_STR_NAME]      VARCHAR (60)    NULL,
    [CURRENT_STATUS_DATE]        DATETIME        NULL,
    [CURRENT_WELL_STR_NUMBER]    VARCHAR (20)    NULL,
    [DISTRICT]                   VARCHAR (20)    NULL,
    [EFFECTIVE_DATE]             DATETIME        NULL,
    [ENHANCED_RECOVERY_TYPE]     VARCHAR (20)    NULL,
    [EXPIRY_DATE]                DATETIME        NULL,
    [FIELD_ID]                   VARCHAR (20)    NULL,
    [GEOGRAPHIC_REGION]          VARCHAR (20)    NULL,
    [GEOLOGIC_PROVINCE]          VARCHAR (20)    NULL,
    [LAST_INJECTION_DATE]        DATETIME        NULL,
    [LAST_PRODUCTION_DATE]       DATETIME        NULL,
    [LAST_REPORTED_DATE]         DATETIME        NULL,
    [LOCATION_DESC]              VARCHAR (40)    NULL,
    [LOCATION_DESC_TYPE]         VARCHAR (20)    NULL,
    [ON_INJECTION_DATE]          DATETIME        NULL,
    [ON_PRODUCTION_DATE]         DATETIME        NULL,
    [PDEN_NAME]                  VARCHAR (60)    NULL,
    [PDEN_SHORT_NAME]            VARCHAR (30)    NULL,
    [PDEN_STATUS]                VARCHAR (20)    NULL,
    [PLOT_NAME]                  VARCHAR (20)    NULL,
    [PLOT_SYMBOL]                VARCHAR (20)    NULL,
    [POOL_ID]                    VARCHAR (20)    NULL,
    [PPDM_GUID]                  VARCHAR (38)    NULL,
    [PRIMARY_PRODUCT]            VARCHAR (20)    NULL,
    [PRODUCTION_METHOD]          VARCHAR (20)    NULL,
    [PROPRIETARY_IND]            VARCHAR (1)     NULL,
    [PROVINCE_STATE]             VARCHAR (20)    NULL,
    [REMARK]                     VARCHAR (2000)  NULL,
    [STATE_OR_FEDERAL_WATERS]    VARCHAR (20)    NULL,
    [STRAT_NAME_SET_ID]          VARCHAR (20)    NULL,
    [STRAT_UNIT_ID]              VARCHAR (20)    NULL,
    [STRING_SERIAL_NUMBER]       VARCHAR (20)    NULL,
    [ROW_CHANGED_BY]             VARCHAR (30)    NULL,
    [ROW_CHANGED_DATE]           DATETIME        NULL,
    [ROW_CREATED_BY]             VARCHAR (30)    NULL,
    [ROW_CREATED_DATE]           DATETIME        NULL,
    [ROW_QUALITY]                VARCHAR (20)    NULL,
    [X_TOP_DEPTH]                NUMERIC (10, 5) NULL,
    [X_BASE_DEPTH]               NUMERIC (10, 5) NULL,
    [X_UNIT_ID]                  VARCHAR (20)    NULL,
    [X_ALLOW_TYPE]               VARCHAR (20)    NULL,
    [X_BLOCK_ID]                 VARCHAR (20)    NULL,
    [X_PSU_SURPLUS_IND]          VARCHAR (1)     NULL,
    [X_PROJECT_ID]               VARCHAR (20)    NULL,
    [X_PROD_FREQ]                VARCHAR (20)    NULL,
    [X_PROD_SPACING_UNIT]        VARCHAR (20)    NULL,
    [X_UNIT_OIL_INTEREST]        NUMERIC (12, 8) NULL,
    [X_UNIT_GAS_INTEREST]        NUMERIC (12, 8) NULL,
    [X_SPECIAL_PSU_SURPLUS]      VARCHAR (1)     NULL,
    [X_SPECIAL_PENALTY_RELIEF]   VARCHAR (20)    NULL,
    [X_PENALTY_RELIEF]           VARCHAR (20)    NULL,
    [X_SET_GOR_DATE]             DATETIME        NULL,
    [X_SET_GOR]                  NUMERIC (5)     NULL,
    [X_PEND_S4_IND]              VARCHAR (1)     NULL,
    [X_FACILITY_ID]              VARCHAR (20)    NULL,
    [X_CONTROL_WELL_IND]         VARCHAR (1)     NULL,
    [X_OIL_DENSITY]              VARCHAR (20)    NULL,
    [X_OFF_TARGET]               VARCHAR (1)     NULL,
    [X_DISP_INJ_APPROVAL]        VARCHAR (20)    NULL,
    [X_DISP_INJ_APPROVAL_NUMBER] NUMERIC (5)     NULL,
    [X_WELLHEAD_PRESS]           NUMERIC (8, 2)  NULL,
    [X_BATTERY_ID]               VARCHAR (20)    NULL,
    [X_COMMINGLED]               VARCHAR (1)     NULL,
    [TOP_STRAT_AGE]              NUMERIC (12)    NULL,
    [BASE_STRAT_AGE]             NUMERIC (12)    NULL,
    [X_ONPROD_OIL]               DATETIME        NULL,
    [X_ONPROD_GAS]               DATETIME        NULL,
    [X_ONPROD_WATER]             DATETIME        NULL,
    [FACILITY_TYPE]              VARCHAR (20)    NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);
