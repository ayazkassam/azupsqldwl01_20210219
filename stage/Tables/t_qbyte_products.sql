CREATE TABLE [stage].[t_qbyte_products] (
    [CREATE_DATE]                  DATETIME         NULL,
    [CREATE_USER]                  VARCHAR (32)     NULL,
    [PROD_CODE]                    VARCHAR (6)      NULL,
    [PROD_NAME]                    VARCHAR (40)     NULL,
    [ACTUAL_MEASURE_SYSTEM_CODE]   VARCHAR (1)      NULL,
    [BUDGET_MEASURE_SYSTEM_CODE]   VARCHAR (1)      NULL,
    [PROD_SHORT_NAME]              VARCHAR (10)     NULL,
    [SI_UNIT]                      VARCHAR (6)      NULL,
    [IMPERIAL_UNIT]                VARCHAR (6)      NULL,
    [SI_TO_IMP_CONV_FACTOR]        NUMERIC (14, 10) NULL,
    [SALES_MAJOR_ACCT]             VARCHAR (4)      NULL,
    [SALES_MINOR_ACCT]             VARCHAR (4)      NULL,
    [BOE_THERMAL]                  NUMERIC (8, 5)   NULL,
    [BOE_ECONOMIC]                 NUMERIC (8, 5)   NULL,
    [M3_THERMAL]                   NUMERIC (8, 5)   NULL,
    [ENERGY_SI_UNIT]               VARCHAR (6)      NULL,
    [ENERGY_IMPERIAL_UNIT]         VARCHAR (6)      NULL,
    [ENERGY_SI_TO_IMP_CONV_FACTOR] NUMERIC (14, 10) NULL,
    [MCFE6_THERMAL]                NUMERIC (8, 5)   NULL,
    [LAST_UPDATE_USER]             VARCHAR (30)     NULL,
    [LAST_UPDATE_DATE]             DATETIME         NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

