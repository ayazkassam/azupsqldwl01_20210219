CREATE TABLE [dbo].[Revised_class_code_description] (
    [class_code_description]         NVARCHAR (1000) NULL,
    [class_code_description_Revised] NVARCHAR (1000) NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

