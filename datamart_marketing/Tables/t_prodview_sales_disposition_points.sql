CREATE TABLE [datamart_marketing].[t_prodview_sales_disposition_points] (
    [uwi]                     VARCHAR (50)  NULL,
    [sales_disposition_point] VARCHAR (100) NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

