CREATE TABLE [Mktg_ReportLoads].[t_stg_portfolio_pricing_text] (
    [Strip_Date]        NVARCHAR (255) NULL,
    [Comment]           NVARCHAR (255) NULL,
    [Product_Type]      NVARCHAR (255) NULL,
    [Name]              NVARCHAR (255) NULL,
    [Settlement_Period] NVARCHAR (255) NULL,
    [Units]             NVARCHAR (255) NULL,
    [Currency]          NVARCHAR (255) NULL,
    [Delivery_Date]     NVARCHAR (255) NULL,
    [Strip_Price]       NVARCHAR (255) NULL,
    [Manual_Override]   NVARCHAR (255) NULL,
    [Realized_Price]    NVARCHAR (255) NULL,
    [Portfolio_Price]   NVARCHAR (255) NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

