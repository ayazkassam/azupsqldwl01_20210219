CREATE VIEW [stage].[v_fact_source_valnav_royalty_by_product_calculations_typecurves]
AS SELECT e.object_id entity_id,
	CASE WHEN  rbp.step_date IS NULL THEN -1 ELSE convert(int,convert(varchar(8),rbp.step_date,112)) END activity_date_key,

	vp.product_id,
	RTRIM(LTRIM (e.unique_id)) AS uwi,
	cast(rl.reserve_category_id as varchar(50)) AS reserve_category_id,
	CASE WHEN vp.product_id = 2 THEN 'Sales' + cl.long_name ELSE cl.long_name END AS accounts, 
	'Type Curve' AS scenario_type,
	vev2.cube_child_member AS scenario,
	CAST(CASE WHEN od.onstream_date IS NULL  OR datediff(MONTH,od.onstream_date, rbp.step_date)+1 >= mp.max_on_prod_days THEN '-1'
		ELSE CASE WHEN od.onstream_date IS NULL OR datediff(MONTH,od.onstream_date, rbp.step_date)+1 <= 0 THEN '-1'
		ELSE CONCAT(RIGHT(CONCAT('0',datediff(MONTH,od.onstream_date, rbp.step_date)+1),2),'.01') END END AS VARCHAR(5)) AS normalized_time_key,
	/*-- REVENUES*/
	rbp.gross_revenue,
	rbp.wi_revenue,
	rbp.ri_revenue,
	rbp.fi_revenue,
	rbp.net_revenue,
	/*-- ROYALTIES (Totals for verification only)*/
	rb.roy_adj_crown,
	rb.roy_adj_freehold,
	rb.roy_adj_gor,
	rb.roy_adj_indian,
	/*-- CALCULATIONS*/
	/*-- ORR*/
	CASE WHEN sum(rbp.wi_revenue) over (partition by e.object_id, rbp.step_date,rl.reserve_category_id) = 0 THEN NULL
		ELSE (rb.roy_adj_gor / sum(rbp.wi_revenue) over (partition by e.object_id, rbp.step_date,rl.reserve_category_id) ) * rbp.wi_revenue END gor_royalty,
	/*--Freehold*/
	CASE WHEN sum(rbp.wi_revenue) over (partition by e.object_id, rbp.step_date,rl.reserve_category_id) = 0 THEN NULL
		ELSE (rb.roy_adj_freehold / sum(rbp.wi_revenue) over (partition by e.object_id, rbp.step_date,rl.reserve_category_id) ) * rbp.wi_revenue END freehold_royalty,
	/*--Indian*/
	CASE WHEN sum(rbp.wi_revenue) over (partition by e.object_id, rbp.step_date,rl.reserve_category_id) = 0 THEN NULL
		ELSE (rb.roy_adj_indian / sum(rbp.wi_revenue) over (partition by e.object_id, rbp.step_date,rl.reserve_category_id) ) * rbp.wi_revenue END indian_royalty,
	/*-- Cr Royalty Payable*/
	CASE WHEN rb.roy_adj_crown = 0 AND rb.roy_adj_total = 0 THEN 0 
	ELSE (rbp.wi_revenue + rbp.ri_revenue) - rbp.net_revenue -
		CASE WHEN sum(rbp.wi_revenue) over (partition by e.object_id, rbp.step_date,rl.reserve_category_id) = 0 THEN 0
			ELSE ((rb.roy_adj_gor / sum(rbp.wi_revenue) over (partition by e.object_id, rbp.step_date,rl.reserve_category_id) ) * rbp.wi_revenue) END /*-- orr*/
		- CASE WHEN sum(rbp.wi_revenue) over (partition by e.object_id, rbp.step_date,rl.reserve_category_id) = 0 THEN 0
			ELSE ((rb.roy_adj_freehold / sum(rbp.wi_revenue) over (partition by e.object_id, rbp.step_date,rl.reserve_category_id) ) * rbp.wi_revenue) END /*-- Freehold*/
		- CASE WHEN sum(rbp.wi_revenue) over (partition by e.object_id, rbp.step_date,rl.reserve_category_id)  = 0 THEN 0
			ELSE ((rb.roy_adj_indian / sum(rbp.wi_revenue) over (partition by e.object_id, rbp.step_date,rl.reserve_category_id) ) * rbp.wi_revenue) END /*-- Indian*/
		- CASE WHEN sum(rbp.wi_revenue) over (partition by e.object_id, rbp.step_date,rl.reserve_category_id)  = 0 THEN 0
			ELSE ((rb.roy_mineral_tax / sum(rbp.wi_revenue) over (partition by e.object_id, rbp.step_date,rl.reserve_category_id) ) * rbp.wi_revenue) END /*-- Mineral Tax*/
		END crown_royalty,
	/*--Mineral Tax*/
	CASE WHEN sum(rbp.wi_revenue) over (partition by e.object_id, rbp.step_date,rl.reserve_category_id) = 0 THEN NULL
		ELSE (rb.ROY_MINERAL_TAX / sum(rbp.wi_revenue) over (partition by e.object_id, rbp.step_date,rl.reserve_category_id) ) * rbp.wi_revenue END mineral_tax_royalty,
	/*--sask_cap_surcharge_royalty*/
	CASE WHEN sum(rbp.wi_revenue) over (partition by e.object_id, rbp.step_date,rl.reserve_category_id) = 0 THEN NULL
		ELSE (rb.SASK_CAP_SURCHARGE / sum(rbp.wi_revenue) over (partition by e.object_id, rbp.step_date,rl.reserve_category_id) ) * rbp.wi_revenue END sask_cap_surcharge_royalty

