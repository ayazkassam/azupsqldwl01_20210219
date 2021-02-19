﻿CREATE TABLE [data_mart].[t_fact_fdc] (
    [site_id]                      VARCHAR (100)   NULL,
    [entity_key]                   VARCHAR (500)   NULL,
    [activity_date_key]            INT             NULL,
    [scenario_key]                 VARCHAR (1000)  NOT NULL,
    [data_type]                    VARCHAR (100)   NULL,
    [gross_net_key]                INT             NOT NULL,
    [gas_metric_volume]            FLOAT (53)      NULL,
    [gas_imperial_volume]          FLOAT (53)      NULL,
    [gas_boe_volume]               FLOAT (53)      NULL,
    [gas_mcfe_volume]              FLOAT (53)      NULL,
    [oil_metric_volume]            FLOAT (53)      NULL,
    [oil_imperial_volume]          FLOAT (53)      NULL,
    [oil_boe_volume]               FLOAT (53)      NULL,
    [oil_mcfe_volume]              FLOAT (53)      NULL,
    [ethane_metric_volume]         FLOAT (53)      NULL,
    [ethane_imperial_volume]       FLOAT (53)      NULL,
    [ethane_boe_volume]            FLOAT (53)      NULL,
    [ethane_mcfe_volume]           FLOAT (53)      NULL,
    [propane_metric_volume]        FLOAT (53)      NULL,
    [propane_imperial_volume]      FLOAT (53)      NULL,
    [propane_boe_volume]           FLOAT (53)      NULL,
    [propane_mcfe_volume]          FLOAT (53)      NULL,
    [butane_metric_volume]         FLOAT (53)      NULL,
    [butane_imperial_volume]       FLOAT (53)      NULL,
    [butane_boe_volume]            FLOAT (53)      NULL,
    [butane_mcfe_volume]           FLOAT (53)      NULL,
    [pentane_metric_volume]        FLOAT (53)      NULL,
    [pentane_imperial_volume]      FLOAT (53)      NULL,
    [pentane_boe_volume]           FLOAT (53)      NULL,
    [pentane_mcfe_volume]          FLOAT (53)      NULL,
    [condensate_metric_volume]     FLOAT (53)      NULL,
    [condensate_imperial_volume]   FLOAT (53)      NULL,
    [condensate_boe_volume]        FLOAT (53)      NULL,
    [condensate_mcfe_volume]       FLOAT (53)      NULL,
    [total_ngl_metric_volume]      FLOAT (53)      NULL,
    [total_ngl_imperial_volume]    FLOAT (53)      NULL,
    [total_ngl_boe_volume]         FLOAT (53)      NULL,
    [total_ngl_mcfe_volume]        FLOAT (53)      NULL,
    [total_liquid_metric_volume]   FLOAT (53)      NULL,
    [total_liquid_imperial_volume] FLOAT (53)      NULL,
    [total_liquid_boe_volume]      FLOAT (53)      NULL,
    [total_liquid_mcfe_volume]     FLOAT (53)      NULL,
    [total_boe_volume]             FLOAT (53)      NULL,
    [water_metric_volume]          FLOAT (53)      NULL,
    [water_imperial_volume]        FLOAT (53)      NULL,
    [water_boe_volume]             FLOAT (53)      NULL,
    [water_mcfe_volume]            FLOAT (53)      NULL,
    [hours_on]                     NUMERIC (18, 4) NULL,
    [hours_down]                   NUMERIC (19, 4) NULL,
    [casing_pressure]              FLOAT (53)      NULL,
    [tubing_pressure]              FLOAT (53)      NULL,
    [last_update_date]             DATETIME        NOT NULL,
    [injected_produced_water]      FLOAT (53)      NULL,
    [injected_source_water]        FLOAT (53)      NULL,
    [injected_pressure_kpag]       FLOAT (53)      NULL,
    [bsw]                          FLOAT (53)      NULL,
    [joints_to_fluid]              FLOAT (53)      NULL,
    [strokes_per_minute]           FLOAT (53)      NULL,
    [injected_gas_C02]             FLOAT (53)      NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);
