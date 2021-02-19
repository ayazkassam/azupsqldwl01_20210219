CREATE VIEW [stage].[v_opex_budget_source_facts] AS SELECT entity_key,
	account_key,
	CAST(accounting_month_key AS INT) AS accounting_month_key,
	CAST(activity_month_key AS INT) AS activity_month_key,  
	gross_net_key,
	vendor_key,
	scenario_key,
	spud_date_key,
	rig_release_date_key,
	on_production_date_key,
	cc_create_date_key,
	cc_term_date_key,
	cast(sum(cad) as float) cad,
	cast(sum(usd) as float)usd,
	cast(sum(metric_volume) as float) metric_volume,
	cast(sum(imperial_volume) as float) imperial_volume,
	cast(sum(boe_volume) as float) boe_volume,
	cast(sum(mcfe_volume) as float) mcfe_volume,
	cast(sum(cad_fixed) as float) cad_fixed,
	cast(sum(cad_variable) as float) cad_variable,
	cast(sum(cad_econ_fixed) as float) cad_econ_fixed,
	cast(sum(cad_econ_variable_gas) as float) cad_econ_variable_gas,
	cast(sum(cad_econ_variable_oil) as float) cad_econ_variable_oil,
	1 is_leaseops
FROM ( 
	/*-- opex budget $*/
	SELECT CASE WHEN substring(sd.budget_group,1,2) = 'CC' THEN replace(sd.budget_group,'CC_','')
			ELSE ISNULL(ISNULL(fac.entity_key,area.entity_key),-1) END entity_key,
		CASE WHEN acct.account_id IS NULL THEN '-1' WHEN account IS NULL THEN '-2' ELSE account END account_key, 
		ISNULL(replace(cast(period as varchar(20)),'-',''),'-1') accounting_month_key,
		ISNULL(replace(cast(period as varchar(20)),'-',''),'-1') activity_month_key,   
		CASE WHEN LTRIM(RTRIM(sd.grs_net_flag)) = 'NET' THEN 2 ELSE 1 END gross_net_key,
		-1 as vendor_key,
		ISNULL(scenario,'-1') scenario_key,
		ISNULL(sp_date.date_key,-2) spud_date_key,
		ISNULL(rig_date.date_key,-2) rig_release_date_key,
		ISNULL(prod_date.date_key,-2) on_production_date_key,
		ISNULL(cc_date.date_key,-2) cc_create_date_key,
		ISNULL(term_date.date_key,-2) cc_term_date_key,
		cad * ISNULL(acct.rev_multiplier,1)  AS cad,
		CAST (NULL AS NUMERIC) AS usd,
		CAST (NULL AS NUMERIC) AS metric_volume,
		CAST (NULL AS NUMERIC) AS imperial_volume,
		CAST (NULL AS NUMERIC) AS boe_volume,
		CAST (NULL AS NUMERIC) AS mcfe_volume,
		CASE WHEN fv.fixed_opex_percent IS NULL THEN NULL
			ELSE cad * (fv.fixed_opex_percent / 100) * ISNULL(acct.rev_multiplier,1) END AS cad_fixed,
		CASE WHEN fv.variable_opex_percent  IS NULL THEN NULL
			ELSE cad * (fv.variable_opex_percent  / 100) * ISNULL(acct.rev_multiplier,1) END AS cad_variable,
		CASE WHEN fv.econ_fixed_percent  IS NULL THEN NULL
			ELSE cad * (fv.econ_fixed_percent  / 100) * ISNULL(acct.rev_multiplier,1) END AS cad_econ_fixed,
		CASE WHEN fv.econ_variable_gas_percent  IS NULL THEN NULL
			ELSE cad * (fv.econ_variable_gas_percent  / 100) * ISNULL(acct.rev_multiplier,1) END AS cad_econ_variable_gas,
		CASE WHEN fv.econ_variable_oil_percent  IS NULL THEN NULL
			ELSE cad * (fv.econ_variable_oil_percent  / 100) * ISNULL(acct.rev_multiplier,1) END AS cad_econ_variable_oil
	FROM ( 
			/*--SD*/
			SELECT [DATA_SOURCE]
			, [SCENARIO]
			, bf.[BUDGET_GROUP]
			, [MAJOR_ACCT]
			, [MINOR_ACCT]
			, [MEASURE]
			, [GRS_NET_FLAG]
			, bf.[BUDGET_YEAR]
			, [JANUARY]
			, [FEBRUARY]
			, [MARCH]
			, [APRIL]
			, [MAY]
			, [JUNE]
			, [JULY]
			, [AUGUST]
			, [SEPTEMBER]
			, [OCTOBER]
			, [NOVEMBER]
			, [DECEMBER]
			, eomonth(CAST(bf.budget_year + mx.month_num + '01' AS DATE)) period
			, CONCAT(LTRIM(RTRIM(bf.major_acct)), '_', CASE WHEN LEN(MINOR_ACCT) = 2 THEN '0' ELSE '' END + LTRIM(RTRIM(minor_acct))) account
			, CASE mx.month_num 
					WHEN '01' THEN JANUARY
					WHEN '02' THEN FEBRUARY
					WHEN '03'	THEN MARCH
					WHEN '04'	THEN APRIL
					WHEN '05' THEN MAY
					WHEN '06' THEN JUNE
					WHEN '07' THEN JULY
					WHEN '08' THEN AUGUST
					WHEN '09' THEN SEPTEMBER
					WHEN '10' THEN OCTOBER
					WHEN '11' THEN NOVEMBER
					WHEN '12' THEN DECEMBER ELSE NULL END cad
		FROM (
				SELECT *
				FROM[stage].[t_stg_opex_budget_facts]
				WHERE (ISNULL(JANUARY,0)+ISNULL(FEBRUARY,0)+ISNULL(MARCH,0)+ISNULL(APRIL,0)+ISNULL(MAY,0)+ISNULL(JUNE,0)
					+ ISNULL(JULY,0)+ISNULL(AUGUST,0)+ISNULL(SEPTEMBER,0)+ISNULL(OCTOBER,0)+ISNULL(NOVEMBER,0)+ISNULL(DECEMBER,0)) <> 0
					/*exclude old scenarios*/
				AND UPPER (scenario) not IN ('2013 Original Budget Wedge','2034 Original Budget Wedge'
											,'Base_Decline','Base_Declines_Version_1','Original_Budget') 
		) bf
		/*-- Cartesian join/product to pivot monthly columns into rows...12 months rows generated to do that!*/
		, (		SELECT month_num
				from dbo.StrMonthList
		) mx
	) SD
	LEFT OUTER JOIN (
			SELECT DISTINCT FIRST_VALUE (entity_key) over (partition by facility ORDER BY entity_key) entity_key,
				facility
			FROM [data_mart].[t_dim_entity]  
			WHERE facility is not null
			AND is_cc_dim = 1
	) fac ON UPPER(sd.budget_group) = fac.facility
	LEFT OUTER JOIN (
			SELECT DISTINCT FIRST_VALUE (entity_key) over (partition by area ORDER BY entity_key) entity_key,
			area
			FROM [data_mart].[t_dim_entity]  
			WHERE area is not null
			AND is_cc_dim = 1
			AND UPPER(cc_type) like 'ACCRUAL%'
	) area ON UPPER(sd.budget_group) = area.area
	LEFT OUTER JOIN [data_mart].[t_dim_entity] ent ON isnull(fac.entity_key,area.entity_key) = ent.entity_key
	LEFT OUTER JOIN [stage].[t_ctrl_fixed_var_opex] fv ON sd.account = fv.qbyte_net_major_minor
	LEFT OUTER JOIN (
			SELECT ac.*
				, CASE WHEN ac.class_code_description = 'REVENUE' THEN 1 ELSE 1 END rev_multiplier
			FROM [data_mart].t_dim_account_hierarchy ac 
			WHERE Hierarchy_Path like 'Lease Operating Reporting %'
	) acct ON sd.account = acct.account_id
	LEFT OUTER JOIN [data_mart].[dim_date] sp_date ON ent.spud_date = sp_date.full_Date
	LEFT OUTER JOIN [data_mart].[dim_date] rig_date ON ent.rig_release_date = rig_date.full_Date
	LEFT OUTER JOIN [data_mart].[dim_date] prod_date ON ent.on_production_date = prod_date.full_Date
	LEFT OUTER JOIN [data_mart].[dim_date] cc_date ON ent.create_date = cc_date.full_Date
	LEFT OUTER JOIN [data_mart].[dim_date] term_date ON ent.cc_term_date = term_date.full_Date
/*		--2016-11-17 - comment out volumes load - legacy - no longer needed.
	--
	UNION ALL
	--
	/*-- Opex VOLUMES*/
	SELECT CASE WHEN substring(sd.budget_group,1,2) = 'CC' THEN replace(sd.budget_group,'CC_','') ELSE ISNULL(ent.entity_key,-1) END entity_key,
		CASE WHEN acct.account_id IS NULL THEN '-1' WHEN xref.major_minor IS NULL THEN '-2' ELSE xref.major_minor END account_key, 
		ISNULL(replace(cast(period as varchar(20)),'-',''),'-1') accounting_month_key,
		ISNULL(replace(cast(period as varchar(20)),'-',''),'-1') activity_month_key,   
		CASE WHEN LTRIM(RTRIM(sd.grs_net_flag)) = 'NET' THEN 2 ELSE 1 END gross_net_key,
		-1 as vendor_key,
		ISNULL(scenario,'-1') scenario_key,
		ISNULL(sp_date.date_key,-2) spud_date_key,
		ISNULL(rig_date.date_key,-2) rig_release_date_key,
		ISNULL(prod_date.date_key,-2) on_production_date_key,
		ISNULL(cc_date.date_key,-2) cc_create_date_key,
		ISNULL(term_date.date_key,-2) cc_term_date_key,
		CAST (NULL AS NUMERIC)  AS cad,
		CAST (NULL AS NUMERIC) AS usd,
		((imp_vol * DAY(EOMONTH(period))) / isnull(acct.si_to_imp_conv_factor,1)) * ISNULL(acct.rev_multiplier,1)  as metric_volume,
		(imp_vol * DAY(EOMONTH(period))) * ISNULL(acct.rev_multiplier,1) imperial_volume,
		((imp_vol * DAY(EOMONTH(period)))/ isnull(acct.si_to_imp_conv_factor,1)) * isnull(acct.boe_thermal,1) * ISNULL(acct.rev_multiplier,1) AS boe_volume,
		((imp_vol * DAY(EOMONTH(period)))*  isnull(acct.mcfe6_thermal,1)) * ISNULL(acct.rev_multiplier,1) AS mcfe_volume,
		CAST (NULL AS NUMERIC) cad_fixed,
		CAST (NULL AS NUMERIC) AS cad_variable,
		CAST (NULL AS NUMERIC) AS cad_econ_fixed,
		CAST (NULL AS NUMERIC) AS cad_econ_variable_gas,
		CAST (NULL AS NUMERIC) AS cad_econ_variable_oil
	FROM (
			/*--sd*/
			SELECT [DATA_SOURCE]
				, [SCENARIO]
				, bf.[BUDGET_GROUP]
				, [PRODUCT]
				, [GRS_NET_FLAG]
				, bf.[BUDGET_YEAR]
				, [JANUARY]
				, [FEBRUARY]
				, [MARCH]
				, [APRIL]
				, [MAY]
				, [JUNE]
				, [JULY]
				, [AUGUST]
				, [SEPTEMBER]
				, [OCTOBER]
				, [NOVEMBER]
				, [DECEMBER]
				, eomonth(CAST(bf.budget_year + mx.month_num + '01' AS DATE)) period
				, CASE mx.month_num 
						WHEN '01' THEN JANUARY
						WHEN '02' THEN FEBRUARY
						WHEN '03'	THEN MARCH
						WHEN '04'	THEN APRIL
						WHEN '05' THEN MAY
						WHEN '06' THEN JUNE
						WHEN '07' THEN JULY
						WHEN '08' THEN AUGUST
						WHEN '09' THEN SEPTEMBER
						WHEN '10' THEN OCTOBER
						WHEN '11' THEN NOVEMBER
						WHEN '12' THEN DECEMBER ELSE NULL END imp_vol
			FROM (
					SELECT *
					FROM [stage].[t_stg_opex_volumes_budget_dly_facts]
					WHERE (ISNULL(JANUARY,0)+ISNULL(FEBRUARY,0)+ISNULL(MARCH,0)+ISNULL(APRIL,0)+ISNULL(MAY,0)+ISNULL(JUNE,0)
						+ ISNULL(JULY,0)+ISNULL(AUGUST,0)+ISNULL(SEPTEMBER,0)+ISNULL(OCTOBER,0)+ISNULL(NOVEMBER,0)+ISNULL(DECEMBER,0)) <> 0
					AND UPPER (scenario) not IN ('2013 Original Budget Wedge','2034 Original Budget Wedge'
												,'Base_Decline','Base_Declines_Version_1','Original_Budget') 
			) bf
			/*-- Cartesian join/product to pivot monthly columns into rows...12 months rows generated to do that!*/
			, (		SELECT month_num
					from (
							select RIGHT(REPLICATE('0',2)+CAST(ROW_NUMBER() over (order by (select null)) AS VARCHAR(5)), 2) month_num,
								ROW_NUMBER() over (order by (select null)) rn
							from master.spt_values
					) s
					where rn <= 12
			) mx
	) SD
	LEFT OUTER JOIN [data_mart].[t_dim_entity] ent ON SUBSTRING(sd.budget_group,4,20) = ent.entity_key
	LEFT OUTER JOIN (
			/*-- Account xref*/
			SELECT *, CONCAT(target_major_acct,'_',target_minor_acct) major_minor
			FROM [stage].[t_ctrl_accounts_xref]
			WHERE source_app='MS-EXCEL'
	) xref ON sd.product = xref.source_column
	LEFT OUTER JOIN [stage].[t_ctrl_fixed_var_opex] fv ON xref.major_minor = fv.qbyte_net_major_minor
	LEFT OUTER JOIN (
			SELECT ac.*, CASE WHEN ac.class_code_description = 'REVENUE' THEN 1 ELSE 1 END rev_multiplier
			FROM [data_mart].t_dim_account_hierarchy ac 
	) acct ON xref.major_minor = acct.account_id
	LEFT OUTER JOIN [data_mart].[dim_date] sp_date ON ent.spud_date = sp_date.full_Date
	LEFT OUTER JOIN [data_mart].[dim_date] rig_date ON ent.rig_release_date = rig_date.full_Date
	LEFT OUTER JOIN [data_mart].[dim_date] prod_date ON ent.on_production_date = prod_date.full_Date
	LEFT OUTER JOIN [data_mart].[dim_date] cc_date ON ent.create_date = cc_date.full_Date
	LEFT OUTER JOIN [data_mart].[dim_date] term_date ON ent.cc_term_date = term_date.full_Date
*/
) SSD
GROUP BY entity_key,account_key,accounting_month_key,activity_month_key,gross_net_key,vendor_key,scenario_key
	,spud_date_key,rig_release_date_key,on_production_date_key,cc_create_date_key,cc_term_date_key;