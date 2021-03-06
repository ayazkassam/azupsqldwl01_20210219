﻿CREATE TABLE [stage_valnav].[t_budget_ent_other_forecast] (
    [PARENT_ID]      NVARCHAR (50) NOT NULL,
    [FORECAST_TYPE]  INT           NOT NULL,
    [FORECAST_DATE]  DATETIME2 (7) NOT NULL,
    [FORECAST_VALUE] FLOAT (53)    NOT NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

