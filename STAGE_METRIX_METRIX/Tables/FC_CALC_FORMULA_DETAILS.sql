CREATE TABLE [STAGE_METRIX_METRIX].[FC_CALC_FORMULA_DETAILS] (
    [SYS_ID]                  NUMERIC (16)    NOT NULL,
    [CREATE_USER]             VARCHAR (30)    NOT NULL,
    [CREATE_DATE_TIME]        DATETIME2 (7)   NOT NULL,
    [PRODUCTION_DATE]         NUMERIC (6)     NOT NULL,
    [JOB_ID]                  NUMERIC (16)    NULL,
    [FACILITY_TYPE]           VARCHAR (16)    NULL,
    [FACILITY_ID]             VARCHAR (16)    NULL,
    [PRODUCT_CODE]            VARCHAR (16)    NULL,
    [CHARGE_FACILITY_TYPE]    VARCHAR (16)    NULL,
    [CHARGE_FACILITY_ID]      VARCHAR (16)    NULL,
    [CHARGE_TYPE]             VARCHAR (16)    NULL,
    [FC_SEQUENCE_NUMBER]      NUMERIC (4)     NULL,
    [OWNER_ID]                VARCHAR (16)    NULL,
    [FORMULA_ID]              VARCHAR (16)    NULL,
    [SEQUENCE_NUMBER]         NUMERIC (2)     NULL,
    [CALCULATION_DESCRIPTION] VARCHAR (120)   NULL,
    [FACTOR]                  NUMERIC (18, 8) NULL,
    [PERCENT_FLAG]            VARCHAR (1)     NULL,
    [MINIMUM]                 NUMERIC (18, 8) NULL,
    [MAXIMUM]                 NUMERIC (18, 8) NULL,
    [RESULT_SIGN]             VARCHAR (6)     NULL,
    [RESULT_FACTOR]           NUMERIC (18, 8) NULL,
    [SUBTOTAL]                NUMERIC (18, 8) NULL,
    [CONTROL_GROUP_ID]        VARCHAR (16)    NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

