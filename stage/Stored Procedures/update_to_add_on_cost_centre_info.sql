CREATE PROC [stage].[update_to_add_on_cost_centre_info] AS
BEGIN
	UPDATE stage.t_rpt_valnav_capital_actuals
	SET region_name = e.region_name,
		district_name	 = e.district_name,
		area_name		 = e.area_name,
		facility_name	 = e.facility_name,
		cost_centre	 = e.cost_centre
	FROM data_mart.t_dim_entity e
	WHERE 
	  e.entity_key = stage.t_rpt_valnav_capital_actuals.entity_id AND
	  e.is_valnav = 1

	SELECT 1
END