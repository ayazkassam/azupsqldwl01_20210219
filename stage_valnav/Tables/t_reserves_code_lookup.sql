﻿CREATE TABLE [stage_valnav].[t_reserves_code_lookup] (
    [CODE_TYPE]  NVARCHAR (50) NULL,
    [CODE_VALUE] INT           NULL,
    [LONG_NAME]  NVARCHAR (50) NULL,
    [SHORT_NAME] NVARCHAR (50) NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

