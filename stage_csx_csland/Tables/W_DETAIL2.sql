﻿CREATE TABLE [stage_csx_csland].[W_DETAIL2] (
    [FILE_NUMBER]        CHAR (10)      NOT NULL,
    [CONTRACT_OPERATOR]  CHAR (6)       NULL,
    [RESERVE]            CHAR (10)      NULL,
    [FACILITY]           CHAR (10)      NULL,
    [FIELD]              CHAR (20)      NULL,
    [POOL]               CHAR (20)      NULL,
    [LICENCE_NUMBER]     VARCHAR (10)   NULL,
    [LICENCE_DATE]       DATE           NULL,
    [EXPIRY_DATE]        DATE           NULL,
    [SURFACE_LOCATION]   VARCHAR (20)   NULL,
    [METES]              NUMERIC (6, 1) NULL,
    [METES_DIRECTION]    VARCHAR (1)    NULL,
    [BOUNDS]             NUMERIC (6, 1) NULL,
    [BOUNDS_DIRECTION]   VARCHAR (1)    NULL,
    [LAHEE_CLASS]        VARCHAR (20)   NULL,
    [DSU]                NUMERIC (5, 1) NULL,
    [DSU_UOM]            VARCHAR (1)    NULL,
    [ACCOUNTING_PROJECT] VARCHAR (16)   NULL,
    [PROJECTED_DEPTH]    NUMERIC (7, 1) NULL,
    [TOTAL_DEPTH]        NUMERIC (7, 1) NULL,
    [TRUE_VERT_DEPTH]    NUMERIC (7, 1) NULL,
    [PLUG_BACK_DEPTH]    NUMERIC (7, 1) NULL,
    [GROUND_ELEVATION]   NUMERIC (7, 1) NULL,
    [KELLY_BUSHING_ELEV] NUMERIC (7, 1) NULL,
    [UNIT_OF_MEASURE]    VARCHAR (1)    NULL,
    [TOTAL_DEPTH_ZONE]   CHAR (10)      NULL,
    [PRODUCING_ZONE]     CHAR (10)      NOT NULL,
    [TARGET_ZONE]        CHAR (10)      NULL,
    [GOVT_UNIT_CODE]     CHAR (20)      NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);
