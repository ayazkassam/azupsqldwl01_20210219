CREATE VIEW [STAGE_METRIX].[v_fact_source_metrix_royalty_incr]
AS select cast(convert(varchar(8), EOMONTH(cast(cast(rs.production_date as varchar) + '01' as datetime)), 112) as int) AS activity_period
	, rs.ROYALTY_OWNER_ID as royalty_owner_id	--purchaser
	, rs.PRODUCT_CODE as product
	, rs.OBLIGATION_TYPE as Royalty_Type
	, rs.payment_type 
	, rs.control_group_id
	, DOI_OWNER_ID as royalty_payor
	, w.ENTITY_ID as well_tract_id
	, rs.battery_facility_id 
	, o.royalty_obligation_id 
	, rs.royalty_value
	, rs.royalty_volume as royalty_volumes_metric
	, cast(rs.royalty_volume * coalesce(p.si_to_imp_conv_factor,1) as numeric(9,1)) royalty_volume_imperial
	, cast(rs.royalty_volume * coalesce(p.boe_thermal,1) as numeric(9,1)) royalty_volume_boe
from [STAGE_METRIX].t_stg_metrix_royalty_splits_incr rs
join [STAGE_METRIX_METRIX].ROYALTY_OBLIGATIONS o 
	on rs.well_tract_sys_id = o.well_tract_sys_id 
	and rs.royalty_obligation_sys_id = o.sys_id 
	--- NOT NEEDED >> and rs.product_code = o.product_code
left outer join [STAGE_METRIX_METRIX].WELL_TRACTS w on rs.well_tract_sys_id = w.SYS_ID
LEFT OUTER JOIN [stage_metrix].t_ctrl_metrix_products p ON rs.product_code = p.product_code;