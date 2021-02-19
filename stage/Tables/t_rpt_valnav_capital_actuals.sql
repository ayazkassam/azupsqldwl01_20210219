CREATE TABLE [stage].[t_rpt_valnav_capital_actuals] (
    [entity_id]         NVARCHAR (50)   NOT NULL,
    [region_name]       VARCHAR (1000)  NULL,
    [district_name]     VARCHAR (1000)  NULL,
    [area_name]         VARCHAR (1000)  NULL,
    [facility_name]     VARCHAR (1000)  NULL,
    [cost_centre]       VARCHAR (50)    NULL,
    [uwi]               NVARCHAR (100)  NOT NULL,
    [formatted_uwi]     NVARCHAR (100)  NULL,
    [cost_date]         DATE            NULL,
    [value]             FLOAT (53)      NULL,
    [afe_num]           NVARCHAR (4000) NULL,
    [cost_type]         NVARCHAR (50)   NULL,
    [approved_estimate] FLOAT (53)      NULL,
    [revised_estimate]  FLOAT (53)      NULL,
    [end_date]          DATE            NULL,
    [incurred_total]    FLOAT (53)      NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

