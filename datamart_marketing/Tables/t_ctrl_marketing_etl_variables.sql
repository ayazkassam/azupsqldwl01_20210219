CREATE TABLE [datamart_marketing].[t_ctrl_marketing_etl_variables] (
    [etl_type]                      VARCHAR (500) NULL,
    [flownet_id]                    VARCHAR (500) NULL,
    [flownet_name]                  VARCHAR (100) NULL,
    [sales_disposition_point]       VARCHAR (100) NULL,
    [sales_disposition_point_idrec] VARCHAR (100) NULL,
    [source_meter]                  VARCHAR (100) NULL,
    [source_meter2]                 VARCHAR (100) NULL,
    [entry_id]                      INT           NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

