CREATE TABLE [Mktg_ReportLoads].[t_stg_CorporateModelBudgetConversionFactor] (
    [Budget Date]            DATETIME       NULL,
    [Budget Name]            NVARCHAR (255) NULL,
    [Delivery Month]         DATETIME       NULL,
    [BNP Total CF (btu/scf)] FLOAT (53)     NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

