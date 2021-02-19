CREATE TABLE [dbo].[Revised_account_description] (
    [account_description]         NVARCHAR (1000) NULL,
    [account_description_Revised] NVARCHAR (1000) NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

