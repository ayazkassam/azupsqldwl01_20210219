﻿CREATE TABLE [Mktg_ReportLoads].[t_stg_Revenue_Model] (
    [id]                                                INT            IDENTITY (1, 1) NOT NULL,
    [Delivery Date]                                     NVARCHAR (255) NULL,
    [Property Common Name]                              NVARCHAR (255) NULL,
    [Sub Product]                                       NVARCHAR (255) NULL,
    [Purchaser ID]                                      FLOAT (53)     NULL,
    [Spec or Mix]                                       NVARCHAR (255) NULL,
    [Penalty]                                           NVARCHAR (255) NULL,
    [Producing Location]                                NVARCHAR (255) NULL,
    [Sales Location]                                    NVARCHAR (255) NULL,
    [Accounting Line Item Name]                         NVARCHAR (255) NULL,
    [Amendment]                                         NVARCHAR (255) NULL,
    [Producing Location Name]                           NVARCHAR (255) NULL,
    [Sales Location Name]                               NVARCHAR (255) NULL,
    [Code Name]                                         NVARCHAR (255) NULL,
    [Production-Sales Code]                             NVARCHAR (255) NULL,
    [Purchaser Name]                                    NVARCHAR (255) NULL,
    [Gross Price ($/m3)]                                FLOAT (53)     NULL,
    [Offset - Base Trucking]                            NVARCHAR (255) NULL,
    [Offset - Ancillary Trucking]                       NVARCHAR (255) NULL,
    [Offset - Fractionation]                            FLOAT (53)     NULL,
    [Offset - Transportation]                           FLOAT (53)     NULL,
    [Offset - Tariff]                                   NVARCHAR (255) NULL,
    [Offset - Loss Allowance]                           NVARCHAR (255) NULL,
    [Offset - Other]                                    NVARCHAR (255) NULL,
    [Offset - WADF]                                     NVARCHAR (255) NULL,
    [Offset - ENBRIDGE WADF]                            NVARCHAR (255) NULL,
    [Sales Volume (m3/month)]                           FLOAT (53)     NULL,
    [Settlement Input ($/month)]                        FLOAT (53)     NULL,
    [Settlement ($/month)]                              FLOAT (53)     NULL,
    [Settlement Delta ($/month)]                        FLOAT (53)     NULL,
    [Delta vs Settlement (%)]                           FLOAT (53)     NULL,
    [Net Price ($/m3)]                                  FLOAT (53)     NULL,
    [Opex - Transportation Rate ($/m3)]                 FLOAT (53)     NULL,
    [Opex - Transportation Take or Pay Rate ($/m3)]     FLOAT (53)     NULL,
    [Opex - Transportation Take or Pay ($/month)]       FLOAT (53)     NULL,
    [Opex - Transportation ($/month)]                   FLOAT (53)     NULL,
    [Opex - Base Trucking Rate ($/m3)]                  NVARCHAR (255) NULL,
    [Opex - Ancillary Trucking Rate ($/m3)]             NVARCHAR (255) NULL,
    [Opex - Base Trucking ($/month)]                    NVARCHAR (255) NULL,
    [Opex - Ancillary Trucking ($/month)]               NVARCHAR (255) NULL,
    [Settlement Net Trucking & Transpot Opex ($/month)] FLOAT (53)     NULL,
    [Netback Price net of Opex ($/m3)]                  FLOAT (53)     NULL,
    [Producing Meter Station Code]                      NVARCHAR (20)  NULL,
    [timeofload]                                        SMALLDATETIME  NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);
