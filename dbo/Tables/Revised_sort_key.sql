CREATE TABLE [dbo].[Revised_sort_key] (
    [sort_key]         VARCHAR (1000) NULL,
    [sort_key_Revised] VARCHAR (1000) NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

