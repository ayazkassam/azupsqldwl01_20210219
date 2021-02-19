CREATE TABLE [data_mart].[t_fact_valnav_reserves_typecurves] (
    [entity_key]           VARCHAR (500)  NULL,
    [activity_date_key]    INT            NULL,
    [account_key]          VARCHAR (100)  NULL,
    [reserve_category_key] VARCHAR (50)   NULL,
    [scenario_key]         VARCHAR (1000) NULL,
    [gross_net_key]        VARCHAR (10)   NULL,
    [normalized_time_key]  VARCHAR (5)    NULL,
    [imperial_volume]      FLOAT (53)     NULL,
    [boe_volume]           FLOAT (53)     NULL,
    [metric_volume]        FLOAT (53)     NULL,
    [mcfe_volume]          FLOAT (53)     NULL,
    [scenario_type]        VARCHAR (100)  NULL,
    [last_update_date]     DATETIME       NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