FROM (
	SELECT year(cast(variable_value as datetime)) first_year
	FROM [stage].t_ctrl_valnav_etl_variables
	WHERE variable_name='VALNAV_ACTIVITY_DATE_START'
) trs
, (
	SELECT year(cast(variable_value as datetime)) last_year
	FROM [stage].t_ctrl_valnav_etl_variables
	WHERE variable_name='VALNAV_ACTIVITY_DATE_END'
) tre
, (
	SELECT variable_value AS max_on_prod_days
	FROM [stage].T_CTRL_VALNAV_ETL_VARIABLES
	WHERE variable_name = 'MAX_PROD_DAYS_ON_MONTHS'
) mp
, stage_valnav.t_typecurves_RESULTS_BTAX_PRODUCT rbp
LEFT OUTER JOIN stage_valnav.t_typecurves_RESULTS_LOOKUP rl ON rbp.result_id = rl.result_id
LEFT OUTER JOIN stage_valnav.t_typecurves_ENTITY e ON rl.entity_id = e.object_id 
INNER JOIN (
		SELECT variable_value
		FROM T_CTRL_VALNAV_ETL_VARIABLES
		WHERE variable_name = 'RESERVE_CATEGORY_ID'
) vev ON rl.reserve_category_id = vev.variable_value
INNER JOIN (
		SELECT fsp.object_id, fsp.long_name
		FROM stage_valnav.t_typecurves_CODE_LOOKUP cl
		join stage_valnav.t_typecurves_FISC_RESERVES_PRODUCT fsp on cl.LONG_NAME = fsp.LONG_NAME
		WHERE code_type = 'RESERVES_PRODUCT_TYPE'
) cl ON rbp.product_id = cl.object_id
INNER JOIN (
		SELECT fsp.plan_id, fs.OBJECT_ID
		FROM stage_valnav.t_typecurves_FISC_SCENARIO fs
		LEFT OUTER JOIN stage_valnav.t_typecurves_FISC_SCENARIO_PARAMS fsp ON (fs.object_id = fsp.parent_id)
		WHERE fs.name = '<Current Options>'
) sn ON rl.scenario_id = sn.object_id
LEFT OUTER JOIN [stage].t_ctrl_valnav_products vp ON cl.long_name = vp.accounts
INNER JOIN (
		SELECT *
		FROM [stage].t_stg_valnav_typecurves_ent_custom_field_def
		WHERE name='Budget Year'
) cfd ON rl.entity_id = cfd.parent_id
INNER JOIN (
		SELECT variable_value, cube_child_member, sign_flip_flag
		FROM [stage].T_CTRL_VALNAV_ETL_VARIABLES
		WHERE variable_name = 'TYPE_CURVES_BUDGET_YEAR'
		AND ISNULL (sign_flip_flag, 'N') <> 'Y'
) vev2 ON  ltrim(rtrim(cfd.string_value)) = vev2.variable_value
LEFT OUTER JOIN (
		SELECT object_id, first_step_date onstream_date
		FROM [stage].t_valnav_onstream_date_typecurves
) od ON rl.entity_id = od.object_id
LEFT OUTER JOIN stage_valnav.t_typecurves_RESULTS_BTAX rb ON rb.result_id = rl.result_id
AND rbp.step_date = rb.step_date
WHERE rl.plan_definition_id = 0
AND year(rbp.step_date) BETWEEN trs.first_year AND tre.last_year;