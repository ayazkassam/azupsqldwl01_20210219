CREATE TABLE [stage].[t_ctrl_valnav_account_xref] (
    [cost_type]                 NVARCHAR (3)  NULL,
    [cost_definition_id]        NVARCHAR (50) NULL,
    [cost_definition_name]      NVARCHAR (50) NULL,
    [previous_cost_detail_type] VARCHAR (100) NULL,
    [sign_flip]                 VARCHAR (3)   NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

