CREATE VIEW [data_mart_metrix].[v_fact_metrix_fees]
AS select coalesce(activity_period, '-1') activity_period
	, coalesce(control_group_id, '-1') control_group_id
	, coalesce(facility_id, 'Unknown') facility_id
	, coalesce(EntityID,'-1') expenseEntityID
	, coalesce(product_code, '-1') product_code
	, coalesce(charge_type_code, '-1') charge_type_code
	, coalesce(facility_charge_formula_id, '-1') facility_charge_formula_id
	, coalesce(charge_sequence_number,-1) charge_sequence_number
	, coalesce(expense_cost_centre_code, '-1') expense_cost_centre_code
	, coalesce(expense_owner_id, '-1') expense_owner_id
	, coalesce(revenue_cost_centre_code, '-1') revenue_cost_centre_code
	, coalesce(revenue_owner_id, '-1') revenue_owner_id
	, expense_value
	, expense_volume_metric
	, expense_volume_imperial
	, expense_volume_boe
	, gst_value
	, pst_value
from [data_mart_metrix].[t_fact_metrix_fees];