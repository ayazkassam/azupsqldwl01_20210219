CREATE TABLE [dbo].[Revised_gl_account_description] (
    [gl_account_description]         NVARCHAR (1000) NULL,
    [gl_account_description_Revised] NVARCHAR (1000) NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

