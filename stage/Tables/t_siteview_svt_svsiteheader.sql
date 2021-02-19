﻿CREATE TABLE [stage].[t_siteview_svt_svsiteheader] (
    [idsite]                 VARCHAR (32)   NOT NULL,
    [sitename]               VARCHAR (100)  NULL,
    [typ1]                   VARCHAR (50)   NULL,
    [typ2]                   VARCHAR (50)   NULL,
    [status1]                VARCHAR (50)   NULL,
    [latlongdatum]           VARCHAR (50)   NULL,
    [status2]                VARCHAR (50)   NULL,
    [problemflag]            SMALLINT       NULL,
    [problemdes]             VARCHAR (100)  NULL,
    [origin]                 VARCHAR (50)   NULL,
    [operator]               VARCHAR (50)   NULL,
    [operatorcode]           VARCHAR (50)   NULL,
    [contactland]            VARCHAR (50)   NULL,
    [contactconstruct]       VARCHAR (50)   NULL,
    [contactreclaim]         VARCHAR (50)   NULL,
    [contactdrillwaste]      VARCHAR (50)   NULL,
    [contactpipeline]        VARCHAR (50)   NULL,
    [contactother1]          VARCHAR (50)   NULL,
    [contactother2]          VARCHAR (50)   NULL,
    [contactfacility]        VARCHAR (50)   NULL,
    [surfacefileno]          VARCHAR (50)   NULL,
    [siteid1]                VARCHAR (50)   NULL,
    [contactenv]             VARCHAR (50)   NULL,
    [siteid2]                VARCHAR (50)   NULL,
    [contactengineer]        VARCHAR (50)   NULL,
    [siteid3]                VARCHAR (50)   NULL,
    [contactsurvey]          VARCHAR (50)   NULL,
    [ranking1]               VARCHAR (50)   NULL,
    [ranking2]               VARCHAR (50)   NULL,
    [corplevel1]             VARCHAR (50)   NULL,
    [corplevel2]             VARCHAR (50)   NULL,
    [corplevel3]             VARCHAR (50)   NULL,
    [corplevel4]             VARCHAR (50)   NULL,
    [country]                VARCHAR (50)   NULL,
    [stateprov]              VARCHAR (50)   NULL,
    [county]                 VARCHAR (50)   NULL,
    [idreclocprimary]        VARCHAR (32)   NULL,
    [idreclocprimarytk]      VARCHAR (26)   NULL,
    [legalsurveyprimarysort] VARCHAR (50)   NULL,
    [area]                   VARCHAR (50)   NULL,
    [fieldname]              VARCHAR (50)   NULL,
    [fieldcode]              VARCHAR (10)   NULL,
    [fieldoffice]            VARCHAR (50)   NULL,
    [com]                    VARCHAR (2000) NULL,
    [usertxt1]               VARCHAR (50)   NULL,
    [usertxt2]               VARCHAR (50)   NULL,
    [usertxt3]               VARCHAR (50)   NULL,
    [usertxt4]               VARCHAR (50)   NULL,
    [userboolean1]           SMALLINT       NULL,
    [userboolean2]           SMALLINT       NULL,
    [userboolean3]           SMALLINT       NULL,
    [userdttm1]              DATETIME       NULL,
    [userdttm2]              DATETIME       NULL,
    [userdttm3]              DATETIME       NULL,
    [usernum1]               FLOAT (53)     NULL,
    [usernum2]               FLOAT (53)     NULL,
    [usernum3]               FLOAT (53)     NULL,
    [usernum4]               FLOAT (53)     NULL,
    [localtimezone]          FLOAT (53)     NULL,
    [syslockmeui]            SMALLINT       NULL,
    [syslockchildrenui]      SMALLINT       NULL,
    [syslockme]              SMALLINT       NULL,
    [syslockchildren]        SMALLINT       NULL,
    [syslockdate]            DATETIME       NULL,
    [sysmoddate]             DATETIME       NULL,
    [sysmoduser]             VARCHAR (50)   NULL,
    [syscreatedate]          DATETIME       NULL,
    [syscreateuser]          VARCHAR (50)   NULL,
    [systag]                 VARCHAR (255)  NULL,
    [sysmoddatedb]           DATETIME       NULL,
    [sysmoduserdb]           VARCHAR (50)   NULL,
    [syssecuritytyp]         VARCHAR (50)   NULL,
    [syslockdatemaster]      DATETIME       NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

