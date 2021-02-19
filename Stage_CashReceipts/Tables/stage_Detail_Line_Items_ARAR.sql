CREATE TABLE [Stage_CashReceipts].[stage_Detail_Line_Items_ARAR] (
    [key]                   NVARCHAR (500)  NULL,
    [Timestamp]             DATE            NULL,
    [LineItemName]          NVARCHAR (1000) NOT NULL,
    [ProdMonth]             DATE            NOT NULL,
    [AcctMonth]             DATE            NULL,
    [BAPurchaserID]         INT             NULL,
    [BAName]                NVARCHAR (500)  NOT NULL,
    [Origin Location]       NVARCHAR (500)  NULL,
    [Product]               NVARCHAR (500)  NOT NULL,
    [Delivery Location]     NVARCHAR (500)  NULL,
    [Facility Code]         NVARCHAR (100)  NULL,
    [Production Accountant] NVARCHAR (500)  NULL,
    [LineItemMaster_fk]     NVARCHAR (500)  NULL,
    [LIM_AutoCount]         INT             NULL,
    [Volume]                FLOAT (53)      NULL,
    [Dollars]               FLOAT (53)      NULL,
    [Energy]                FLOAT (53)      NULL,
    [Comment]               NVARCHAR (1000) NULL,
    [Amendment]             BIT             NULL,
    [Modified By]           NVARCHAR (300)  NULL,
    [Modified Date]         DATETIME        NULL,
    [Hide]                  BIT             NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

