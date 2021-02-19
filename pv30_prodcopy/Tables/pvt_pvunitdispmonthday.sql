﻿CREATE TABLE [pv30_prodcopy].[pvt_pvunitdispmonthday] (
    [idflownet]           VARCHAR (32)  NOT NULL,
    [idrecparent]         VARCHAR (32)  NULL,
    [idrec]               VARCHAR (32)  NOT NULL,
    [dttm]                DATETIME      NULL,
    [year]                INT           NULL,
    [month]               INT           NULL,
    [dayofmonth]          INT           NULL,
    [idrecunit]           VARCHAR (32)  NULL,
    [idrecunittk]         VARCHAR (26)  NULL,
    [idreccomp]           VARCHAR (32)  NULL,
    [idreccomptk]         VARCHAR (26)  NULL,
    [idreccompzone]       VARCHAR (32)  NULL,
    [idreccompzonetk]     VARCHAR (26)  NULL,
    [idrecdispunitnode]   VARCHAR (32)  NULL,
    [idrecdispunitnodetk] VARCHAR (26)  NULL,
    [idrecdispunit]       VARCHAR (32)  NULL,
    [idrecdispunittk]     VARCHAR (26)  NULL,
    [volhcliq]            FLOAT (53)    NULL,
    [volhcliqgaseq]       FLOAT (53)    NULL,
    [volgas]              FLOAT (53)    NULL,
    [volwater]            FLOAT (53)    NULL,
    [volsand]             FLOAT (53)    NULL,
    [volc1liq]            FLOAT (53)    NULL,
    [volc1gaseq]          FLOAT (53)    NULL,
    [volc1gas]            FLOAT (53)    NULL,
    [volc2liq]            FLOAT (53)    NULL,
    [volc2gaseq]          FLOAT (53)    NULL,
    [volc2gas]            FLOAT (53)    NULL,
    [volc3liq]            FLOAT (53)    NULL,
    [volc3gaseq]          FLOAT (53)    NULL,
    [volc3gas]            FLOAT (53)    NULL,
    [volic4liq]           FLOAT (53)    NULL,
    [volic4gaseq]         FLOAT (53)    NULL,
    [volic4gas]           FLOAT (53)    NULL,
    [volnc4liq]           FLOAT (53)    NULL,
    [volnc4gaseq]         FLOAT (53)    NULL,
    [volnc4gas]           FLOAT (53)    NULL,
    [volic5liq]           FLOAT (53)    NULL,
    [volic5gaseq]         FLOAT (53)    NULL,
    [volic5gas]           FLOAT (53)    NULL,
    [volnc5liq]           FLOAT (53)    NULL,
    [volnc5gaseq]         FLOAT (53)    NULL,
    [volnc5gas]           FLOAT (53)    NULL,
    [volc6liq]            FLOAT (53)    NULL,
    [volc6gaseq]          FLOAT (53)    NULL,
    [volc6gas]            FLOAT (53)    NULL,
    [volc7liq]            FLOAT (53)    NULL,
    [volc7gaseq]          FLOAT (53)    NULL,
    [volc7gas]            FLOAT (53)    NULL,
    [voln2liq]            FLOAT (53)    NULL,
    [voln2gaseq]          FLOAT (53)    NULL,
    [voln2gas]            FLOAT (53)    NULL,
    [volco2liq]           FLOAT (53)    NULL,
    [volco2gaseq]         FLOAT (53)    NULL,
    [volco2gas]           FLOAT (53)    NULL,
    [volh2sliq]           FLOAT (53)    NULL,
    [volh2sgaseq]         FLOAT (53)    NULL,
    [volh2sgas]           FLOAT (53)    NULL,
    [volothercompliq]     FLOAT (53)    NULL,
    [volothercompgaseq]   FLOAT (53)    NULL,
    [volothercompgas]     FLOAT (53)    NULL,
    [heat]                FLOAT (53)    NULL,
    [idreccalcset]        VARCHAR (32)  NULL,
    [idreccalcsettk]      VARCHAR (26)  NULL,
    [syslockmeui]         SMALLINT      NULL,
    [syslockchildrenui]   SMALLINT      NULL,
    [syslockme]           SMALLINT      NULL,
    [syslockchildren]     SMALLINT      NULL,
    [syslockdate]         DATETIME      NULL,
    [sysmoddate]          DATETIME      NULL,
    [sysmoduser]          VARCHAR (50)  NULL,
    [syscreatedate]       DATETIME      NULL,
    [syscreateuser]       VARCHAR (50)  NULL,
    [systag]              VARCHAR (255) NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

