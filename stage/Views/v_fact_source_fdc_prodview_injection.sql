CREATE VIEW [stage].[v_fact_source_fdc_prodview_injection]
AS SELECT [keymigrationsource] site_id
	, CASE WHEN dttm IS NULL THEN -1 ELSE convert(int,convert(varchar(8),dttm,112)) END activity_date_key
	, [compida] entity_key
	, 'PRODUCTION' data_type
	, 'Production_PV' scenario_key
	, 1 gross_net_key
	, [injected_prod_water]
	, [injected_src_water]
	, injected_gas_c02
	, [injected_pressure_kpag]
FROM [stage].[t_prodview_injection_volumes] p
WHERE not exists (	select keymigrationsource 
					from stage.t_ctrl_prodview_duplicates x 
					where x.keymigrationsource = p.keymigrationsource
					and created_date = (select max(created_date) from stage.t_ctrl_prodview_duplicates));