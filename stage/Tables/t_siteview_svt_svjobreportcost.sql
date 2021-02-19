﻿CREATE TABLE [stage].[t_siteview_svt_svjobreportcost] (
    [idsite]               VARCHAR (32)   NOT NULL,
    [idrecparent]          VARCHAR (32)   NULL,
    [syscarryfwdp]         SMALLINT       NULL,
    [idrec]                VARCHAR (32)   NOT NULL,
    [codedes]              VARCHAR (100)  NULL,
    [code1]                VARCHAR (100)  NULL,
    [code2]                VARCHAR (100)  NULL,
    [code3]                VARCHAR (100)  NULL,
    [code4]                VARCHAR (100)  NULL,
    [code5]                VARCHAR (100)  NULL,
    [code6]                VARCHAR (100)  NULL,
    [cost]                 FLOAT (53)     NULL,
    [vendor]               VARCHAR (100)  NULL,
    [vendorcode]           VARCHAR (50)   NULL,
    [ticketno]             VARCHAR (50)   NULL,
    [refnoop]              VARCHAR (50)   NULL,
    [dttminvoicerec]       DATETIME       NULL,
    [dttminvoicesent]      DATETIME       NULL,
    [pono]                 VARCHAR (50)   NULL,
    [workorderno]          VARCHAR (50)   NULL,
    [invoiceno]            VARCHAR (50)   NULL,
    [idrecafecustom]       VARCHAR (32)   NULL,
    [idrecafecustomtk]     VARCHAR (26)   NULL,
    [idreccommit]          VARCHAR (32)   NULL,
    [idreccommittk]        VARCHAR (26)   NULL,
    [idrecmetricsdetail]   VARCHAR (32)   NULL,
    [idrecmetricsdetailtk] VARCHAR (26)   NULL,
    [idrecplandetails]     VARCHAR (32)   NULL,
    [idrecplandetailstk]   VARCHAR (26)   NULL,
    [idrecitem]            VARCHAR (32)   NULL,
    [idrecitemtk]          VARCHAR (26)   NULL,
    [authorized]           VARCHAR (50)   NULL,
    [sn]                   VARCHAR (50)   NULL,
    [note]                 VARCHAR (2000) NULL,
    [sysseq]               INT            NULL,
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

