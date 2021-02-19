CREATE TABLE [stage_csx_csland].[X_REFERENCE] (
    [SUBSYSTEM]       VARCHAR (1)     NOT NULL,
    [FILE_NUMBER]     CHAR (10)       NOT NULL,
    [FILE_SUB]        CHAR (2)        NOT NULL,
    [REL_SUBSYSTEM]   VARCHAR (1)     NOT NULL,
    [REL_FILE_NUMBER] CHAR (10)       NOT NULL,
    [REL_FILE_SUB]    CHAR (2)        NOT NULL,
    [RELATIONSHIP]    CHAR (10)       NULL,
    [SUB_TYPE_1]      CHAR (10)       NULL,
    [SUB_ALLOC_1]     NUMERIC (11, 8) NULL,
    [SUB_TYPE_2]      CHAR (10)       NULL,
    [SUB_ALLOC_2]     NUMERIC (11, 8) NULL,
    [COMMENTS]        VARCHAR (40)    NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

