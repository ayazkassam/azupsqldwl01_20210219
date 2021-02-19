CREATE TABLE [dbo].[WatermarkTable] (
    [WatermarkTableName] NVARCHAR (255) NULL,
    [WatermarkColumn]    NVARCHAR (255) NULL,
    [WatermarkValue]     NVARCHAR (255) NULL,
    [WatermarkDatetime]  DATETIME       NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);

