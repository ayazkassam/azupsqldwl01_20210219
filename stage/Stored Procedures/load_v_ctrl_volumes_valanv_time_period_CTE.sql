CREATE PROC [stage].[load_v_ctrl_volumes_valanv_time_period_CTE] AS
BEGIN
  SET NOCOUNT ON

  DECLARE
	@Inc INT = 0,
	@Number INT = (
                    SELECT datediff(day,start_date2,end_date2)+1
					FROM
						(SELECT CAST(variable_value +'0101' AS INT) start_date,
								CAST(variable_value +'0101' AS date) start_date2,
								CAST(CAST(variable_value+1 AS VARCHAR(4))+'1231' AS INT) end_date,
								CAST(CAST(variable_value+1 AS VARCHAR(4))+'1231' AS date) end_date2
						 FROM [stage].[t_ctrl_valnav_etl_variables]
					     WHERE variable_name = 'CURRENT_BUDGET_YEAR_DAILY_DATA') s
	              )

  TRUNCATE TABLE [stage].[v_ctrl_volumes_valanv_time_period_CTE]
  
  WHILE @Inc < @Number
    BEGIN
	  SET @Inc = @Inc + 1

	  INSERT INTO [stage].[v_ctrl_volumes_valanv_time_period_CTE] (Number)
	  VALUES(@Inc)
	END

  SELECT 1
END