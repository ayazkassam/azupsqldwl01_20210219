﻿CREATE TABLE [stage_prodview].[t_pvt_pvfacility] (
    [idflownet]          VARCHAR (32)   NOT NULL,
    [idrec]              VARCHAR (32)   NOT NULL,
    [name]               VARCHAR (255)  NULL,
    [idpa]               VARCHAR (50)   NULL,
    [facilityida]        VARCHAR (50)   NULL,
    [facilityidb]        VARCHAR (50)   NULL,
    [facilityidc]        VARCHAR (50)   NULL,
    [facilityidd]        VARCHAR (50)   NULL,
    [typ1]               VARCHAR (50)   NULL,
    [typ2]               VARCHAR (50)   NULL,
    [typregulatory]      VARCHAR (50)   NULL,
    [typpa]              VARCHAR (50)   NULL,
    [idrecunitprimary]   VARCHAR (32)   NULL,
    [idrecunitprimarytk] VARCHAR (26)   NULL,
    [dttmstart]          DATETIME       NULL,
    [dttmend]            DATETIME       NULL,
    [dttmhide]           DATETIME       NULL,
    [hidefacrev]         SMALLINT       NULL,
    [treathcliquidasgas] SMALLINT       NULL,
    [idrecresp1]         VARCHAR (32)   NULL,
    [idrecresp1tk]       VARCHAR (26)   NULL,
    [idrecresp2]         VARCHAR (32)   NULL,
    [idrecresp2tk]       VARCHAR (26)   NULL,
    [permanentid]        VARCHAR (32)   NULL,
    [usertxt1]           VARCHAR (50)   NULL,
    [usertxt2]           VARCHAR (50)   NULL,
    [usertxt3]           VARCHAR (50)   NULL,
    [com]                VARCHAR (2000) NULL,
    [syslockmeui]        SMALLINT       NULL,
    [syslockchildrenui]  SMALLINT       NULL,
    [syslockme]          SMALLINT       NULL,
    [syslockchildren]    SMALLINT       NULL,
    [syslockdate]        DATETIME       NULL,
    [sysmoddate]         DATETIME       NULL,
    [sysmoduser]         VARCHAR (50)   NULL,
    [syscreatedate]      DATETIME       NULL,
    [syscreateuser]      VARCHAR (50)   NULL,
    [systag]             VARCHAR (255)  NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

