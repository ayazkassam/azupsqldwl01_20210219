CREATE TABLE [stage].[t_source_cost_estimates_siteview] (
    [site_name]            VARCHAR (100) NULL,
    [afe_num]              VARCHAR (255) NULL,
    [grs_net_flag]         VARCHAR (3)   NOT NULL,
    [time_period]          DATETIME      NULL,
    [start_date]           DATE          NULL,
    [gl_net_account]       NVARCHAR (50) NULL,
    [major_acct]           VARCHAR (50)  NULL,
    [minor_acct]           VARCHAR (50)  NULL,
    [acct_desc]            VARCHAR (100) NULL,
    [sv_afe_type]          VARCHAR (16)  NOT NULL,
    [scenario]             VARCHAR (14)  NOT NULL,
    [amount]               FLOAT (53)    NULL,
    [vendor]               VARCHAR (100) NULL,
    [jobrec]               VARCHAR (32)  NULL,
    [costrec]              VARCHAR (32)  NULL,
    [maj_class_code]       VARCHAR (2)   NULL,
    [is_valid_qbyte_major] VARCHAR (1)   NOT NULL,
    [is_valid_afe]         VARCHAR (1)   NOT NULL,
    [vendorcode]           VARCHAR (50)  NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

