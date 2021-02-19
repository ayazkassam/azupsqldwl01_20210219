CREATE VIEW [stage].[v_rpt_insurance_election]
AS select cc.*
	, ie.insurance_election
from (
	select c.cc_type_code
		, c.cost_centre_id
		, c.cost_centre_name
		, c.license_no
		, c.working_interest_pct
		, o.Operator_ID
		, o.Operator_Name
		, c.op_nonop
	from stage.[t_cost_centre_hierarchy] c
	left outer join (
		select cc.CC_NUM 
			, cc.OPERATOR_CLIENT_ID as Operator_ID
			, c.CLIENT_NAME1 as Operator_Name
		from stage.[t_qbyte_cost_centres] cc
		join stage.[t_qbyte_clients] c on cc.OPERATOR_CLIENT_ID = c.CLIENT_ID
	) o on o.CC_NUM = c.cost_centre_id
	where c.cc_term_date is null
	and c.license_no is not null
) cc
left outer join (
	select distinct licence_number
		, insurance_election
	from stage.t_rpt_csx_well_insurance_election
	where licence_number is not null
) ie on cc.license_no = ie.licence_number;