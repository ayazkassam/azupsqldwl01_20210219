CREATE VIEW [stage].[v_valnav_dim_hierarchy_source] AS SELECT ve.object_id entity_key
	, ve.unique_id entity_name
	, cast(ve.cc_num  as varchar(50)) cost_centre
	, cc.cost_centre_name
	, cc.corp
	, cc.corp_name
	, cc.region
	, cc.region_name
	, cc.region_code
	, cc.district
	, cc.district_name
	, cc.district_code
	, cc.area
	, cc.area_name
	, cc.area_code
	, cc.facility
	, cc.facility_name
	, cc.facility_code
	, cc.cc_type
	, cc.cc_type_code
	, cc.budget_group
	, cast(cc.budget_year as varchar(100)) budget_year
	, cast(ve.op_nonop as varchar(10)) op_nonop
	, cc.origin
	, cc.province
	, cc.create_date
	, uwi.spud_date
	, uwi.rig_release_date
	, cast(convert(date,uwi.on_production_date) AS VARCHAR(50)) on_production_date
	--, CAST(coalesce(convert(date,ve.on_prod_date), convert(date,uwi.on_production_date)) AS VARCHAR(50)) on_production_date
	, cast(convert(date,uwi.last_production_date) as varchar(50)) last_production_date
	, cc.acquired_from
	, cc.current_reserves_property
	, cc.disposition_package
	, cc.disposition_type
	, cc.disposition_area
	, cc.disposition_facility
	, cc.disposed_flag
	, uwi.focus_area_flag
	, wi.primary_product
	, cc.cgu
	, wi.working_interest
	, uwi.year_end_reserves_property
	, cc.unit_cc_num
	, cc.unit_cc_name
	, uwi.survey_system_code
	, ve.unique_id uwi
	, cast(uwi.well_name as varchar(500)) uwi_desc
	, uwi.meridian
	, uwi.range
	, uwi.township
	, uwi.section
	, uwi.tax_pools
	, uwi.strat_unit_id
	, uwi.crstatus_desc
	, uwi.license_no
	, uwi.surf_location
	, uwi.tvd_depth
	, uwi.total_depth
	, uwi.zone_desc
	, uwi.deviation_flag
	, ve.formatted_id formatted_uwi
	, uwi.bottom_hole_latitude
	, uwi.bottom_hole_longitude
	, uwi.surface_latitude
	, uwi.surface_longitude
	, uwi.gas_shrinkage_factor
	, uwi.ngl_yield_factor
	, uwi.pvunit_completion_name
	, uwi.pvunit_name
	, uwi.pvunit_short_name
	, 'VALNAV' entity_source
	, 0 is_cc_dim
	, cc.cc_term_date
	, wi.chance_of_success
	, ve.budget_quarter
	, ve.capital_group
	, ve.capital_type
	, ve.de_risk
	, wi.depth_gci
	, ve.drill_days
	, ve.nra
	, convert(varchar(50),ve.reserve_realized_date) reserve_realized_date
	, wi.royalty_income_interest
	, ve.well_direction
	, ve.zone_play
	, 1 is_valnav
	, source_db
	, case source_db when 'BUDGET' then 1 when 'BASE DECLINE' then 2 when 'TYPE CURVES' then 3 else 0 end source_db_sort_key
	, cc.budget_year_group
	, cc.origin_group
	, cast(ve.budget_year as varchar(100)) valnav_budget_year
	, cc.working_interest_pct cc_num_working_interest_pct
	, coalesce(ent.lateral_length,ve.lateral_length) as lateral_length
	, SUBSTRING(CAST (ve.segment_start_date AS VARCHAR(50)),1,10) segment_start_date
	, cast(case when ent.completion_type = 0 then 'Sand' end as varchar(50)) completion_type
	, ent.total_proppant_placed
	, ent.c_star
	, ent.Production_Category
	, ent.Incentive_Type
	, ve.Meter_Station
	, ve.type_curve_kpi
	, ve.royalty_type
	, convert(varchar(50),convert(date,ve.first_prod_month)) first_prod_month
	, cast(coalesce(caw.group1,'No') as varchar(100)) group1
	, cast(coalesce(caw.group2,'No') as varchar(100)) group2
	, cast(coalesce(caw.group3,'No') as varchar(100)) group3
	, cast(coalesce(caw.group4,'No') as varchar(100)) group4
	, cast(coalesce(caw.group5,'No') as varchar(100)) group5
	, cast(coalesce(caw.group6,'No') as varchar(100)) group6
	, cast(coalesce(caw.group7,'No') as varchar(100)) group7
	, cast(coalesce(caw.group8,'No') as varchar(100)) group8
	, cast(coalesce(caw.group9,'No') as varchar(100)) group9
	, cast(coalesce(caw.group10,'No') as varchar(100)) group10
	, convert(varchar(50),ve.completion_month) completion_month
	, ve.Plant
	, ve.[Keyera Inlet] keyera_inlet
