CREATE TABLE [dbo].[data_source_table] (
    [PersonID] INT           NOT NULL,
    [Name]     VARCHAR (255) NULL,
    [Age]      INT           NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);

