CREATE TABLE [stage].[t_source_cost_estimates_qbyte] (
    [cc_num]         VARCHAR (10)    NULL,
    [afe_num]        VARCHAR (10)    NULL,
    [major_acct]     VARCHAR (4)     NULL,
    [minor_acct]     VARCHAR (4)     NULL,
    [supp_gross_est] NUMERIC (16, 2) NULL,
    [supp_net_est]   NUMERIC (16, 2) NULL,
    [orig_gross_est] NUMERIC (14, 2) NULL,
    [orig_net_est]   NUMERIC (14, 2) NULL,
    [gross_est]      NUMERIC (14, 2) NULL,
    [net_est]        NUMERIC (14, 2) NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

