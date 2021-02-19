CREATE TABLE [STAGE_METRIX_METRIX].[PARTNER_OP_BATTERY_PRICES] (
    [SYS_ID]                         NUMERIC (16)    NOT NULL,
    [CREATE_USER]                    VARCHAR (30)    NOT NULL,
    [CREATE_PROGRAM]                 VARCHAR (120)   NULL,
    [CREATE_DATE_TIME]               DATETIME2 (7)   NOT NULL,
    [LAST_UPDATE_USER]               VARCHAR (30)    NOT NULL,
    [LAST_UPDATE_PROGRAM]            VARCHAR (120)   NULL,
    [LAST_UPDATE_DATE_TIME]          DATETIME2 (7)   NOT NULL,
    [LAST_UPDATE_AUDIT_ID]           NUMERIC (16)    NULL,
    [VERSION]                        NUMERIC (10)    NOT NULL,
    [PRODUCTION_DATE]                NUMERIC (6)     NOT NULL,
    [BATTERY_FACILITY_ID]            VARCHAR (16)    NOT NULL,
    [PRODUCT_CODE]                   VARCHAR (16)    NOT NULL,
    [TRANSACTION_TYPE]               VARCHAR (6)     NOT NULL,
    [OWNER_ID]                       VARCHAR (16)    NULL,
    [PURCHASER_SEQUENCE_NUMBER]      NUMERIC (2)     NULL,
    [DESTINATION_FACILITY_SYS_ID]    NUMERIC (16)    NULL,
    [DESTINATION_DELIVERY_SYSTEM_ID] VARCHAR (16)    NULL,
    [ALLOCATION_BASIS_CODE]          VARCHAR (6)     NOT NULL,
    [PRICING_CODE]                   VARCHAR (6)     NOT NULL,
    [ENTERED_PRICE]                  NUMERIC (12, 8) NULL,
    [ENTERED_VALUE]                  NUMERIC (11, 2) NULL,
    [FACILITY_SYS_ID]                NUMERIC (16)    NULL,
    [USER_DEFINED1]                  VARCHAR (16)    NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

