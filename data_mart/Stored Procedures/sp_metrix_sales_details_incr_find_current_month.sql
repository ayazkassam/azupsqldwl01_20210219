CREATE PROC [data_mart].[sp_metrix_sales_details_incr_find_current_month] AS
BEGIN

  DECLARE 
    @INT_VALUE INT

  SELECT 
    @INT_VALUE = INT_VALUE
  FROM 
    [stage_metrix].[t_ctrl_metrix_etl_variables]
  WHERE 
    VARIABLE_NAME = 'current month'
 
  SELECT ISNULL(@INT_VALUE, 0)  INT_VALUE 
END;