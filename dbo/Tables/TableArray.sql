﻿CREATE TABLE [dbo].[TableArray] (
    [ik]   INT           IDENTITY (1, 1) NOT NULL,
    [Item] VARCHAR (128) NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);

