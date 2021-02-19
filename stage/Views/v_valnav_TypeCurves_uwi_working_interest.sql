CREATE VIEW [stage].[v_valnav_TypeCurves_uwi_working_interest]
AS SELECT wi.uwi,
	wi.entity_object_id,
	wi.reversion_interest_object_id,
	wi.reversion_interest_parent_id,
/*	CASE WHEN wi.effective_date IS NULL THEN 
		CASE WHEN dd.first_drill_date > wi.next_effective_date THEN cast('1900-01-01' as datetime) 
			else case when year(reversion_date) > year(dd.first_drill_date) then isnull(reversion_date,cast('1900-01-01' as datetime))
						ELSE isnull(dd.first_drill_date, cast('1900-01-01' as datetime)) END END
		ELSE wi.effective_date END effective_date,
	wi.reversion_type,
	case when isnull(wi.reversion_type,1) = 3 then dd.first_drill_date end first_drill_date,
*/
	wi.effective_date,
	wi.next_effective_date,
	wi.working_interest,
	wi.working_interest * isnull(tract_factor,1) * isnull(pooling_factor,1) AS tract_working_interest,
	wi.op_cost_interest,
	wi.cap_cost_interest,
	wi.facility_interest,
	wi.freehold_interest_receivable,
	wi.gor_receivable,
	wi.nor_receivable,
	wi.tract_factor,
	wi.pooling_factor,
	wi.royalty_factor,
	wi.sort_index,
	rrd.date_value AS reserves_realized_date,
	CASE WHEN rrd.date_value IS NOT NULL 
		AND ((rrd.date_value >= wi.effective_date AND rrd.date_value < wi.next_effective_date) 
			OR (rrd.date_value < wi.min_effective_date AND wi.effective_date = wi.min_effective_date)) 
		THEN 'Y' ELSE 'N' END AS is_reserves_realized_wi,
	wi.royalty_income_interest,
	wi.chance_of_success,
	wi.primary_product,
	wi.depth_gci
