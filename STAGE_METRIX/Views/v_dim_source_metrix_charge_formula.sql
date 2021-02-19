CREATE VIEW [STAGE_METRIX].[v_dim_source_metrix_charge_formula]
AS select coalesce(fcf.id, fm.facility_charge_formula_id) facility_charge_formula_id
	, fm.formula_description
	, fm.retrieval_code
	, fr.DESCRIPTION as retrieval_description
from [STAGE_METRIX_METRIX].[facility_charge_formulas] fcf
left outer join (
		select distinct facility_charge_formula_id
			, first_value(primary_retrieval_code) over (partition by facility_charge_formula_id order by production_date desc) retrieval_code
			, first_value(description) over (partition by facility_charge_formula_id order by production_date desc) formula_description
		from [STAGE_METRIX_METRIX].[fc_formula_masters]	
) fm on fcf.id = fm.facility_charge_formula_id
left outer join [STAGE_METRIX_METRIX].[fc_formula_retrievals] fr on fm.retrieval_code = fr.code;