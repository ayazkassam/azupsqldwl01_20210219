CREATE VIEW [STAGE_METRIX].[v_rpt_royalty_obligations]
AS select cast(o.production_date as varchar(6)) production_date
	, coalesce(o.control_group_id,'Unknown') control_group_id
	, w.well_tract_id
	, w.Well_Tract_Name
	, o.royalty_obligation_id
	, o.royalty_owner_id
	, p.purchaser_name as royalty_owner_name
	, o.royalty_type
	, o.payment_type
	, o.product_code
	, o.royalty_formula_id
	, fm.description formula_description
	, f.royalty_global_factor_id 
	, gfm.description as factor_description
	, f.factor
	, f.required_flag
	, o.WELL_TRACT_SYS_ID
from (
	select distinct o.sys_id
		, o.royalty_obligation_id
		, o.well_tract_sys_id
		, o.product_code
		, om.PRODUCTION_DATE
		, om.royalty_formula_id
		, om.obligation_type royalty_type
		, om.payment_type
		, om.royalty_owner_id
		, rs.CONTROL_GROUP_ID
	from STAGE_METRIX_METRIX.[ROYALTY_OBLIGATIONS] o
	join STAGE_METRIX_METRIX.[ROYALTY_OBLIGATION_MASTERS] om on o.SYS_ID = om.ROYALTY_OBLIGATION_SYS_ID
	left outer join stage_metrix.t_rpt_royalty_control_groups rs on rs.well_tract_sys_id = o.well_tract_sys_id 
		and rs.royalty_obligation_sys_id = o.sys_id 
		and rs.product_code = o.product_code
		and rs.production_date = om.production_date
) o
join STAGE_METRIX_METRIX.[ROYALTY_FORMULA_MASTERS] fm on o.ROYALTY_FORMULA_ID = fm.ROYALTY_FORMULA_ID and o.PRODUCTION_DATE = fm.PRODUCTION_DATE
join STAGE_METRIX_METRIX.[ROYALTY_OBLIG_FACTOR_VALUES] f on f.ROYALTY_OBLIGATION_SYS_ID = o.SYS_ID and f.PRODUCTION_DATE = o.PRODUCTION_DATE
join STAGE_METRIX_METRIX.[ROYALTY_GLOBAL_FACTOR_MASTERS] gfm on f.ROYALTY_GLOBAL_FACTOR_ID = gfm.ROYALTY_GLOBAL_FACTOR_ID and f.PRODUCTION_DATE = gfm.PRODUCTION_DATE
left outer join data_mart_metrix.t_dim_well w on w.Well_Tract_Sys_ID = o.WELL_TRACT_SYS_ID
left outer join data_mart_metrix.t_dim_purchaser p on o.royalty_owner_id = p.purchaser_id;