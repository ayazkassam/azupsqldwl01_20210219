CREATE VIEW [stage_ihs].[v_fact_accumap]
AS select f.uwi
	, f.activity_date
	, case when f.on_prod_date_key < md.minDate then -2 else f.on_prod_date_key end on_prod_date_key
	, case when f.spud_date_key < md.minDate then -2 else f.spud_date_key end spud_date_key		
	, case when f.rig_release_date_key < md.minDate then -2 else f.rig_release_date_key end rig_release_date_key
	, f.License_Number
	, f.operator
	, f.normalized_days_key
	, f.gas_metric_volume
	, f.gas_imperial_volume
	, f.gas_boe_volume
	, f.gas_mcfe_volume
	, f.oil_metric_volume
	, f.oil_imperial_volume
	, f.oil_boe_volume
	, f.oil_mcfe_volume
	, f.condensate_metric_volume
	, f.condensate_imperial_volume
	, f.condensate_boe_volume
	, f.condensate_mcfe_volume
	, f.water_metric_volume
	, f.water_imperial_volume
	, f.water_boe_volume
	, f.water_mcfe_volume
	, f.total_boe_volume
	, f.p_hours
	, f.day_counter
	, f.prodmth_day_counter
from [stage_ihs].t_fact_accumap f
, (	select min(date_key) minDate from data_mart.dim_date where full_Date is not null) md;