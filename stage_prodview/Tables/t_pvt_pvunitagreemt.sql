CREATE TABLE [stage_prodview].[t_pvt_pvunitagreemt] (
    [idflownet]         VARCHAR (32)   NOT NULL,
    [idrecparent]       VARCHAR (32)   NULL,
    [idrec]             VARCHAR (32)   NOT NULL,
    [des]               VARCHAR (50)   NULL,
    [typ1]              VARCHAR (50)   NULL,
    [subtyp1]           VARCHAR (50)   NULL,
    [subtyp2]           VARCHAR (50)   NULL,
    [dttmstart]         DATETIME       NULL,
    [dttmend]           DATETIME       NULL,
    [idrecappliesto]    VARCHAR (32)   NULL,
    [idrecappliestotk]  VARCHAR (26)   NULL,
    [refida]            VARCHAR (50)   NULL,
    [refidb]            VARCHAR (50)   NULL,
    [refidc]            VARCHAR (50)   NULL,
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

