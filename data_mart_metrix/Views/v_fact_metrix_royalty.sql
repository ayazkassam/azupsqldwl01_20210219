CREATE VIEW [data_mart_metrix].[v_fact_metrix_royalty]
AS select coalesce(activity_period, '-1') activity_period
	, coalesce(royalty_owner_id, '-1') royalty_owner_id
	, coalesce(product_code, '-1') product_code
	, coalesce(royalty_type, '-1') royalty_type
	, coalesce(payment_type, '-1') payment_type
	, coalesce(control_group_id, '-1') control_group_id
	, coalesce(royalty_payor_id, '-1') royalty_payor_id
	, coalesce(well_tract_id, 'Other Receipts') well_tract_id
	, coalesce(battery_id, 'Unknown') battery_id
	, coalesce(royalty_obligation_sequence, '-1') royalty_obligation_sequence
	, royalty_value
	, royalty_volume_metric
	, royalty_volume_imperial
	, royalty_volume_boe
from [data_mart_metrix].[t_fact_metrix_royalty];