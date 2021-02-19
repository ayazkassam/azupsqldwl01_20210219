CREATE TABLE [STAGE_METRIX_METRIX].[ROYALTY_CALC_FORMULA_DETAILS] (
    [SYS_ID]                  NUMERIC (16)    NULL,
    [CREATE_USER]             VARCHAR (30)    NULL,
    [CREATE_DATE_TIME]        DATETIME2 (7)   NULL,
    [PRODUCTION_DATE]         NUMERIC (6)     NULL,
    [JOB_ID]                  NUMERIC (16)    NULL,
    [RECORD_TYPE]             VARCHAR (6)     NULL,
    [FACILITY_TYPE]           VARCHAR (16)    NULL,
    [FACILITY_ID]             VARCHAR (16)    NULL,
    [WELL_TRACT_TYPE]         VARCHAR (16)    NULL,
    [WELL_TRACT_ID]           VARCHAR (16)    NULL,
    [OBLIGATION_ID]           VARCHAR (16)    NULL,
    [SEQUENCE_NUMBER]         NUMERIC (3)     NULL,
    [CALCULATION_DESCRIPTION] VARCHAR (160)   NULL,
    [FACTOR]                  NUMERIC (18, 8) NULL,
    [PERCENT_FLAG]            VARCHAR (1)     NULL,
    [MINIMUM]                 NUMERIC (18, 8) NULL,
    [MAXIMUM]                 NUMERIC (18, 8) NULL,
    [RESULT_SIGN]             VARCHAR (6)     NULL,
    [RESULT_FACTOR]           NUMERIC (18, 8) NULL,
    [SUBTOTAL]                NUMERIC (18, 8) NULL,
    [PRODUCT]                 VARCHAR (16)    NULL,
    [RON_PRODUCT]             VARCHAR (16)    NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

