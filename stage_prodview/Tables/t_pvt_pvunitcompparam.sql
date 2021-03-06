﻿CREATE TABLE [stage_prodview].[t_pvt_pvunitcompparam] (
    [idflownet]         VARCHAR (32)   NOT NULL,
    [idrecparent]       VARCHAR (32)   NULL,
    [idrec]             VARCHAR (32)   NOT NULL,
    [dttm]              DATETIME       NULL,
    [prestub]           FLOAT (53)     NULL,
    [prescas]           FLOAT (53)     NULL,
    [presline]          FLOAT (53)     NULL,
    [tempwh]            FLOAT (53)     NULL,
    [szchoke]           FLOAT (53)     NULL,
    [presinj]           FLOAT (53)     NULL,
    [preswh]            FLOAT (53)     NULL,
    [presbh]            FLOAT (53)     NULL,
    [tempbh]            FLOAT (53)     NULL,
    [prestubsi]         FLOAT (53)     NULL,
    [prescassi]         FLOAT (53)     NULL,
    [viscdynamic]       FLOAT (53)     NULL,
    [visckinematic]     FLOAT (53)     NULL,
    [ph]                FLOAT (53)     NULL,
    [salinity]          FLOAT (53)     NULL,
    [presuser1]         FLOAT (53)     NULL,
    [presuser2]         FLOAT (53)     NULL,
    [presuser3]         FLOAT (53)     NULL,
    [presuser4]         FLOAT (53)     NULL,
    [presuser5]         FLOAT (53)     NULL,
    [tempuser1]         FLOAT (53)     NULL,
    [tempuser2]         FLOAT (53)     NULL,
    [tempuser3]         FLOAT (53)     NULL,
    [tempuser4]         FLOAT (53)     NULL,
    [tempuser5]         FLOAT (53)     NULL,
    [usertxt1]          VARCHAR (50)   NULL,
    [usertxt2]          VARCHAR (50)   NULL,
    [usertxt3]          VARCHAR (50)   NULL,
    [usertxt4]          VARCHAR (50)   NULL,
    [usertxt5]          VARCHAR (50)   NULL,
    [usernum1]          FLOAT (53)     NULL,
    [usernum2]          FLOAT (53)     NULL,
    [usernum3]          FLOAT (53)     NULL,
    [usernum4]          FLOAT (53)     NULL,
    [usernum5]          FLOAT (53)     NULL,
    [userdttm1]         DATETIME       NULL,
    [userdttm2]         DATETIME       NULL,
    [userdttm3]         DATETIME       NULL,
    [userdttm4]         DATETIME       NULL,
    [userdttm5]         DATETIME       NULL,
    [com]               VARCHAR (2000) NULL,
    [syslockmeui]       SMALLINT       NULL,
    [syslockchildrenui] SMALLINT       NULL,
    [syslockme]         SMALLINT       NULL,
    [syslockchildren]   SMALLINT       NULL,
    [syslockdate]       DATETIME       NULL,
    [sysmoddate]        DATETIME       NULL,
    [sysmoduser]        VARCHAR (50)   NULL,
    [syscreatedate]     DATETIME       NULL,
    [syscreateuser]     VARCHAR (50)   NULL,
    [systag]            VARCHAR (255)  NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

