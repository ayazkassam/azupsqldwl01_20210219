CREATE TABLE [dbo].[CTE_v_qbyte_account_hierarchy_source_finance] (
    [child_id]                  VARCHAR (500)  NULL,
    [parent_id]                 VARCHAR (500)  NULL,
    [child_alias]               VARCHAR (500)  NULL,
    [parent_alias]              VARCHAR (500)  NULL,
    [gl_account_description]    VARCHAR (500)  NULL,
    [account_uda]               VARCHAR (50)   NULL,
    [class_code_description]    VARCHAR (100)  NULL,
    [product_uda]               VARCHAR (50)   NULL,
    [si_to_imp_conv_factor]     VARCHAR (50)   NULL,
    [boe_thermal]               VARCHAR (50)   NULL,
    [mcfe6_thermal]             VARCHAR (50)   NULL,
    [product_description]       VARCHAR (100)  NULL,
    [gross_or_net_code]         VARCHAR (25)   NULL,
    [account_group]             VARCHAR (50)   NULL,
    [display_seq_num]           VARCHAR (4)    NULL,
    [major_minor]               VARCHAR (50)   NULL,
    [major_account]             VARCHAR (4)    NULL,
    [major_account_description] VARCHAR (500)  NULL,
    [minor_account]             VARCHAR (4)    NULL,
    [sort_key]                  VARCHAR (500)  NULL,
    [zero_level]                INT            NULL,
    [Hierarchy_Path]            VARCHAR (1000) NULL,
    [Hierarchy_Path_Desc]       VARCHAR (1000) NULL,
    [level]                     INT            NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

