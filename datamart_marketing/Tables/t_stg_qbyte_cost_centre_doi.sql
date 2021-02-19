CREATE TABLE [datamart_marketing].[t_stg_qbyte_cost_centre_doi] (
    [agreement_id]         NUMERIC (10)     NULL,
    [ba_id]                NUMERIC (10)     NULL,
    [ba_name]              VARCHAR (40)     NULL,
    [ba_type_code]         VARCHAR (8)      NULL,
    [effective_date]       DATETIME         NULL,
    [termination_date]     DATETIME         NOT NULL,
    [original_expiry_date] DATETIME         NULL,
    [cc_num]               VARCHAR (10)     NULL,
    [doi]                  NUMERIC (14, 11) NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

