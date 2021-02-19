CREATE TABLE [Stage_CashReceipts].[Detail_Line_Items_ARAR] (
    [key]                   UNIQUEIDENTIFIER NULL,
    [Timestamp]             DATE             NULL,
    [LineItemName]          VARCHAR (150)    NOT NULL,
    [ProdMonth]             DATE             NOT NULL,
    [AcctMonth]             DATE             NULL,
    [BAPurchaserID]         INT              NULL,
    [BAName]                VARCHAR (100)    NOT NULL,
    [Origin Location]       VARCHAR (100)    NULL,
    [Product]               VARCHAR (50)     NOT NULL,
    [Delivery Location]     VARCHAR (100)    NULL,
    [Facility Code]         VARCHAR (100)    NULL,
    [Production Accountant] NCHAR (50)       NULL,
    [LineItemMaster_fk]     UNIQUEIDENTIFIER NULL,
    [LIM_AutoCount]         INT              NULL,
    [Volume]                REAL             NULL,
    [Dollars]               MONEY            NULL,
    [Energy]                REAL             NULL,
    [Comment]               VARCHAR (100)    NULL,
    [Amendment]             BIT              DEFAULT ((0)) NOT NULL,
    [Modified By]           VARCHAR (50)     NULL,
    [Modified Date]         DATETIME         NULL,
    [Hide]                  BIT              NULL,
    [Seq]                   INT              IDENTITY (1, 1) NOT NULL,
    [timestampdt]           DATETIME         NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

