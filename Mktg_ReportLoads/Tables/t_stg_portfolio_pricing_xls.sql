CREATE TABLE [Mktg_ReportLoads].[t_stg_portfolio_pricing_xls] (
    [Strip_Date]        DATETIME      NULL,
    [Comment]           VARCHAR (255) NULL,
    [Product_Type]      VARCHAR (50)  NULL,
    [Name]              VARCHAR (50)  NULL,
    [Settlement_Period] VARCHAR (10)  NULL,
    [Units]             VARCHAR (50)  NULL,
    [Currency]          VARCHAR (3)   NULL,
    [Delivery_Date]     DATETIME      NULL,
    [Strip_Price]       FLOAT (53)    NULL,
    [Manual_Override]   FLOAT (53)    NULL,
    [Realized_Price]    FLOAT (53)    NULL,
    [Portfolio_Price]   FLOAT (53)    NULL,
    [Modified_Date]     DATETIME      NOT NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

