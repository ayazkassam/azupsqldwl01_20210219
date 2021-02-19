CREATE TABLE [stage_prodview].[t_pvt_pvrouteset] (
    [idflownet]         VARCHAR (32)   NOT NULL,
    [idrec]             VARCHAR (32)   NOT NULL,
    [dttmstart]         DATETIME       NULL,
    [com]               VARCHAR (2000) NULL,
    [activetodaycalc]   SMALLINT       NULL,
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

