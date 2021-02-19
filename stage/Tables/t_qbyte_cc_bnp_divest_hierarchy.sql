CREATE TABLE [stage].[t_qbyte_cc_bnp_divest_hierarchy] (
    [hierarchy_code] VARCHAR (10)   NULL,
    [disp_type]      VARCHAR (4000) NULL,
    [disp_pkg]       VARCHAR (4000) NULL,
    [disp_area]      VARCHAR (4000) NULL,
    [disp_facility]  VARCHAR (4000) NULL,
    [cc_num]         VARCHAR (10)   NULL,
    [disposed]       VARCHAR (1)    NOT NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

