CREATE TABLE [stage].[t_prodview_proration_data_20200727] (
    [UWI]              NVARCHAR (50) NULL,
    [COSTCENTER]       NVARCHAR (50) NULL,
    [FDC]              NVARCHAR (50) NULL,
    [TDATE]            DATE          NULL,
    [GAS]              FLOAT (53)    NULL,
    [HCLIQ]            FLOAT (53)    NULL,
    [WATER]            FLOAT (53)    NULL,
    [LAST_UPDATE_DATE] DATE          NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);

