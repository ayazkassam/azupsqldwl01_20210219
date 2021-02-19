CREATE VIEW [stage].[v_rpt_valnav_capital_actuals]
AS select va.entity_id
	, e.region_name
	, e.district_name
	, e.area_name
	, e.facility_name
	, e.cost_centre
	, va.uwi
	, va.formatted_uwi
	, va.cost_date
	, va.value 
	, va.afe_num
	, va.cost_type
	, va.approved_estimate
	, va.revised_estimate
	, va.end_date
	, va.incurred_total
from (
	select ent.object_id as entity_id
		, ent.UNIQUE_ID as uwi
		, ent.formatted_id as formatted_uwi
		, convert(date,eca.cost_date) cost_date
		, eca.value 
		, ece.afe_num
		, ece.cost_type
		, ece.approved_estimate
		, ece.revised_estimate
		, convert(date,ece.end_date) end_date
		, ece.incurred_total
	from stage_valnav.t_budget_entity ent
	join stage_valnav.t_budget_ent_capital_actual eca on ECA.PARENT_ID = ENT.OBJECT_ID
	join stage_valnav.t_budget_ent_capital_estimate ece on ECE.PARENT_ID = ent.object_id and eca.AFE_ID = ece.AFE_ID
	join stage_valnav.t_budget_ent_import_id eii on EII.PARENT_ID = ent.object_id
	where EII.VENDOR_ID = 'D81D8E00-D389-4544-B712-7AEB76D0F2DB'
) va
left outer join data_mart.t_dim_entity e
  on e.entity_key = va.entity_id and e.is_valnav = 1;