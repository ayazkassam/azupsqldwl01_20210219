CREATE VIEW [STAGE_METRIX].[v_fact_source_metrix_nonop_sales]
AS with nonop_cte as (
	select cast(convert(varchar(8), EOMONTH(cast(cast(p.production_date as varchar) + '01' as datetime)), 112) as int) AS activity_period
		, owner_id as purchaser_id
		, cast(p.product_code as varchar(16)) product
		, cast(transaction_type as varchar(16)) as sales_type
		, cast('BNP' as varchar(6)) as sales_tik
		, cgh.control_group_id control_group_id
		, cast(null as varchar(16)) owner_id 
		, p.well_id as well_tract_id
		, p.battery_facility_id as battery_id
		, cast(null as varchar(16)) as source_facility_id
		, DESTINATION_DELIVERY_SYSTEM_ID target_facility_id
		, cast(0 as varchar(10)) purchaser_sequence
		, cast(0 as varchar(10)) delivery_sequence
		, entered_net_value as sales_value
		, entered_net_volume as sales_volume
		, cast(null as numeric(19,1)) as sales_value_net_of_transport
		, entered_net_gigajoules as actual_gigajoules
		, cast(null as numeric(19,1)) as opening_inventory
		, cast(null as numeric(19,1)) as transfer_received
		, cast(null as numeric(19,1)) as production_volume
		, cast(null as numeric(19,1)) as transfer_sent
		, cast(null as numeric(19,1)) as closing_inventory
		, cast(p.entered_net_volume * coalesce(cp.si_to_imp_conv_factor,1) as numeric(9,1)) sales_volume_imperial
		, cast(p.entered_net_volume * coalesce(cp.boe_thermal,1) as numeric(9,1)) sales_volume_boe
		, wellhead_gas_production
		, wellhead_oil_production
		, pricing_user_defined1
	from [STAGE_METRIX].t_stg_metirx_parnter_op_battery_txns p
	--
	left outer join [stage_metrix].t_ctrl_metrix_products cp ON p.product_code = cp.product_code
	left outer join [STAGE_METRIX_METRIX].FACILITIES f on p.battery_facility_id = f.ENTITY_ID
	left outer join (
			SELECT DISTINCT facility_sys_id,
				production_date,
				first_value(control_group_id) over (partition by facility_sys_id, production_date ORDER BY production_date desc) control_group_id
			FROM [STAGE_METRIX_METRIX].CONTROL_GROUP_HIERARCHIES 
	) cgh on f.sys_id = cgh.facility_sys_id and p.production_date = cgh.production_date
)
/*non op type1,type2,type3,type4,type5*/
select activity_period
	, purchaser_id
	, product
	, sales_type
	, sales_tik
	, control_group_id
	, owner_id
	, well_tract_id
	, battery_id
	, source_facility_id
	, target_facility_id
	, purchaser_sequence
	, delivery_sequence
	,'-1' royalty_payor
	, coalesce(pricing_user_defined1, 'No Contract') ar_contract
	, sales_value
	, sales_volume
	, sales_value_net_of_transport
	, actual_gigajoules
	, opening_inventory
	, transfer_received
	, production_volume
	, transfer_sent
	, closing_inventory
	, sales_volume_imperial
	, sales_volume_boe
from nonop_cte
where sales_value + sales_volume + actual_gigajoules <> 0
and sales_type not in ('TYPE6','TYPE1')
union all
/*gas production volume Type6*/
select activity_period
	, purchaser_id
	, 'GAS' product
	, sales_type
	, sales_tik
	, control_group_id
	, owner_id
	, well_tract_id
	, battery_id
	, source_facility_id
	, target_facility_id
	, purchaser_sequence
	, delivery_sequence
	,'-1' royalty_payor
	, coalesce(pricing_user_defined1, 'No Contract') ar_contract
	, sales_value
	, sales_volume
	, sales_value_net_of_transport
	, actual_gigajoules
	, opening_inventory
	, transfer_received
	, wellhead_gas_production production_volume
	, transfer_sent
	, closing_inventory
	, sales_volume_imperial
	, sales_volume_boe
from nonop_cte
where sales_type in ('TYPE6')
and isnull(wellhead_gas_production,0) <> 0
union all
/*oil production volume Type6*/
select activity_period
	, purchaser_id
	, 'OIL' product
	, sales_type
	, sales_tik
	, control_group_id
	, owner_id
	, well_tract_id
	, battery_id
	, source_facility_id
	, target_facility_id
	, purchaser_sequence
	, delivery_sequence
	,'-1' royalty_payor
	, coalesce(pricing_user_defined1, 'No Contract') ar_contract
	, sales_value
	, sales_volume
	, sales_value_net_of_transport
	, actual_gigajoules
	, opening_inventory
	, transfer_received
	, wellhead_oil_production production_volume
	, transfer_sent
	, closing_inventory
	, sales_volume_imperial
	, sales_volume_boe
from nonop_cte
where sales_type in ('TYPE6')
and isnull(wellhead_oil_production,0) <> 0;