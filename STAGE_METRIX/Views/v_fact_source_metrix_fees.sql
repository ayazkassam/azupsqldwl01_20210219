CREATE VIEW [STAGE_METRIX].[v_fact_source_metrix_fees]
AS select cast(convert(varchar(8), EOMONTH(cast(cast(d.production_date as varchar) + '01' as datetime)), 112) as int) AS activity_period
		, fc.control_group_id
		, f.entity_id as facility_id
		, fc.product_code
		, fc.charge_type_code
		, fc.facility_charge_formula_id
		, convert(int,fc.SEQUENCE_NUMBER) as charge_sequence_number
		, case	when ef.entity_id is not null then 'F'
				when w.entity_id is not null then 'W'
				when d.expense_unit_id is not null then 'U' end as EntityType
		, coalesce(ef.entity_id, w.entity_id, d.expense_unit_id) EntityID
		, d.expense_cost_centre_code
		, d.expense_owner_id	
		, case when d.revenue_cost_centre_code = 'NA' then d.expense_cost_centre_code else d.revenue_cost_centre_code end revenue_cost_centre_code
		, d.revenue_owner_id
		, d.expense_doi_sub_used
		, d.revenue_doi_sub_used
				
		, d.expense_value	
		, d.expense_volume
		, d.gst_value
		, d.pst_value
		, cast(d.expense_volume * coalesce(p.si_to_imp_conv_factor,1) as numeric(9,1)) expense_volume_imperial
		, cast(d.expense_volume * coalesce(p.boe_thermal,1) as numeric(9,1)) expense_volume_boe
	from [STAGE_METRIX].t_stg_metrix_fc_distributions d
	join [STAGE_METRIX].t_stg_metrix_facility_charges fc on d.facility_charge_sys_id = fc.sys_id and d.production_date = fc.production_date
	left outer join [STAGE_METRIX_METRIX].well_tracts w on d.expense_well_tract_sys_id = w.sys_id
	left outer join [STAGE_METRIX_METRIX].facilities ef on d.expense_facility_sys_id = ef.sys_id
	left outer join [STAGE_METRIX_METRIX].facilities f on fc.facility_sys_id = f.sys_id
	LEFT OUTER JOIN [stage_metrix].t_ctrl_metrix_products p ON fc.product_code = p.product_code;