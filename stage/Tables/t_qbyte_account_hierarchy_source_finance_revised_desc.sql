CREATE TABLE [stage].[t_qbyte_account_hierarchy_source_finance_revised_desc] (
    [row_id]                            INT             NULL,
    [child_id]                          VARCHAR (500)   NULL,
    [child_alias]                       VARCHAR (4000)  NULL,
    [parent_alias]                      VARCHAR (4000)  NULL,
    [gl_account]                        VARCHAR (50)    NULL,
    [gl_account_description]            VARCHAR (4000)  NULL,
    [major_account_description]         VARCHAR (500)   NULL,
    [class_code_description]            VARCHAR (100)   NULL,
    [Hierarchy_Path_desc]               NVARCHAR (1000) NULL,
    [child_alias_revised]               VARCHAR (4000)  NULL,
    [parent_alias_revised]              VARCHAR (4000)  NULL,
    [gl_account_description_revised]    VARCHAR (4000)  NULL,
    [major_account_description_revised] VARCHAR (4000)  NULL,
    [class_code_description_revised]    VARCHAR (4000)  NULL,
    [Hierarchy_Path_desc_revised]       VARCHAR (4000)  NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);

