CREATE TABLE [STAGE_METRIX_METRIX].[MARKET_MASTER_PURCH_PRICES] (
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
    [PRICE_CODE]                     VARCHAR (6)     NULL,
    [INPUT_PRICE]                    NUMERIC (12, 8) NULL,
    [INPUT_SALES_VALUE]              NUMERIC (11, 2) NULL,
    [TRANSPORTATION_COST]            NUMERIC (13, 5) NULL,
    [TRANSPORTATION_COST_TYPE]       VARCHAR (6)     NULL,
    [TRANSPORTS_GAS]                 VARCHAR (1)     NULL,
    [LINE_LOSS]                      NUMERIC (13, 5) NULL,
    [LINE_LOSS_TYPE]                 VARCHAR (6)     NULL,
    [MARKET_MASTER_PURCHASER_SYS_ID] NUMERIC (16)    NOT NULL,
    [USER_DEFINED1]                  VARCHAR (16)    NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

