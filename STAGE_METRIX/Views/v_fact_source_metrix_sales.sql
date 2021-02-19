CREATE VIEW [STAGE_METRIX].[v_fact_source_metrix_sales]
AS SELECT cast(convert(varchar(8), EOMONTH(cast(cast(sd.production_date as varchar) + '01' as datetime)), 112) as int) AS activity_period
	, sd.purchaser_id purchaser_id
	, sd.product_code product
	, sd.owner_type_code sales_type
	, case	when sd.revenue_not_received_reason is null and owner_id in (1,7,2) then 'BNP' 
			when sd.revenue_not_received_reason is null and owner_id not in (1,7,2) then 'FTIK' 
			else sd.revenue_not_received_reason end sales_tik
	, sd.control_group_id
	, sd.owner_id
	, w.ENTITY_ID as well_tract_id
	, f.ENTITY_ID as battery_id
	, sd.battery_facility_id as source_facility_id
	, sd.delivery_system_id target_facility_id
	, cast(sd.purchaser_sequence as varchar(10)) purchaser_sequence
	, cast(sd.delivery_sequence as varchar(10)) delivery_sequence
	, coalesce(sd.crown_royalty_payor,'-1') royalty_payor
	, coalesce(sd.pricing_user_defined1, 'No Contract') ar_contract
	, sd.sales_value
	, sd.sales_volume
	, sd.sales_value_net_of_transport
	, sd.actual_gigajoules
	, cast(null as numeric(19,1)) as opening_inventory
	, cast(null as numeric(19,1)) as transfer_received
	, cast(null as numeric(19,1)) as production_volume
	, cast(null as numeric(19,1)) as transfer_sent
	, cast(null as numeric(19,1)) as closing_inventory
	, cast(sd.sales_volume * coalesce(p.si_to_imp_conv_factor,1) as numeric(9,1)) sales_volume_imperial
	, cast(sd.sales_volume * coalesce(p.boe_thermal,1) as numeric(9,1)) sales_volume_boe
FROM ( 
		select production_date
			, purchaser_id
			, case	
					when product_code = 'C2MX' then 'C2'
					when product_code = 'C3MX' then 'C3'
					when product_code = 'C3SP' then 'C3'
					when product_code = 'C4MX' then 'C4'
					when product_code = 'C4SP' then 'C4' 
					when product_code = 'C5SP' then 'C5' 
					when product_code = 'C5MX' then 'C5' 
					when product_code = 'C2SP' then 'C2'
					else product_code 
			  end product_code
			/* change C5SP to C5 as per Paige's email on Feb 25, 2019 */
			, owner_type_code
			, revenue_not_received_reason
			, control_group_id
			, owner_id
			, well_tract_sys_id
			, sd.FACILITY_SYS_ID
			, battery_facility_id
			, COALESCE(delivery_system_id, f.facility_id) delivery_system_id
			, purchaser_sequence
			, delivery_sequence
			, CASE WHEN owner_type_code IN ('CRWN','XCRWN') AND product_code = 'OIL'
				THEN REFERENCE_OWNER_ID
				ELSE NULL
			  END crown_royalty_payor
			, pricing_user_defined1
			, sales_value
			, sales_volume
			, sales_value_net_of_transport
			, actual_gigajoules
	from [stage_metrix].t_stg_metrix_sales_details sd
	left outer join [data_mart_metrix].[t_dim_facility] f on sd.delivery_facility_sys_id = f.facility_sys_id
) sd
left outer join [stage_metrix_metrix].WELL_TRACTS w on sd.well_tract_sys_id = w.SYS_ID
left outer join [stage_metrix_metrix].FACILITIES f on sd.FACILITY_SYS_ID = f.SYS_ID
LEFT OUTER JOIN [stage_metrix].t_ctrl_metrix_products p ON sd.product_code = p.product_code;