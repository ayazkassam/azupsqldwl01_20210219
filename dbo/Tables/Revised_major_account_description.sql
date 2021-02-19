CREATE TABLE [dbo].[Revised_major_account_description] (
    [major_account_description]         NVARCHAR (1000) NULL,
    [major_account_description_Revised] NVARCHAR (1000) NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

