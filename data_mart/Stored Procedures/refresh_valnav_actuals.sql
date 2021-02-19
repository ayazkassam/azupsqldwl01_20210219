CREATE PROC [data_mart].[refresh_valnav_actuals] AS
BEGIN
	TRUNCATE TABLE stage.t_rpt_valnav_capital_actuals

	INSERT INTO stage.t_rpt_valnav_capital_actuals
	SELECT *
	FROM stage.[v_rpt_valnav_capital_actuals]

	SELECT 1
END