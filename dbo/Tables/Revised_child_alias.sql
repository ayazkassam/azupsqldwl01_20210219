CREATE TABLE [dbo].[Revised_child_alias] (
    [child_alias]         NVARCHAR (1000) NULL,
    [child_alias_Revised] NVARCHAR (1000) NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

