﻿CREATE TABLE [stage].[t_stg_focus_area] (
    [AREA]            VARCHAR (100) NULL,
    [FOCUS_AREA_FLAG] VARCHAR (10)  NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

