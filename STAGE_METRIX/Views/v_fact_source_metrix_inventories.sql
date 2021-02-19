CREATE VIEW [STAGE_METRIX].[v_fact_source_metrix_inventories]
AS select *
from (
	select cast(convert(varchar(8), EOMONTH(cast(cast(pa.production_date as varchar) + '01' as datetime)), 112) as int) AS activity_period
		, cast(null as varchar(16)) purchaser_id
		, product_code as product
		, pa.PARTICIPANT_TYPE_CODE as sales_type
		, cast('INV' as varchar(6)) as sales_tik
		, cgh.control_group_id
		, pa.owner_id
		, w.ENTITY_ID as well_tract_id
		, f.ENTITY_ID as battery_id
		, pa.sending_battery_facility_id as source_facility_id
		, pa.receiving_battery_facility_id as target_facility_id
		, cast(0 as varchar(10)) purchaser_sequence
		, cast(0 as varchar(10)) delivery_sequence
		, case when pa.PARTICIPANT_TYPE_CODE  in ('CRWN','XCRWN') AND pa.PRODUCT_CODE ='OIL'
		       then pa.WORKING_INTEREST_OWNER_ID
		       else '-1'
		  end royalty_payor
		,  'No Contract' ar_contract
		, cast(null as numeric(19,1)) as sales_value
		, cast(null as numeric(19,1)) as sales_volume
		, cast(null as numeric(19,1)) as sales_volume_imperial
		, cast(null as numeric(19,1)) as sales_volume_boe
		, cast(null as numeric(19,1)) as sales_value_net_of_transport
		, cast(null as numeric(19,1)) as actual_gigajoules
		, sum(pa.opening_inventory) opening_inventory
		, sum(pa.transfer_received) transfer_received
		, sum(pa.production_volume) production_volume
		, sum(pa.transfer_volume) transfer_sent
		, sum(pa.closing_inventory) closing_inventory
	from [STAGE_METRIX_METRIX].PARTICIPANT_AVAILABLES pa
	left outer join ( 
			SELECT DISTINCT facility_sys_id,
				production_date,
				first_value(control_group_id) over (partition by facility_sys_id, production_date ORDER BY production_date desc) control_group_id
			FROM [STAGE_METRIX_METRIX].CONTROL_GROUP_HIERARCHIES 
	) cgh on pa.facility_sys_id = cgh.facility_sys_id and pa.production_date = cgh.production_date
	left outer join [STAGE_METRIX_METRIX].FACILITIES f on pa.FACILITY_SYS_ID = f.SYS_ID
	left outer join [STAGE_METRIX_METRIX].WELL_TRACTS w on pa.well_tract_sys_id = w.SYS_ID
	/* exclude partner operated batteries - this data is duplicated in the partner operated table.
	left outer join [STAGE_METRIX_METRIX].BATTERY_MASTERS bm on f.ENTITY_ID = bm.BATTERY_FACILITY_ID and pa.PRODUCTION_DATE = bm.PRODUCTION_DATE
	where isnull(bm.BATTERY_TYPE,'U') <> 'P' 
	--on  hold for now -- wi owner is necessary*/
	group by w.ENTITY_ID, pa.PARTICIPANT_TYPE_CODE, pa.facility_sys_id, pa.production_date, 
		pa.product_code, pa.owner_id, pa.participant_type_code, pa.sending_battery_facility_id,
		cgh.control_group_id, f.ENTITY_ID, pa.receiving_battery_facility_id,
		case when pa.PARTICIPANT_TYPE_CODE  in ('CRWN','XCRWN') AND pa.PRODUCT_CODE ='OIL'
		       then pa.WORKING_INTEREST_OWNER_ID
		       else '-1'
		  end 
) sq
where (isnull(opening_inventory,0) + isnull(transfer_received,0) + isnull(production_volume,0) 
	+ isnull(transfer_sent,0) + isnull(closing_inventory,0)) <> 0;