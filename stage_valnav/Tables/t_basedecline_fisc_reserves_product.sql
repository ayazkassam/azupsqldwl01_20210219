﻿CREATE TABLE [stage_valnav].[t_basedecline_fisc_reserves_product] (
    [OBJECT_ID]           NVARCHAR (50) NOT NULL,
    [SHORT_NAME]          NVARCHAR (50) NOT NULL,
    [LONG_NAME]           NVARCHAR (50) NOT NULL,
    [QUERY_NAME_FRAGMENT] NVARCHAR (50) NOT NULL,
    [ASSOCIATED_PRODUCT]  NVARCHAR (50) NOT NULL,
    [INCLUDE_IN_RECON]    TINYINT       NOT NULL,
    [SORT_ORDER]          INT           NOT NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

