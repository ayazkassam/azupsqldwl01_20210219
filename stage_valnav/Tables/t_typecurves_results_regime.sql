CREATE TABLE [stage_valnav].[t_typecurves_results_regime] (
    [RESULT_ID]          NVARCHAR (50) NOT NULL,
    [STEP_DATE]          DATETIME2 (7) NOT NULL,
    [AD_VALOREM]         FLOAT (53)    NOT NULL,
    [AD_VALOREM_BASIS]   FLOAT (53)    NOT NULL,
    [BASIC_TAX]          FLOAT (53)    NOT NULL,
    [BONUS]              FLOAT (53)    NOT NULL,
    [COST_RECOVERY]      FLOAT (53)    NOT NULL,
    [CREDITS]            FLOAT (53)    NOT NULL,
    [DDA]                FLOAT (53)    NOT NULL,
    [DESIGNATED_ROR]     FLOAT (53)    NOT NULL,
    [DMO]                FLOAT (53)    NOT NULL,
    [EXPENSE]            FLOAT (53)    NOT NULL,
    [INCOME]             FLOAT (53)    NOT NULL,
    [INVESTMENT_CREDITS] FLOAT (53)    NOT NULL,
    [PROFIT_REVENUE]     FLOAT (53)    NOT NULL,
    [ROYALTY]            FLOAT (53)    NOT NULL,
    [SERVICE_FEE]        FLOAT (53)    NOT NULL,
    [SEVERANCE]          FLOAT (53)    NOT NULL,
    [TRANCHE]            FLOAT (53)    NOT NULL,
    [UPLIFT]             FLOAT (53)    NOT NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

