﻿CREATE TABLE [dbo].[object_rows] (
    [name] VARCHAR (100) NULL,
    [cnt]  INT           NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);

