CREATE TABLE [dbo].[Revised_child_id] (
    [child_id]         NVARCHAR (1000) NULL,
    [child_id_Revised] NVARCHAR (1000) NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

