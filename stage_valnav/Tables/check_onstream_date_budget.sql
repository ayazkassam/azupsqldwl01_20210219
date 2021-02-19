﻿CREATE TABLE [stage_valnav].[check_onstream_date_budget] (
    [OBJECT_ID] NVARCHAR (50)  NOT NULL,
    [UNIQUE_ID] NVARCHAR (100) NOT NULL,
    [STEP_DATE] DATETIME2 (7)  NOT NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);
