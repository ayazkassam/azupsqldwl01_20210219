CREATE VIEW [dbo].[v_dim_scenario_leaseops]
AS SELECT [scenario_key],
       scenario_parent_key,
	   scenario_description,
	   scenario_cube_name,
	   unary_operator,
	   scenario_formula,
	   scenario_formula_property,
	   scenario_sort_key
  FROM [data_mart].[t_dim_scenario]
  WHERE scenario_cube_name='Lease Ops'
   --
 UNION ALL
 --
 SELECT [scenario_key],
       scenario_parent_key,
	   scenario_description,
	   scenario_cube_name,
	   unary_operator,
	   scenario_formula,
	   scenario_formula_property,
	   scenario_sort_key
  FROM [dbo].v_dim_valnav_current_prior_budget_scenario_source
  WHERE scenario_cube_name='Lease Ops'
   --
  UNION ALL
  --
  SELECT DISTINCT substring(document,1,3) scenario_key,
       'Powervision' scenario_parent_key,
	   substring(document,1,3) scenario_description,
	   'Lease Ops' scenario_cube_name,
	   '+' unary_operator,
	   null scenario_formula,
	   null scenario_formula_property,
	   '105_' + substring(document,1,3) scenario_sort_key
  FROM [stage].v_fact_source_powervision
   --
  UNION ALL
  --
 SELECT voucher_type_code scenario_key,
       CASE WHEN voucher_type_code = 'ACCRU' THEN 'ACR'
	        ELSE 'ACT' 
	   END scenario_parent_key,
	   [stage].InitCap(voucher_type_desc) scenario_description,
	   'Lease Ops' scenario_cube_name,
	   '+' unary_operator,
	   null scenario_formula,
	   null scenario_formula_property,
	   '0100.001_' + voucher_type_code scenario_sort_key
 FROM [stage].t_qbyte_voucher_types


 union all

  select 'WI'
	, 'ACT'
	, 'WI'
	, 'Lease Ops'
	, '+'
	, null, null, '0100.001_WI';