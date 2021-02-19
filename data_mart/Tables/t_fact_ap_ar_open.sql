CREATE TABLE [data_mart].[t_fact_ap_ar_open] (
    [invc_type_code]    VARCHAR (20)    NULL,
    [ba_id]             INT             NULL,
    [invc_id]           VARCHAR (20)    NULL,
    [invc_num]          VARCHAR (50)    NULL,
    [invoice_date]      INT             NULL,
    [org_id]            INT             NULL,
    [accounting_month]  INT             NULL,
    [due_date]          INT             NULL,
    [voucher_id]        VARCHAR (20)    NULL,
    [voucher_type_code] VARCHAR (20)    NULL,
    [voucher_num]       VARCHAR (20)    NULL,
    [cad_open]          NUMERIC (14, 2) NULL,
    [invoice_amount]    NUMERIC (14, 2) NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

