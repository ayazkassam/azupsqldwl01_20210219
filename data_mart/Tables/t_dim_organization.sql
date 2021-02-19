CREATE TABLE [data_mart].[t_dim_organization] (
    [organization_id]                INT          NULL,
    [organization_type_code]         VARCHAR (1)  NULL,
    [organization_name]              VARCHAR (53) NOT NULL,
    [operating_currency_code]        VARCHAR (6)  NULL,
    [reporting_currency_code]        VARCHAR (6)  NULL,
    [create_date]                    DATETIME     NULL,
    [create_user]                    VARCHAR (32) NULL,
    [last_update_date]               DATETIME     NULL,
    [last_update_user]               VARCHAR (32) NULL,
    [fiscal_year_end]                INT          NULL,
    [tax_code]                       VARCHAR (20) NULL,
    [gst_registration_number]        VARCHAR (20) NULL,
    [termination_date]               DATETIME     NULL,
    [termination_user]               VARCHAR (32) NULL,
    [profile_group_code]             VARCHAR (3)  NULL,
    [non_standard_volume_entry_flag] VARCHAR (1)  NULL,
    [self_sustaining_flag]           VARCHAR (1)  NULL,
    [admin_cost_centre]              VARCHAR (10) NULL,
    [multi_tier_jib_flag]            VARCHAR (1)  NULL,
    [cash_call_draw_down_flag]       VARCHAR (1)  NULL,
    [jib_invoice_org_id]             VARCHAR (6)  NULL,
    [country_for_taxation]           INT          NULL,
    [is_ba_matching_entry]           VARCHAR (1)  NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

