CREATE TABLE [stage].[t_rpt_csx_latest_working_interest] (
    [file_number]                 CHAR (10)       NOT NULL,
    [uwi]                         VARCHAR (16)    NULL,
    [file_status]                 CHAR (10)       NOT NULL,
    [csx_cost_centre]             VARCHAR (16)    NULL,
    [well_status]                 CHAR (10)       NOT NULL,
    [licence_number]              VARCHAR (10)    NULL,
    [effective_date]              DATE            NOT NULL,
    [termination_date]            DATE            NULL,
    [original_termination_date]   DATE            NOT NULL,
    [partner_id]                  CHAR (6)        NULL,
    [formatted_partner_id]        INT             NULL,
    [name]                        VARCHAR (40)    NULL,
    [partner_type]                CHAR (10)       NULL,
    [doi_type]                    CHAR (10)       NOT NULL,
    [net_owner]                   VARCHAR (1)     NOT NULL,
    [csx_ownership_percent]       NUMERIC (11, 8) NULL,
    [csx_total_well_wrkng_intrst] NUMERIC (38, 8) NULL,
    [pct_rnk]                     BIGINT          NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