from (	
	/*pull entity attributes from Budget database*/
	select en.object_id
		, en.unique_id
		, en.formatted_id
		, en.sorting_id
		, ce.[COST CENTER CODE] cc_num
		, ce.[ZONE/PLAY] zone_play
		, ce.[WELL DIRECTION] well_direction
		, ce.[OP/NON-OP] op_nonop
		, ce.[CAPITAL TYPE] capital_type
		, ce.[BUDGET YEAR] budget_year
		, ce.[BUDGET QUARTER] budget_quarter
		, ce.[DE-RISK] de_risk
		, ce.[CAPITAL GROUP] capital_group
		, ce.[NRA] nra
		, ce.[DRILL DAYS] drill_days
		, ce.[RESERVES REALIZED DATE] reserve_realized_date
		, ce.[LATERAL LENGTH (M)] lateral_length
		, ce.[Meter Station] Meter_Station
		, ce.[Type Curve KPI] as type_curve_kpi
		, ce.[Royalty Type] as royalty_type
		, opd.on_prod_date
		, sd.segment_start_date
		, 'BUDGET' AS source_db
		, fpd.first_prod_month
		, ce.[Completion Month] completion_month
		, ce.Plant
		, ce.[Keyera Inlet]
	from stage_valnav.t_budget_entity en
	left outer join (
			select *
			from (
				select parent_id
					, ltrim(rtrim(name)) name
					, coalesce(string_value, cast(cast(date_value as date) as varchar(50)), cast(numeric_value as varchar(50))) Value
				from stage.t_stg_valnav_budget_ent_custom_field_def
				where ltrim(rtrim(name)) in ('COST CENTER CODE', 'ZONE/PLAY', 'WELL DIRECTION', 'OP/NON-OP', 'CAPITAL TYPE'
											, 'BUDGET YEAR', 'BUDGET QUARTER', 'DE-RISK', 'CAPITAL GROUP', 'NRA', 'DRILL DAYS'
											, 'RESERVES REALIZED DATE', 'LATERAL LENGTH (M)','Meter Station','Type Curve KPI','royalty type'
											, 'Completion Month','Plant','Keyera Inlet')
			) sq
			pivot ( max(Value) for name in  ([COST CENTER CODE], [ZONE/PLAY], [WELL DIRECTION], [OP/NON-OP], [CAPITAL TYPE]
											, [BUDGET YEAR], [BUDGET QUARTER], [DE-RISK], [CAPITAL GROUP], [NRA], [DRILL DAYS]
											, [RESERVES REALIZED DATE], [LATERAL LENGTH (M)],[Meter Station],[Type Curve KPI],[Royalty Type]
											, [Completion Month],[Plant], [Keyera Inlet])) p
	) ce on en.OBJECT_ID = ce.parent_id
	LEFT OUTER JOIN [stage].v_valnav_forecast_start_date_budget sd ON en.object_id = sd.object_id
	left outer join (
			SELECT e.object_id, MIN(rbp.min_step_date) AS on_prod_date
			FROM (
				SELECT result_id
					, MIN(step_date) AS min_step_date
					, SUM(wi_volume) as wi_volume
				FROM stage_valnav.t_budget_RESULTS_BTAX_PRODUCT bp
				join stage_valnav.t_budget_FISC_RESERVES_PRODUCT fsp on bp.PRODUCT_ID = fsp.object_id
				join stage.t_ctrl_valnav_products vp on fsp.long_name = vp.accounts
				group by RESULT_ID
			) rbp
			left outer join stage_valnav.t_budget_RESULTS_LOOKUP rl ON rbp.result_id = rl.result_id
			left outer join stage_valnav.t_budget_ENTITY e ON rl.entity_id = e.object_id
			inner join (
				SELECT variable_value FROM stage.t_ctrl_valnav_etl_variables
				WHERE variable_name = 'RESERVE_CATEGORY_ID'
			) vev ON rl.reserve_category_id = vev.variable_value
			INNER JOIN (
				SELECT fsp.plan_id, fs.OBJECT_ID
				FROM stage_valnav.t_budget_FISC_SCENARIO fs
				LEFT OUTER JOIN stage_valnav.t_budget_FISC_SCENARIO_PARAMS fsp ON (fs.object_id = fsp.parent_id)
				WHERE fs.name = '<Current Options>'
			) sn ON rl.scenario_id = sn.object_id
			WHERE rl.plan_definition_id = 0
			group by e.object_id
	) opd ON en.object_id = opd.object_id	
	left outer join (
		select PARENT_ID
			, FIRST_PROD_MONTH
		from stage_valnav.t_budget_ENT_DETAIL
		where FIRST_PROD_MONTH is not null
	) fpd on en.OBJECT_ID = fpd.PARENT_ID
	
	union all

	/*pull entity attributes from Base Decline database*/
	select en.object_id
		, en.unique_id
		, en.formatted_id
		, en.sorting_id
		, ce.[COST CENTER CODE] cc_num
		, ce.[ZONE/PLAY] zone_play
		, ce.[WELL DIRECTION] well_direction
		, ce.[OP/NON-OP] op_nonop
		, ce.[CAPITAL TYPE] capital_type
		, ce.[BUDGET YEAR] budget_year
		, ce.[BUDGET QUARTER] budget_quarter
		, ce.[DE-RISK] de_risk
		, ce.[CAPITAL GROUP] capital_group
		, ce.[NRA] nra
		, ce.[DRILL DAYS] drill_days
		, ce.[RESERVES REALIZED DATE] reserve_realized_date
		, ce.[LATERAL LENGTH (M)] lateral_length
		, ce.[Meter Station] Meter_Station
		, ce.[Type Curve KPI] as type_curve_kpi
		, ce.[Royalty Type] as royalty_type
		, null on_prod_date
		, null segment_start_date
		, 'BASE DECLINE' AS source_db
		, fpd.first_prod_month
		, null completion_month
		, ce.Plant
		, ce.[Keyera Inlet]
	from stage_valnav.t_basedecline_ENTITY en
	left outer join (
			select *
			from (
				select parent_id
					, ltrim(rtrim(name)) name
					, coalesce(string_value, cast(cast(date_value as date) as varchar(50)), cast(numeric_value as varchar(50))) Value
				from stage.t_stg_valnav_base_decline_ent_custom_field_def
				where ltrim(rtrim(name)) in ('COST CENTER CODE', 'ZONE/PLAY', 'WELL DIRECTION', 'OP/NON-OP', 'CAPITAL TYPE'
											, 'BUDGET YEAR', 'BUDGET QUARTER', 'DE-RISK', 'CAPITAL GROUP', 'NRA', 'DRILL DAYS'
											, 'RESERVES REALIZED DATE', 'LATERAL LENGTH (M)','Meter Station','Type Curve KPI','royalty type','Plant','Keyera Inlet')
			) sq
			pivot ( max(Value) for name in  ([COST CENTER CODE], [ZONE/PLAY], [WELL DIRECTION], [OP/NON-OP], [CAPITAL TYPE]
											, [BUDGET YEAR], [BUDGET QUARTER], [DE-RISK], [CAPITAL GROUP], [NRA], [DRILL DAYS]
											, [RESERVES REALIZED DATE], [LATERAL LENGTH (M)],[Meter Station],[Type Curve KPI],[Royalty Type]
											, [Plant], [Keyera Inlet])) p
	) ce on en.OBJECT_ID = ce.parent_id 
	left outer join (
		select PARENT_ID
			, FIRST_PROD_MONTH
		from stage_valnav.t_basedecline_ENT_DETAIL
		where FIRST_PROD_MONTH is not null
	) fpd on en.OBJECT_ID = fpd.PARENT_ID

	union all

	/*pull entity attributes from type curves database*/
	select en.object_id
		, en.unique_id
		, en.formatted_id
		, en.sorting_id
		, ce.[COST CENTER CODE] cc_num
		, ce.[ZONE/PLAY] zone_play
		, ce.[WELL DIRECTION] well_direction
		, ce.[OP/NON-OP] op_nonop
		, ce.[CAPITAL TYPE] capital_type
		, ce.[BUDGET YEAR] budget_year
		, ce.[BUDGET QUARTER] budget_quarter
		, ce.[DE-RISK] de_risk
		, ce.[CAPITAL GROUP] capital_group
		, ce.[NRA] nra
		, ce.[DRILL DAYS] drill_days
		, ce.[RESERVES REALIZED DATE] reserve_realized_date
		, ce.[LATERAL LENGTH (M)] lateral_length
		, ce.[Meter Station] as Meter_Station
		, ce.[Type Curve KPI] as type_curve_kpi
		, ce.[Royalty Type] as royalty_type
		, null on_prod_date
		, null segment_start_date
		, 'TYPE CURVES' AS source_db
		, fpd.first_prod_month
		, null completion_month
		, ce.Plant
		, ce.[Keyera Inlet]
	from stage_valnav.t_typecurves_ENTITY en
	left outer join (
			select *
			from (
				select parent_id
					, ltrim(rtrim(name)) name
					, coalesce(string_value, cast(cast(date_value as date) as varchar(50)), cast(numeric_value as varchar(50))) Value
				from stage.t_stg_valnav_typecurves_ent_custom_field_def
				where ltrim(rtrim(name)) in ('COST CENTER CODE', 'ZONE/PLAY', 'WELL DIRECTION', 'OP/NON-OP', 'CAPITAL TYPE'
											, 'BUDGET YEAR', 'BUDGET QUARTER', 'DE-RISK', 'CAPITAL GROUP', 'NRA', 'DRILL DAYS'
											, 'RESERVES REALIZED DATE', 'LATERAL LENGTH (M)','Meter Station','Type Curve KPI','royalty type'
											,'Plant','Keyera Inlet')
			) sq
			pivot ( max(Value) for name in  ([COST CENTER CODE], [ZONE/PLAY], [WELL DIRECTION], [OP/NON-OP], [CAPITAL TYPE]
											, [BUDGET YEAR], [BUDGET QUARTER], [DE-RISK], [CAPITAL GROUP], [NRA], [DRILL DAYS]
											, [RESERVES REALIZED DATE], [LATERAL LENGTH (M)],[Meter Station],[Type Curve KPI],[Royalty Type]
											, [Plant], [Keyera Inlet])) p
	) ce on en.OBJECT_ID = ce.parent_id
	left outer join (
		select PARENT_ID
			, FIRST_PROD_MONTH
		from stage_valnav.t_typecurves_ENT_DETAIL
		where FIRST_PROD_MONTH is not null
	) fpd on en.OBJECT_ID = fpd.PARENT_ID
) ve
LEFT OUTER JOIN [stage].t_cost_centre_hierarchy cc ON ve.cc_num = cc.cost_centre_id
LEFT OUTER JOIN [stage].v_dim_source_entity_uwi_hierarchy_attributes uwi ON ve.unique_id = uwi.uwi
LEFT OUTER JOIN (
		SELECT DISTINCT entity_object_id
		--uwi
			, coalesce (first_value(tract_working_interest) over (partition by entity_object_id order by effective_date DESC),1) * 100 working_interest
			, first_value(chance_of_success) over (partition by entity_object_id order by effective_date DESC) chance_of_success, 
			first_value(royalty_income_interest) over (partition by entity_object_id order by effective_date DESC) royalty_income_interest, 
			first_value(primary_product) over (partition by entity_object_id order by effective_date DESC) primary_product, 
			first_value(depth_gci) over (partition by entity_object_id order by effective_date DESC) depth_gci
		FROM (
				SELECT DISTINCT entity_object_id, uwi, effective_date, next_effective_date
					, chance_of_success
					, royalty_income_interest
					, primary_product
					, depth_gci
					, sum(tract_working_interest) over (partition by entity_object_id, uwi, effective_date, next_effective_date) tract_working_interest
				FROM stage.v_valnav_uwi_working_interest wi
				where effective_date <= getdate() and next_effective_date > getdate()
				
				UNION ALL
				-- typecurve wi/cos/ etc.
				SELECT DISTINCT entity_object_id, uwi, effective_date, next_effective_date
					, chance_of_success
					, royalty_income_interest
					, primary_product
					, depth_gci
					, sum(tract_working_interest) over (partition by entity_object_id, uwi, effective_date, next_effective_date) tract_working_interest
				FROM stage.[v_valnav_TypeCurves_uwi_working_interest] wi
				where effective_date <= getdate() and next_effective_date > getdate()
				
			)  uwi
) wi on ve.object_id = wi.entity_object_id
left outer join (
		select t.entity_object_id
			, round(t.TOTAL_PROPPANT_PLACED,1) TOTAL_PROPPANT_PLACED
			, t.LATERAL_LENGTH
			, t.COMPLETION_TYPE
			, t.c_star
			, c1.DisplayName as Production_Category
			, c2.DisplayName as Incentive_Type
		from (
			select distinct entity_object_id 
					, total_proppant_placed / .9842 total_proppant_placed
					, lateral_length * .3048 lateral_length 
					, completion_type
					--, first_value(CustomDataXML.value('(//OtherLength)[1]','float')/1000) over (partition by entity_object_id order by entity_object_id, leaseName) as c_star
					--, first_value(CustomDataXML.value('(//ProductionCategory)[1]','varchar(40)')) over (partition by entity_object_id order by entity_object_id, leaseName) as ProductionCategory
					--, first_value(CustomDataXML.value('(//Incentive)[1]','varchar(40)')) over (partition by entity_object_id order by entity_object_id, leaseName) as Incentive
					, first_value(sq.c_star_) over (partition by entity_object_id order by entity_object_id, leaseName) as c_star
					, first_value(sq.ProductionCategory_) over (partition by entity_object_id order by entity_object_id, leaseName) as ProductionCategory
					, first_value(sq.Incentive_) over (partition by entity_object_id order by entity_object_id, leaseName) as Incentive
				from (
					SELECT LTRIM(RTRIM(e.unique_id)) AS uwi
						, LTRIM(RTRIM(e.FORMATTED_ID)) AS formatted_uwi
						, e.object_id AS entity_object_id	
						, rs.TOTAL_PROPPANT_PLACED
						, rs.LATERAL_LENGTH
						, rs.COMPLETION_TYPE
						--, convert(xml,pi.CUSTOM_DATA) as CustomDataXML
						,pi.CUSTOM_DATA as CustomDataXML
						,pi.c_star_
						,pi.ProductionCategory_
						,pi.Incentive_
						, li.NAME as leaseName
					FROM stage_valnav.t_budget_ENTITY e
					LEFT OUTER JOIN (
							SELECT ep.object_id
								, ep.parent_id
								, TOTAL_PROPPANT_PLACED
								, LATERAL_LENGTH
								, COMPLETION_TYPE	
							FROM stage_valnav.t_budget_ENT_PLAN ep
							join stage_valnav.t_budget_ENT_SHARED_PLAN_DATA pd on ep.parent_id = pd.parent_id AND ep.plan_definition_id =  pd.plan_definition_id
							where ep.plan_definition_id = 0
					) rs ON e.object_id = rs.parent_id
					LEFT OUTER JOIN (
								SELECT erc.PARENT_ID, OBJECT_ID
								FROM stage_valnav.t_budget_ENT_RESERVES_CATEGORY erc
								WHERE erc.reserve_category_id IN ('1311','1')
					) rc ON rs.object_id = rc.parent_id
					LEFT OUTER JOIN (
								SELECT ci.COMPANY_ID
									, ci.PARENT_ID
									, ci.OBJECT_ID
									, c.name company_name
								FROM stage_valnav.t_budget_ENT_COMPANY_INTEREST ci
								, stage_valnav.t_budget_COMPANY c
								WHERE c.name in ('(default)','(default company)')
								AND c.object_id = ci.company_id
					) ci ON rc.object_id = ci.parent_id
					LEFT OUTER JOIN (
								SELECT name, PARENT_ID, OBJECT_ID
								FROM stage_valnav.t_budget_ENT_LEASE_INTEREST
								WHERE name LIKE 'Lease%'
					) li ON ci.object_id = li.parent_id
					LEFT OUTER JOIN (
								SELECT 
								  PARENT_ID, 
								  CUSTOM_DATA,
								  -- c_star
   					              CASE 
					                WHEN CHARINDEX('<OtherLength>', CUSTOM_DATA) <> 0 AND CHARINDEX('</OtherLength>',CUSTOM_DATA) <> 0 THEN
                                      CAST(SUBSTRING(CUSTOM_DATA,
                                      CHARINDEX('<OtherLength>', CUSTOM_DATA) + LEN('<OtherLength>'),
			                          CHARINDEX('</OtherLength>',CUSTOM_DATA) - CHARINDEX('<OtherLength>', CUSTOM_DATA) - LEN('<OtherLength>')) AS FLOAT) / 1000 
								  ELSE 
								    NULL
								  END AS c_star_,
								  -- ProductionCategory
								  CASE
									WHEN CHARINDEX('<ProductionCategory>', CUSTOM_DATA) <> 0 AND CHARINDEX('</ProductionCategory>',CUSTOM_DATA) <> 0 THEN
									  CAST(SUBSTRING(CUSTOM_DATA,
									  CHARINDEX('<ProductionCategory>', CUSTOM_DATA) + LEN('<ProductionCategory>'),
									  CHARINDEX('</ProductionCategory>',CUSTOM_DATA)- CHARINDEX('<ProductionCategory>', CUSTOM_DATA) - LEN('<ProductionCategory>')) AS VARCHAR(40)) 
									ELSE 
									  NULL 
									END as ProductionCategory_,
									-- Incentive
								  CASE
								    WHEN CHARINDEX('<Incentive>', CUSTOM_DATA) <> 0 AND CHARINDEX('</Incentive>',CUSTOM_DATA) <> 0 THEN 
									  CAST(SUBSTRING(CUSTOM_DATA,
									  CHARINDEX('<Incentive>', CUSTOM_DATA) + LEN('<Incentive>'),
									  CHARINDEX('</Incentive>',CUSTOM_DATA)- CHARINDEX('<Incentive>', CUSTOM_DATA) - LEN('<Incentive>')) AS VARCHAR(40)) 
									ELSE 
									  NULL 
									END as Incentive_
								FROM stage_valnav.t_budget_ENT_PRODUCT_INTEREST
								WHERE product = 'GEN'
								and CUSTOM_DATA is not null
					) pi ON li.object_id = pi.parent_id
					WHERE ci.company_name IS NOT null 
					AND li.name IS NOT NULL /*-- li.name is lease name*/
				) sq
		) t
		left outer join stage.t_ctrl_valnav_custom_data c1 on t.ProductionCategory = c1.CustomDataID and c1.CustomDataName = 'Production Category'
		left outer join stage.t_ctrl_valnav_custom_data c2 on t.Incentive = c2.CustomDataID and c2.CustomDataName = 'IncentiveType'
) ent on ve.object_id = ent.entity_object_id
--
left outer join 

    (SELECT DISTINCT code cc_num, 
			       -- first value used as safety guard in case of duplicates
	               first_value(group1) over (partition by code order by group1) group1,
				   first_value(group2) over (partition by code order by group2) group2,
				   first_value(group3) over (partition by code order by group3) group3,
				   first_value(group4) over (partition by code order by group4) group4,
				   first_value(group5) over (partition by code order by group5) group5,
				   first_value(group6) over (partition by code order by group5) group6,
				   first_value(group7) over (partition by code order by group5) group7,
				   first_value(group8) over (partition by code order by group5) group8,
				   first_value(group9) over (partition by code order by group5) group9,
				   first_value(group10) over (partition by code order by group5) group10
	FROM [stage_mds].[t_mds_bcd_cost_centre_custom_groupings] ) caw on ve.cc_num = caw.cc_num;