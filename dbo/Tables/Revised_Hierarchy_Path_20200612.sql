CREATE TABLE [dbo].[Revised_Hierarchy_Path_20200612] (
    [Hierarchy_Path]         VARCHAR (1000) NULL,
    [Hierarchy_Path_Revised] VARCHAR (1000) NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);

