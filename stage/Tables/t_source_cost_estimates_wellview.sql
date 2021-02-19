CREATE TABLE [stage].[t_source_cost_estimates_wellview] (
    [afe_num]              VARCHAR (50)  NULL,
    [afe_supp]             VARCHAR (50)  NOT NULL,
    [time_period]          DATETIME      NULL,
    [start_date]           DATETIME      NULL,
    [wv_afe_type]          VARCHAR (16)  NOT NULL,
    [grs_net_flag]         VARCHAR (3)   NOT NULL,
    [gl_net_account]       VARCHAR (101) NULL,
    [major_acct]           VARCHAR (50)  NULL,
    [minor_acct]           VARCHAR (50)  NULL,
    [scenario]             VARCHAR (14)  NOT NULL,
    [amount]               FLOAT (53)    NULL,
    [maj_class_code]       VARCHAR (2)   NULL,
    [is_valid_qbyte_major] VARCHAR (1)   NOT NULL,
    [is_valid_afe]         VARCHAR (1)   NOT NULL,
    [vendorcode]           VARCHAR (50)  NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

