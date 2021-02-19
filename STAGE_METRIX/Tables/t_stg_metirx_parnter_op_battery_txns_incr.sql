﻿CREATE TABLE [STAGE_METRIX].[t_stg_metirx_parnter_op_battery_txns_incr] (
    [CREATE_USER]                    VARCHAR (30)    NOT NULL,
    [CREATE_PROGRAM]                 VARCHAR (120)   NULL,
    [CREATE_DATE_TIME]               DATETIME2 (7)   NOT NULL,
    [LAST_UPDATE_USER]               VARCHAR (30)    NOT NULL,
    [LAST_UPDATE_PROGRAM]            VARCHAR (120)   NULL,
    [LAST_UPDATE_DATE_TIME]          DATETIME2 (7)   NOT NULL,
    [LAST_UPDATE_AUDIT_ID]           NUMERIC (16)    NULL,
    [VERSION]                        NUMERIC (10)    NOT NULL,
    [SYS_ID]                         NUMERIC (16)    NOT NULL,
    [PRODUCTION_DATE]                NUMERIC (6)     NOT NULL,
    [TRANSACTION_TYPE]               VARCHAR (6)     NOT NULL,
    [ENTERED_GROSS_VOLUME]           NUMERIC (9, 1)  NULL,
    [ENTERED_GROSS_VALUE]            NUMERIC (11, 2) NULL,
    [ENTERED_GROSS_GIGAJOULES]       NUMERIC (12)    NULL,
    [CALCULATED_GROSS_VOLUME]        NUMERIC (9, 1)  NULL,
    [CALCULATED_GROSS_VALUE]         NUMERIC (11, 2) NULL,
    [CALCULATED_GROSS_GIGAJOULES]    NUMERIC (12)    NULL,
    [ENTERED_NET_VOLUME]             NUMERIC (9, 1)  NULL,
    [ENTERED_NET_VALUE]              NUMERIC (11, 2) NULL,
    [ENTERED_NET_GIGAJOULES]         NUMERIC (12)    NULL,
    [CALCULATED_NET_VOLUME]          NUMERIC (9, 1)  NULL,
    [CALCULATED_NET_VALUE]           NUMERIC (11, 2) NULL,
    [CALCULATED_NET_GIGAJOULES]      NUMERIC (12)    NULL,
    [TAX_TYPE]                       VARCHAR (6)     NULL,
    [PRODUCING_HOURS]                NUMERIC (3)     NULL,
    [WELLHEAD_GAS_PRODUCTION]        NUMERIC (9, 1)  NULL,
    [BATTERY_FACILITY_ID]            VARCHAR (16)    NOT NULL,
    [OWNER_ID]                       VARCHAR (16)    NULL,
    [WELL_ID]                        VARCHAR (16)    NOT NULL,
    [PRODUCT_CODE]                   VARCHAR (16)    NULL,
    [WELLHEAD_OIL_PRODUCTION]        NUMERIC (9, 1)  NULL,
    [PURCHASER_SEQUENCE_NUMBER]      NUMERIC (2)     NULL,
    [DESTINATION_FACILITY_SYS_ID]    NUMERIC (16)    NULL,
    [DESTINATION_DELIVERY_SYSTEM_ID] VARCHAR (16)    NULL,
    [PRICING_CODE]                   VARCHAR (6)     NULL,
    [ALLOCATION_BASIS_CODE]          VARCHAR (6)     NULL,
    [ENTERED_PRICE]                  NUMERIC (12, 8) NULL,
    [ENTERED_VALUE]                  NUMERIC (11, 2) NULL,
    [PRICING_USER_DEFINED1]          VARCHAR (16)    NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

