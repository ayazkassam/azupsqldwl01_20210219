CREATE TABLE [stage].[t_ctrl_Revised_account_description] (
    [row_id]                      INT             NULL,
    [account_id]                  NVARCHAR (1000) NULL,
    [account_description]         NVARCHAR (1000) NULL,
    [account_description_Revised] NVARCHAR (1000) NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);

