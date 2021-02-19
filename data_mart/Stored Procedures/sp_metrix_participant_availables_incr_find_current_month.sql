CREATE PROC [data_mart].[sp_metrix_participant_availables_incr_find_current_month] AS
BEGIN

  SELECT 
    INT_VALUE 
  FROM 
    [stage_metrix].[t_ctrl_metrix_etl_variables]
  WHERE 
    VARIABLE_NAME = 'current month'

END;