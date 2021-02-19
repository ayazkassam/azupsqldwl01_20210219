﻿CREATE TABLE [stage_prodview].[t_pvt_pvflownetheader] (
    [idflownet]                VARCHAR (32)   NOT NULL,
    [name]                     VARCHAR (50)   NULL,
    [typ]                      VARCHAR (50)   NULL,
    [idrecunitprimary]         VARCHAR (32)   NULL,
    [idrecunitprimarytk]       VARCHAR (26)   NULL,
    [idrecfacilityprimary]     VARCHAR (32)   NULL,
    [idrecfacilityprimarytk]   VARCHAR (26)   NULL,
    [com]                      VARCHAR (2000) NULL,
    [idrecresp1]               VARCHAR (32)   NULL,
    [idrecresp1tk]             VARCHAR (26)   NULL,
    [idrecresp2]               VARCHAR (32)   NULL,
    [idrecresp2tk]             VARCHAR (26)   NULL,
    [rptgatheredcalcs]         SMALLINT       NULL,
    [rptallocations]           SMALLINT       NULL,
    [rptdispositions]          SMALLINT       NULL,
    [rptcomponentdispositions] SMALLINT       NULL,
    [rptnodecalculations]      SMALLINT       NULL,
    [dttmallocprocessbegan]    DATETIME       NULL,
    [dttmstart]                DATETIME       NULL,
    [dttmend]                  DATETIME       NULL,
    [dttmlastallocprocess]     DATETIME       NULL,
    [userlastallocprocess]     VARCHAR (50)   NULL,
    [usertxt1]                 VARCHAR (50)   NULL,
    [usertxt2]                 VARCHAR (50)   NULL,
    [usertxt3]                 VARCHAR (50)   NULL,
    [usertxt4]                 VARCHAR (50)   NULL,
    [usertxt5]                 VARCHAR (50)   NULL,
    [syslockmeui]              SMALLINT       NULL,
    [syslockchildrenui]        SMALLINT       NULL,
    [syslockme]                SMALLINT       NULL,
    [syslockchildren]          SMALLINT       NULL,
    [syslockdate]              DATETIME       NULL,
    [sysmoddate]               DATETIME       NULL,
    [sysmoduser]               VARCHAR (50)   NULL,
    [syscreatedate]            DATETIME       NULL,
    [syscreateuser]            VARCHAR (50)   NULL,
    [systag]                   VARCHAR (255)  NULL,
    [sysmoddatedb]             DATETIME       NULL,
    [sysmoduserdb]             VARCHAR (50)   NULL,
    [syssecuritytyp]           VARCHAR (50)   NULL,
    [syslockdatemaster]        DATETIME       NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

