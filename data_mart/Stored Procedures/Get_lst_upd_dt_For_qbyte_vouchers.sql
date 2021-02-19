CREATE PROC [data_mart].[Get_lst_upd_dt_For_qbyte_vouchers] AS
BEGIN

	DECLARE @last_update_date DATETIME;
    SELECT @last_update_date = max(last_update_date) from stage.t_qbyte_vouchers

	UPDATE  STAGE.T_CTRL_ETL_VARIABLES
		SET DATE_VALUE = dateadd(minute, -2, @last_update_date) 
		-- purposely go back 2 minutes to account for any possible delays
		WHERE VARIABLE_NAME ='QBYTE_LAST_UPDATE_DATE_TEMP';

	SELECT 
	  --convert(varchar(20), date_value, 20) [lst_upd_dt],
	  CAST(date_value AS DATETIME)  [lst_upd_dt]
    FROM 
	  [stage].[T_CTRL_ETL_VARIABLES]  
	WHERE VARIABLE_NAME ='QBYTE_LAST_UPDATE_DATE_LATEST'

END;