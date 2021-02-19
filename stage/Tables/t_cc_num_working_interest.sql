CREATE TABLE [stage].[t_cc_num_working_interest] (
    [cc_num]           VARCHAR (10)     NULL,
    [working_interest] NUMERIC (38, 11) NULL,
    [effective_date]   DATETIME         NULL,
    [termination_date] DATETIME         NOT NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

