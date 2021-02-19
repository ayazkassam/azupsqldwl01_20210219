CREATE TABLE [stage_csx_csland].[C_SUB] (
    [FILE_NUMBER]       CHAR (10)       NOT NULL,
    [FILE_SUB]          CHAR (2)        NOT NULL,
    [REASON_FOR_SUB]    VARCHAR (40)    NULL,
    [FILE_STATUS]       CHAR (10)       NOT NULL,
    [STATUS_DATE]       DATE            NOT NULL,
    [DIVISION]          CHAR (10)       NOT NULL,
    [AREA]              CHAR (10)       NOT NULL,
    [OPERATOR]          CHAR (6)        NULL,
    [TRACT_PARTIC]      NUMERIC (11, 8) NULL,
    [PROJECT_NUMBER]    VARCHAR (16)    NULL,
    [EUB_FACILITY_CODE] VARCHAR (15)    NULL,
    [CAP_PCNT_INT_YN]   VARCHAR (1)     NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);

