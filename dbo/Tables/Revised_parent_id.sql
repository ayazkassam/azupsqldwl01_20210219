CREATE TABLE [dbo].[Revised_parent_id] (
    [parent_id]         NVARCHAR (1000) NULL,
    [parent_id_Revised] NVARCHAR (1000) NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

