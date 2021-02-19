CREATE TABLE [stage].[t_rpt_csx_well_insurance_election] (
    [file_number]          VARCHAR (10) NULL,
    [file_status]          VARCHAR (10) NULL,
    [well_uwi]             VARCHAR (16) NULL,
    [well_status]          VARCHAR (10) NULL,
    [sorted_uwi]           VARCHAR (16) NULL,
    [licence_number]       VARCHAR (10) NULL,
    [contract_file_number] VARCHAR (10) NULL,
    [insurance_election]   VARCHAR (1)  NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

