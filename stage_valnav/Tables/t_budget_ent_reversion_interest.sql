CREATE TABLE [stage_valnav].[t_budget_ent_reversion_interest] (
    [OBJECT_ID]                    NVARCHAR (50) NOT NULL,
    [PARENT_ID]                    NVARCHAR (50) NOT NULL,
    [SORT_INDEX]                   INT           NULL,
    [WORKING_INTEREST]             FLOAT (53)    NULL,
    [OP_COST_INTEREST]             FLOAT (53)    NULL,
    [CAP_COST_INTEREST]            FLOAT (53)    NULL,
    [FACILITY_INTEREST]            FLOAT (53)    NULL,
    [FREEHOLD_INTEREST_RECEIVABLE] FLOAT (53)    NULL,
    [GOR_RECEIVABLE]               FLOAT (53)    NULL,
    [NOR_RECEIVABLE]               FLOAT (53)    NULL,
    [NPI_RECEIVABLE]               FLOAT (53)    NULL,
    [GOR_PAYABLE]                  FLOAT (53)    NULL,
    [NOR_PAYABLE]                  FLOAT (53)    NULL,
    [NPI_PAYABLE]                  FLOAT (53)    NULL,
    [POOLING_FACTOR]               FLOAT (53)    NULL,
    [TRACT_FACTOR]                 FLOAT (53)    NULL,
    [ROYALTY_FACTOR]               FLOAT (53)    NULL,
    [ROYALTY_DEDUCTION]            FLOAT (53)    NULL,
    [REVERSION_TYPE]               INT           NULL,
    [REVERSION_VALUE]              FLOAT (53)    NULL,
    [REVERSION_DATE]               DATETIME2 (7) NULL,
    [GOR_DEDUCTION_PAYABLE]        FLOAT (53)    NULL,
    [GOR_DEDUCTION_RECEIVABLE]     FLOAT (53)    NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

