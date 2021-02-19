CREATE TABLE [dbo].[Revised_Hierarchy_Path] (
    [Hierarchy_Path]         VARCHAR (1000) NULL,
    [Hierarchy_Path_Revised] VARCHAR (1000) NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

