﻿CREATE TABLE [stage_ihs].[t_fact_accumap] (
    [uwi]                        VARCHAR (40)    NOT NULL,
    [activity_date]              INT             NULL,
    [on_prod_date_key]           INT             NOT NULL,
    [spud_date_key]              INT             NOT NULL,
    [rig_release_date_key]       INT             NOT NULL,
    [License_Number]             VARCHAR (30)    NULL,
    [operator]                   VARCHAR (20)    NULL,
    [normalized_days_key]        VARCHAR (5)     NOT NULL,
    [gas_metric_volume]          FLOAT (53)      NULL,
    [gas_imperial_volume]        FLOAT (53)      NULL,
    [gas_boe_volume]             FLOAT (53)      NULL,
    [gas_mcfe_volume]            FLOAT (53)      NULL,
    [oil_metric_volume]          NUMERIC (38, 4) NULL,
    [oil_imperial_volume]        NUMERIC (38, 6) NULL,
    [oil_boe_volume]             NUMERIC (38, 6) NULL,
    [oil_mcfe_volume]            NUMERIC (38, 6) NULL,
    [condensate_metric_volume]   FLOAT (53)      NULL,
    [condensate_imperial_volume] FLOAT (53)      NULL,
    [condensate_boe_volume]      FLOAT (53)      NULL,
    [condensate_mcfe_volume]     FLOAT (53)      NULL,
    [water_metric_volume]        FLOAT (53)      NULL,
    [water_imperial_volume]      FLOAT (53)      NULL,
    [water_boe_volume]           FLOAT (53)      NULL,
    [water_mcfe_volume]          FLOAT (53)      NULL,
    [total_boe_volume]           FLOAT (53)      NULL,
    [p_hours]                    FLOAT (53)      NULL,
    [day_counter]                INT             NULL,
    [prodmth_day_counter]        NUMERIC (8, 2)  NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

