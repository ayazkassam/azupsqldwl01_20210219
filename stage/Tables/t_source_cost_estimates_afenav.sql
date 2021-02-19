CREATE TABLE [stage].[t_source_cost_estimates_afenav] (
    [afe_document_id] VARCHAR (50) NULL,
    [afenumber]       VARCHAR (50) NULL,
    [amount_date]     DATETIME     NULL,
    [amount_type]     VARCHAR (20) NULL,
    [net_grs]         VARCHAR (3)  NOT NULL,
    [afe_type]        VARCHAR (50) NULL,
    [amount]          FLOAT (53)   NULL,
    [legacy_afeid]    NUMERIC (10) NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

