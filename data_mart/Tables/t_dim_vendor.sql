CREATE TABLE [data_mart].[t_dim_vendor] (
    [vendor_key]       INT          NULL,
    [vendor_id]        VARCHAR (50) NULL,
    [parent_id]        INT          NULL,
    [vendor_grouping]  VARCHAR (50) NULL,
    [vendor_alias]     VARCHAR (10) NULL,
    [vendor_sort]      VARCHAR (5)  NULL,
    [invoice_id]       VARCHAR (15) NULL,
    [ba_type_code]     VARCHAR (8)  NULL,
    [payment_code]     VARCHAR (3)  NULL,
    [encana_ba_number] VARCHAR (30) NULL,
    [govt_entity]      VARCHAR (30) NULL,
    [govt_parent]      VARCHAR (30) NULL,
    [ba_credit_status] VARCHAR (30) NULL,
    [aboriginal]       VARCHAR (30) NULL,
    [hold_date]        VARCHAR (10) NULL,
    [ap_credit_days]   VARCHAR (10) NULL,
    [ar_credit_days]   VARCHAR (10) NULL,
    [inactive_date]    DATETIME     NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

