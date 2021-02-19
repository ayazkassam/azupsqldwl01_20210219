﻿CREATE TABLE [stage_valnav].[t_budget_ent_import_id] (
    [PARENT_ID] NVARCHAR (50)  NOT NULL,
    [VENDOR_ID] NVARCHAR (50)  NOT NULL,
    [UNIQUE_ID] NVARCHAR (100) NOT NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

