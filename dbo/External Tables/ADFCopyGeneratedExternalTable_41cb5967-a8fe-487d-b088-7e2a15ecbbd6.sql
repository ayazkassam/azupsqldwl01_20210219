﻿CREATE EXTERNAL TABLE [dbo].[ADFCopyGeneratedExternalTable_41cb5967-a8fe-487d-b088-7e2a15ecbbd6] (
    [idwell] VARCHAR (32) NOT NULL,
    [idrecparent] VARCHAR (32) NULL,
    [idrec] VARCHAR (32) NOT NULL,
    [bhaanpres] FLOAT (53) NULL,
    [bhtemp] FLOAT (53) NULL,
    [depthend] FLOAT (53) NULL,
    [depthstart] FLOAT (53) NULL,
    [dttmend] DATETIME2 (7) NULL,
    [dttmstart] DATETIME2 (7) NULL,
    [ecdendoverride] FLOAT (53) NULL,
    [excludefromnewhole] SMALLINT NULL,
    [gasinjrate] FLOAT (53) NULL,
    [gasreturnrate] FLOAT (53) NULL,
    [hookloadoffbottom] FLOAT (53) NULL,
    [hookloadpickup] FLOAT (53) NULL,
    [hookloadrotating] FLOAT (53) NULL,
    [hookloadslackoff] FLOAT (53) NULL,
    [idrecwellbore] VARCHAR (32) NULL,
    [idrecwellboretk] VARCHAR (26) NULL,
    [injtemp] FLOAT (53) NULL,
    [liquidinjrate] FLOAT (53) NULL,
    [liquidinjrateriser] FLOAT (53) NULL,
    [liquidreturnrate] FLOAT (53) NULL,
    [note] VARCHAR (255) NULL,
    [refnostand] VARCHAR (10) NULL,
    [ropinst] FLOAT (53) NULL,
    [rpmmotor] FLOAT (53) NULL,
    [rpmstring] FLOAT (53) NULL,
    [sppdiff] FLOAT (53) NULL,
    [sppdrill] FLOAT (53) NULL,
    [surfannpres] FLOAT (53) NULL,
    [surfanntemp] FLOAT (53) NULL,
    [szodvgstab] FLOAT (53) NULL,
    [tfo] FLOAT (53) NULL,
    [tforef] VARCHAR (10) NULL,
    [tmcirc] FLOAT (53) NULL,
    [tmdrill] FLOAT (53) NULL,
    [tmother] FLOAT (53) NULL,
    [tmtrip] FLOAT (53) NULL,
    [torquedrill] FLOAT (53) NULL,
    [torqueoffbtm] FLOAT (53) NULL,
    [torqueunits] VARCHAR (10) NULL,
    [typ1] VARCHAR (100) NULL,
    [typ2] VARCHAR (100) NULL,
    [wob] FLOAT (53) NULL,
    [syslockmeui] SMALLINT NULL,
    [syslockchildrenui] SMALLINT NULL,
    [syslockme] SMALLINT NULL,
    [syslockchildren] SMALLINT NULL,
    [syslockdate] DATETIME2 (7) NULL,
    [sysmoddate] DATETIME2 (7) NULL,
    [sysmoduser] VARCHAR (50) NULL,
    [syscreatedate] DATETIME2 (7) NULL,
    [syscreateuser] VARCHAR (50) NULL,
    [systag] VARCHAR (255) NULL
)
    WITH (
    DATA_SOURCE = [ADFCopyGeneratedDataSource_0e8a63ba-1642-4f4d-b0c5-6aefc9ed1c9b],
    LOCATION = N'219e6c73-a841-46e2-8a39-69f99c478cd5/Polybase/',
    FILE_FORMAT = [ADFCopyGeneratedFileFormat_3bc100bd-554b-40d9-9a55-0c8a570a5c6a],
    REJECT_TYPE = VALUE,
    REJECT_VALUE = 0
    );

