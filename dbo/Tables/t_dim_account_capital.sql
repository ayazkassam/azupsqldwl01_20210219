CREATE TABLE [dbo].[t_dim_account_capital] (
    [account_id]                VARCHAR (500)  NULL,
    [parent_id]                 VARCHAR (500)  NULL,
    [account_desc]              VARCHAR (4204) NULL,
    [account_level_01]          VARCHAR (500)  NULL,
    [account_level_02]          VARCHAR (500)  NULL,
    [account_level_03]          VARCHAR (500)  NULL,
    [account_level_04]          VARCHAR (500)  NULL,
    [account_level_05]          VARCHAR (500)  NULL,
    [account_formula]           VARCHAR (4000) NULL,
    [account_formula_property]  VARCHAR (4000) NULL,
    [unary_operator]            VARCHAR (10)   NULL,
    [major_account]             VARCHAR (100)  NULL,
    [minor_account]             VARCHAR (100)  NULL,
    [gl_account]                VARCHAR (201)  NULL,
    [major_account_description] VARCHAR (4000) NULL,
    [major_class_code]          VARCHAR (4000) NULL,
    [class_code_description]    VARCHAR (4000) NULL,
    [product_code]              VARCHAR (50)   NULL,
    [source]                    VARCHAR (100)  NULL,
    [sort_key]                  VARCHAR (500)  NULL,
    [ID]                        BIGINT         NULL,
    [LastUpdatedDtm]            DATETIME       NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);

