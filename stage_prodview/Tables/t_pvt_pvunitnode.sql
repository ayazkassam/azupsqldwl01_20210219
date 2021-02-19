﻿CREATE TABLE [stage_prodview].[t_pvt_pvunitnode] (
    [idflownet]            VARCHAR (32)   NOT NULL,
    [idrecparent]          VARCHAR (32)   NULL,
    [idrec]                VARCHAR (32)   NOT NULL,
    [name]                 VARCHAR (50)   NULL,
    [typ]                  VARCHAR (50)   NULL,
    [dttmstart]            DATETIME       NULL,
    [dttmend]              DATETIME       NULL,
    [component]            VARCHAR (50)   NULL,
    [componentphase]       VARCHAR (50)   NULL,
    [desfluid]             VARCHAR (50)   NULL,
    [keepwhole]            VARCHAR (20)   NULL,
    [typfluidbaserestrict] VARCHAR (20)   NULL,
    [sortflowdiag]         INT            NULL,
    [keymigrationsource]   VARCHAR (100)  NULL,
    [typmigrationsource]   VARCHAR (100)  NULL,
    [otherid]              VARCHAR (50)   NULL,
    [correctionid1]        VARCHAR (2000) NULL,
    [correctiontyp1]       VARCHAR (50)   NULL,
    [correctionid2]        VARCHAR (2000) NULL,
    [correctiontyp2]       VARCHAR (50)   NULL,
    [facproductname]       VARCHAR (50)   NULL,
    [usevirutalanalysis]   SMALLINT       NULL,
    [dispositionpoint]     SMALLINT       NULL,
    [dispproductname]      VARCHAR (50)   NULL,
    [typdisp1]             VARCHAR (50)   NULL,
    [purchasername]        VARCHAR (100)  NULL,
    [purchasercode1]       VARCHAR (100)  NULL,
    [purchasercode2]       VARCHAR (100)  NULL,
    [typdisp2]             VARCHAR (50)   NULL,
    [typdisphcliq]         VARCHAR (50)   NULL,
    [dispida]              VARCHAR (50)   NULL,
    [dispidb]              VARCHAR (50)   NULL,
    [com]                  VARCHAR (2000) NULL,
    [dttmhide]             DATETIME       NULL,
    [usertxt1]             VARCHAR (50)   NULL,
    [usertxt2]             VARCHAR (50)   NULL,
    [usertxt3]             VARCHAR (50)   NULL,
    [usernum1]             FLOAT (53)     NULL,
    [usernum2]             FLOAT (53)     NULL,
    [usernum3]             FLOAT (53)     NULL,
    [syslockmeui]          SMALLINT       NULL,
    [syslockchildrenui]    SMALLINT       NULL,
    [syslockme]            SMALLINT       NULL,
    [syslockchildren]      SMALLINT       NULL,
    [syslockdate]          DATETIME       NULL,
    [sysmoddate]           DATETIME       NULL,
    [sysmoduser]           VARCHAR (50)   NULL,
    [syscreatedate]        DATETIME       NULL,
    [syscreateuser]        VARCHAR (50)   NULL,
    [systag]               VARCHAR (255)  NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

