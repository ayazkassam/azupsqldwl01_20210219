﻿CREATE TABLE [pv30_prodcopy].[pvt_pvunitnodeflowto] (
    [idflownet]             VARCHAR (32)   NOT NULL,
    [idrecparent]           VARCHAR (32)   NULL,
    [idrec]                 VARCHAR (32)   NOT NULL,
    [dttmstart]             DATETIME       NULL,
    [dttmend]               DATETIME       NULL,
    [idrecinlet]            VARCHAR (32)   NULL,
    [idrecinlettk]          VARCHAR (26)   NULL,
    [idrecinletunitcalc]    VARCHAR (32)   NULL,
    [idrecinletunitcalctk]  VARCHAR (26)   NULL,
    [idrecoutletcalc]       VARCHAR (32)   NULL,
    [idrecoutletcalctk]     VARCHAR (26)   NULL,
    [idrecoutletunitcalc]   VARCHAR (32)   NULL,
    [idrecoutletunitcalctk] VARCHAR (26)   NULL,
    [recircflow]            SMALLINT       NULL,
    [com]                   VARCHAR (2000) NULL,
    [sysseq]                INT            NULL,
    [syslockmeui]           SMALLINT       NULL,
    [syslockchildrenui]     SMALLINT       NULL,
    [syslockme]             SMALLINT       NULL,
    [syslockchildren]       SMALLINT       NULL,
    [syslockdate]           DATETIME       NULL,
    [sysmoddate]            DATETIME       NULL,
    [sysmoduser]            VARCHAR (50)   NULL,
    [syscreatedate]         DATETIME       NULL,
    [syscreateuser]         VARCHAR (50)   NULL,
    [systag]                VARCHAR (255)  NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

