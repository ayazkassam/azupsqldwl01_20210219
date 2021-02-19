CREATE TABLE [stage].[t_stg_prodview_proration_data] (
    [uwi]            VARCHAR (50)  NULL,
    [costcenter]     VARCHAR (50)  NULL,
    [FDC]            VARCHAR (100) NULL,
    [dttm]           DATE          NULL,
    [prorated_gas]   FLOAT (53)    NULL,
    [prorated_oil]   FLOAT (53)    NULL,
    [prorated_water] FLOAT (53)    NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);

