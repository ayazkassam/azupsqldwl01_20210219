CREATE TABLE [Mktg_ReportLoads].[t_stg_CorporateModelBudget1] (
    [Budget Name]    NVARCHAR (255) NULL,
    [District]       NVARCHAR (255) NULL,
    [Pipeline]       NVARCHAR (255) NULL,
    [mcf/d]          FLOAT (53)     NULL,
    [Budget Date]    DATETIME       NULL,
    [Delivery Month] NVARCHAR (255) NULL,
    [Product]        NVARCHAR (255) NULL,
    [BOE/d]          NVARCHAR (255) NULL,
    [timeofload]     SMALLDATETIME  NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

