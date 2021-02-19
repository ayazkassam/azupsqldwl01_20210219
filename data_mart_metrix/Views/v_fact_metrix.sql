CREATE VIEW [data_mart_metrix].[v_fact_metrix]
AS select coalesce(activity_period, '-1') activity_period
	, coalesce(purchaser_id, '-1') purchaser_id
	, coalesce(product_code, '-1') product_code
	, coalesce(sales_type, '-1') sales_type
	, coalesce(sales_tik, '-1') sales_tik
	, coalesce(control_group_id, '-1') control_group_id
	, coalesce(owner_id, '-1') owner_id
	, coalesce(well_tract_id, 'Other Receipts') well_tract_id
	, coalesce(battery_id, 'Unknown') battery_id
	, coalesce(source_facility_id, 'Unknown') source_facility_id
	, coalesce(target_facility_id, 'Unknown') target_facility_id
	, coalesce(purchaser_sequence, '-1') purchaser_sequence
	, coalesce(delivery_sequence, '-1') delivery_sequence
	, coalesce(royalty_payor,'-1') royalty_payor
	, coalesce(ar_contract, 'No Contract') ar_contract
	, sales_value
	, sales_volume
	, sales_volume_imperial
	, sales_volume_boe
	, sales_value_net_of_transport
	, actual_gigajoules
	, opening_inventory
	, transfer_received
	, production_volume
	, transfer_sent
	, closing_inventory
from [data_mart_metrix].[t_fact_metrix];