FROM (
	/*-- wi*/
	SELECT ent.uwi,
		ent.entity_object_id,
		ent.reserve_category_id,
		ent.max_reserve_category_id,
		eri.object_id AS reversion_interest_object_id,
		eri.parent_id AS reversion_interest_parent_id,
		eri.effective_date,
		eri.next_effective_date,
		eri.working_interest,
		eri.op_cost_interest,
		eri.cap_cost_interest,
		eri.facility_interest,
		eri.freehold_interest_receivable,
		eri.gor_receivable,
		eri.nor_receivable,
		eri.tract_factor,
		eri.pooling_factor,
		eri.royalty_factor,
		eri.sort_index,
		eri.effective_date min_effective_date,
		SUM ((eri.freehold_interest_receivable + eri.gor_receivable) * 100) OVER (PARTITION BY eri.object_id) AS royalty_income_interest,
		ent.chance_of_success * 100 chance_of_success,
		ent.primary_product,
		ent.depth_gci,
		eri.reversion_type,
		eri.reversion_date
	FROM (
		/*--eri*/
		SELECT object_id,
			parent_id,
			sort_index,
			working_interest,
			op_cost_interest,
			cap_cost_interest,
			facility_interest,
			freehold_interest_receivable,
			gor_receivable,
			nor_receivable,
			tract_factor,
			pooling_factor,
			royalty_factor,
			reversion_date,
			reversion_type		
			, isnull(lag(reversion_date) over (partition by parent_id order by sort_index),'19000101') effective_date
			, isnull(reversion_date,ed.endDate) next_effective_date
			/*	-- BPO/APO1 situtaion..this being BPO
				-- start date is begining of time or first time capital expendeded 
			CASE WHEN isnull(reversion_type,1) = 3 THEN NULL /*-- NULL on purpose SO drill date can be used -- see above*/
				ELSE CASE WHEN count(parent_id) over (partition by parent_id) > 1
					THEN cast(isnull(next_reversion_date,dsd.default_start_date) as datetime)+1 /*-- multiple deck 2nd deck  -- set this a day forward to ensure that the second deck is choosen*/
					ELSE isnull(next_reversion_date,dsd.default_start_date) /*-- one deck only*/ END
				END effective_date,
			CASE WHEN isnull(reversion_type,1) = 3 THEN effective_date /*-- multiple deck with BPO*/
				ELSE cast('2100-12-31' as datetime) /*-- else 1 deck or 2nd deck of BPO*/ END AS next_effective_date*/
		FROM stage_valnav.t_typecurves_ENT_REVERSION_INTEREST eri
		, (select max(full_date) endDate from data_mart.dim_date) ed
		WHERE working_interest IS NOT NULL
		AND sort_index IS NOT NULL
	) eri
	LEFT OUTER JOIN (
				/*--ent*/
				SELECT LTRIM(RTRIM(e.unique_id)) AS uwi,
					rs.primary_product,
					rs.gross_comp_interval depth_gci,
					e.object_id AS entity_object_id,
					rs.object_id AS plan_object_id,
					rc.object_id AS reserves_category_object_id,
					ci.object_id AS company_interest_object_id,
					li.object_id AS lease_interest_object_id,
					pi.object_id AS product_interest_object_id,
					rc.reserve_category_id,
					rc.chance_of_success,
					max(rc.reserve_category_id) over (partition by e.object_id order by e.object_id desc) max_reserve_category_id				
				FROM stage_valnav.t_typecurves_ENTITY e
				LEFT OUTER JOIN (
							/*change primary product*/
							SELECT DISTINCT ep.object_id,
								ep.parent_id,
								espd.gross_comp_interval,
								FIRST_VALUE (espd.primary_product) OVER (PARTITION BY ep.object_id, ep.parent_id, ep.plan_definition_id 
														ORDER BY ep.last_modified_date DESC, espd.primary_product) AS primary_product
							FROM stage_valnav.t_typecurves_ENT_PLAN ep
							, (	
								select pd.parent_id
									, pd.plan_definition_id
									, pd.gross_comp_interval
									, p.PRODUCT_ID primary_product
								FROM stage_valnav.t_typecurves_ENT_SHARED_PLAN_DATA pd
								left outer join (
											select ed.PARENT_ID
												, ed.PRODUCT_LIST_ID
												, p.PRODUCT_ID
											from stage_valnav.t_typecurves_ENT_DETAIL ed
											left outer join stage_valnav.t_typecurves_FISC_PRODUCT_LIST_VALUE p on ed.PRODUCT_LIST_ID = p.PARENT_ID
											where IS_PRIMARY = 1
								) p on pd.PARENT_ID = p.PARENT_ID
							) espd
							WHERE ep.parent_id = espd.parent_id
							AND ep.plan_definition_id =  espd.plan_definition_id
							AND ep.plan_definition_id = 0
				) rs ON e.object_id = rs.parent_id
				LEFT OUTER JOIN (
							SELECT erc.*
							FROM stage_valnav.t_typecurves_ENT_RESERVES_CATEGORY erc
							WHERE erc.reserve_category_id IN ('1311','1')
				) rc ON rs.object_id = rc.parent_id
				LEFT OUTER JOIN (
							SELECT ci.*, c.name company_name
							FROM stage_valnav.t_typecurves_ENT_COMPANY_INTEREST ci
							, stage_valnav.t_typecurves_COMPANY c
							WHERE c.name in ('(default)','(default company)')
							AND c.object_id = ci.company_id
				) ci ON rc.object_id = ci.parent_id
				LEFT OUTER JOIN (
							SELECT *
							FROM stage_valnav.t_typecurves_ENT_LEASE_INTEREST
							WHERE name LIKE 'Lease%'
				) li ON ci.object_id = li.parent_id
				LEFT OUTER JOIN (
							SELECT *
							FROM stage_valnav.t_typecurves_ENT_PRODUCT_INTEREST
							WHERE product = 'GEN'	/*changed from -1*/
				) pi ON li.object_id = pi.parent_id
				WHERE ci.company_name IS NOT null 
				AND li.name IS NOT NULL /*-- li.name is lease name*/
	) ent ON eri.parent_id = ent.product_interest_object_id
	WHERE ent.uwi IS NOT NULL
) wi
LEFT OUTER JOIN (
		SELECT *
		FROM [stage].t_stg_valnav_budget_ent_custom_field_def
		WHERE RTRIM(LTRIM (name)) = 'Reserves Realized Date'
) rrd ON wi.entity_object_id = rrd.parent_id
/*LEFT OUTER JOIN (
		/*--drill date*/
		SELECT e.object_id AS entity_key,
			MIN(rcd.step_date) first_drill_date
		FROM (
				SELECT *
				FROM stage_valnav.t_typecurves_RESULTS_COST_DETAIL rcd
				WHERE (isnull(rcd.success_gross_value,0) + isnull(rcd.success_interest_value,0) 
					+ isnull(rcd.failure_gross_value,0) + isnull(rcd.failure_interest_value,0)) <> 0
		) rcd
		LEFT OUTER JOIN stage_valnav.t_typecurves_RESULTS_LOOKUP rl ON rcd.result_id = rl.result_id
		LEFT OUTER JOIN	stage_valnav.t_typecurves_ENTITY e ON rl.entity_id = e.object_id
		INNER JOIN (
				SELECT variable_value
				FROM stage.T_CTRL_VALNAV_ETL_VARIABLES
				WHERE variable_name = 'RESERVE_CATEGORY_ID'
		) vev ON rl.reserve_category_id = vev.variable_value
		INNER JOIN (
				select OBJECT_ID, NAME
				from BNPBUDGETSCOPY.FISC_CAP_COST
		) cl ON rcd.COST_DEFINITION_ID = cl.OBJECT_ID
		INNER JOIN (
				SELECT fsp.plan_id, fs.*
				FROM stage_valnav.t_typecurves_FISC_SCENARIO fs
				LEFT OUTER JOIN stage_valnav.t_typecurves_FISC_SCENARIO_PARAMS fsp ON (fs.object_id = fsp.parent_id)
				WHERE fs.name = '<Current Options>'
		) sn ON rl.scenario_id = sn.object_id
		INNER JOIN (
				SELECT *
				FROM [stage].t_stg_valnav_budget_ent_custom_field_def
				WHERE name in ('Budget Year', 'DISTRICT','CAPITAL GROUP')
		) cfd ON rl.entity_id = cfd.parent_id
		WHERE rl.plan_definition_id = 0
		and cl.name in ('Drilling (CEE)'),'Drilling (CDE)')
		GROUP BY e.object_id
) dd ON wi.entity_object_id = dd.entity_key*/
WHERE reserve_category_id = max_reserve_category_id;