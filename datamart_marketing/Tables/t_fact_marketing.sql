CREATE TABLE [datamart_marketing].[t_fact_marketing] (
    [flownet_id]              VARCHAR (32)  NULL,
    [flownet_name]            VARCHAR (50)  NULL,
    [child_idrec]             VARCHAR (32)  NULL,
    [uwi_name]                VARCHAR (100) NULL,
    [cc_num]                  VARCHAR (50)  NULL,
    [sales_disposition_point] VARCHAR (153) NULL,
    [meter_name]              VARCHAR (100) NULL,
    [typ]                     VARCHAR (50)  NULL,
    [partner_name]            VARCHAR (40)  NOT NULL,
    [activity_date]           DATE          NULL,
    [activity_year_month]     VARCHAR (62)  NULL,
    [raw_volume]              FLOAT (53)    NULL,
    [sales_volume]            FLOAT (53)    NULL,
    [allocated_volume]        FLOAT (53)    NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);

