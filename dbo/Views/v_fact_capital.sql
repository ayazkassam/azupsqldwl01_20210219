CREATE VIEW [dbo].[v_fact_capital]
AS select afe_key
	, entity_key
	, account_key
	, CASE	WHEN accounting_period_key < sd.acct_start_date THEN sd.acct_start_date 
			WHEN accounting_period_key > sd.acct_end_date THEN -1
		ELSE accounting_period_key END AS accounting_period_key

	, CASE	WHEN activity_period_key < sd.actv_start_date THEN sd.actv_start_date 
			WHEN activity_period_key > sd.actv_end_date THEN -1
		ELSE activity_period_key END AS activity_period_key

	, gross_net_key
	, vendor_key
	, scenario_key
	, op_nonop
	, cc_creation_date_key
	, afe_termination_date_key
	, on_production_date_key
	, spud_date_key
	, rig_release_date_key
	, cc_termination_date_key
	, budget_group
	, afe_type
	, cdn_dollars
	, us_dollars
	, working_interest
from (
	SELECT CAST(CASE WHEN facts.afe_number IS NULL THEN '-1'
					 WHEN afe.afe_key IS NULL THEN '-2'
				  ELSE afe.afe_num END AS VARCHAR(500)) as afe_key
		, CAST(facts.entity_id AS VARCHAR(500)) AS entity_key
		, COALESCE(facts.gl_account, '-1') AS account_key
		, facts.accounting_period_id AS accounting_period_key
		, facts.activity_period_id AS activity_period_key
		, gn.gross_net_key AS gross_net_key
		, CAST(CASE facts.vendor_ba_id WHEN 'UNKNOWN_VENDOR' THEN -1 ELSE COALESCE (facts.vendor_ba_id, -1) END AS INT) AS vendor_key
		, CAST(scenario AS VARCHAR(500)) AS scenario_key
		, ISNULL(cc.op_nonop, 'OP') AS op_nonop
		, ISNULL(cc.cc_create_date, -2) AS cc_creation_date_key
		, ISNULL(convert(int,convert(varchar(8),convert(date,afe.term_date),112)), -2) AS afe_termination_date_key
		, ISNULL(cc.on_production_date, -2) AS on_production_date_key
		, ISNULL(cc.spud_date, -2) AS spud_date_key
		, ISNULL(cc.rig_release_date, -2) AS rig_release_date_key
		, ISNULL(cc.cc_term_date,-2) cc_termination_date_key
		, ISNULL(cc.budget_group, 'Unknown Budget Group') AS budget_group
		, COALESCE( afe.afe_type_code,'-2') as afe_type
		, cdn_dollars
		, us_dollars
		, null working_interest
	FROM (	SELECT t.*
			FROM [data_mart].[t_fact_afe] t
			WHERE t.etl_status <> 'E'
			AND (t.cdn_dollars IS NOT NULL OR t.us_dollars IS NOT NULL)
	) facts
	LEFT OUTER JOIN [data_mart].[t_dim_authorization_for_expenditure] afe ON facts.afe_number = afe.afe_num
	LEFT OUTER JOIN (
			SELECT entity_key
				, cost_centre
				, uwi
				, CAST(op_nonop AS NVARCHAR(10)) AS op_nonop
				, CAST(budget_group AS NVARCHAR(200)) AS budget_group
				, CASE WHEN ISDATE(create_date) = 0 THEN NULL 
					ELSE convert(int,convert(varchar(8),convert(date,e.create_date),112)) END AS cc_create_date
				, case when convert(date,e.on_production_date)< md.minDate then null
					else convert(int,convert(varchar(8),convert(date,e.on_production_date),112)) end on_production_date
				, case when convert(date,e.rig_release_date)< md.minDate then null
					else convert(int,convert(varchar(8),convert(date,e.rig_release_date),112)) end rig_release_date
				, case when convert(date,e.spud_date)< md.minDate then null
					else convert(int,convert(varchar(8),convert(date,e.spud_date),112)) end spud_date
				, CASE WHEN ISDATE(cc_term_date) = 0 THEN NULL 
					ELSE convert(int,convert(varchar(8),convert(date,e.cc_term_date),112)) end as cc_term_date
			FROM [data_mart].[t_dim_entity] e
			, (	select min(full_date) minDate from [data_mart].[dim_date]) md
			WHERE is_cc_dim = 1
	) cc ON facts.cc_number = cc.cost_centre
	LEFT OUTER JOIN [data_mart].[t_dim_gross_net] gn ON facts.gross_net_indicator = gn.gross_net_id

	UNION ALL

	/*-- Valnav Capital Budget*/
	SELECT	afe_key,
		entity_key,
		account_id account_key,
		activity_date_key accounting_period_key,
		activity_date_key,
		gross_net_key,
		vendor_key,
		scenario_key,
		op_nonop,
		cc_create_date_key,
		afe_term_date_key,
		on_prod_date_key,
		spud_date_key,
		rig_release_date_key,
		cc_term_date_key,
		budget_group,
		afe_type,
		sum(cad) cad,
		null usd
		, null working_interest
	FROM (
		SELECT isnull(afe.afe_num,'-1') afe_key,
			isnull(ve.cost_centre,'-1') entity_key,
			isnull(acc.qbyte_major_minor,'-1') account_id,
			CASE WHEN vf.activity_date_key IS NULL or vf.activity_date_key = -1 THEN -1 
				ELSE CAST(CONCAT(SUBSTRING(CAST(vf.activity_date_key AS VARCHAR(10)),1,6)
					, DAY(EOMONTH(cast(cast(vf.activity_date_key as varchar(10)) as datetime)))) AS INT) END activity_date_key,
			CASE WHEN vf.gross_net_key = 'GRS' THEN 1 ELSE 2 END gross_net_key,
			'-1' vendor_key,
			sc.cube_child_member scenario_key,
			isnull(vc.op_nonop, 'Operated') op_nonop,
			CASE WHEN vc.create_date IS NULL THEN '-1' 
				ELSE convert(int, convert(varchar(8),convert(date,vc.create_date),112)) END cc_create_date_key,
			CASE WHEN afe.term_date IS NULL THEN '-1' 
				ELSE convert(int, convert(varchar(8),convert(date,afe.term_date),112)) END afe_term_date_key,
			CASE WHEN vc.on_production_date IS NULL THEN '-1' 
				ELSE convert(int, convert(varchar(8),convert(date,vc.on_production_date),112)) END on_prod_date_key,
			CASE WHEN vc.spud_date IS NULL THEN '-1' 
				ELSE convert(int, convert(varchar(8),convert(date,vc.spud_date),112)) END spud_date_key,
			CASE WHEN vc.rig_release_date IS NULL THEN '-1' 
				ELSE convert(int, convert(varchar(8),convert(date,vc.rig_release_date),112)) END rig_release_date_key,
			CASE WHEN vc.cc_term_date IS NULL THEN '-1'
				ELSE convert(int, convert(varchar(8),convert(date,vc.cc_term_date),112)) END cc_term_date_key,
			vc.budget_group,
			isnull(acc.afe_type, '-2') afe_type,
			vf.cad
		FROM (
			SELECT *
			FROM [data_mart].[t_fact_valnav_financial]
			WHERE reserve_category_key='1311'
		) vf
		INNER JOIN (
			SELECT *
			FROM [stage].[t_ctrl_valnav_etl_variables]
			WHERE variable_name = 'CAPITAL_DATA_SCENARIO'
			AND variable_value IS NOT NULL
		) sc ON vf.scenario_key = sc.variable_value
		INNER JOIN (
			SELECT *
			FROM [stage].[t_ctrl_special_accounts]
			WHERE is_valnav=1
			AND afe_type IS NOT NULL
		) acc ON vf.account_key = acc.account_id
		LEFT OUTER JOIN (
			/*-- join to entity using entity/guid to get cc*/
			SELECT *
			FROM [data_mart].[t_dim_entity]
			WHERE is_valnav=1
		) ve ON vf.entity_key = ve.entity_key
		LEFT OUTER JOIN (
			/*-- join to entity using cc so to get cc based attributes*/
			SELECT *
			FROM [data_mart].[t_dim_entity]
			WHERE is_cc_dim=1
		) vc ON ve.cost_centre = vc.entity_key
		LEFT OUTER JOIN (
			SELECT DISTINCT cost_centre,
				FIRST_VALUE(afe_num) OVER (PARTITION BY cost_centre ORDER BY cost_centre) afe_num,
				FIRST_VALUE(afe_key) OVER (PARTITION BY cost_centre ORDER BY cost_centre) afe_key,
				FIRST_VALUE(create_date) OVER (PARTITION BY cost_centre ORDER BY cost_centre) create_date,
				FIRST_VALUE(term_date) OVER (PARTITION BY cost_centre ORDER BY cost_centre) term_date
			FROM [data_mart].[t_dim_authorization_for_expenditure]
		) afe ON ve.cost_centre = afe.cost_centre
	) sd
	GROUP BY afe_key, entity_key, account_id, activity_date_key, gross_net_key, vendor_key, scenario_key, op_nonop,
		cc_create_date_key, afe_term_date_key, on_prod_date_key, spud_date_key, rig_release_date_key,
		cc_term_date_key, budget_group, afe_type

	UNION ALL

	/*-->>  POWERVISION DATA*/
	SELECT CASE WHEN pwv.afe_num IS NULL THEN '-1'
				WHEN afe.afe_key IS NULL  THEN '-2'
			ELSE afe.afe_num END afe_key
		, CASE WHEN pwv.cc_num IS NULL THEN '-1'
			 WHEN ent.entity_key IS NULL  THEN '-2'
			ELSE ent.entity_key END entity_key
		, pwv.net_acct gl_account
		, CASE WHEN pwv.actvy_per_date IS NULL THEN '-1' ELSE convert(int, convert(varchar(8),eomonth(convert(date,pwv.actvy_per_date)),112)) END accounting_period_key
		, CASE WHEN pwv.actvy_per_date IS NULL THEN '-1' ELSE convert(int, convert(varchar(8),eomonth(convert(date,pwv.actvy_per_date)),112)) END activity_period_key
		, gn.gross_net_key
		, CASE WHEN pwv.ba_id IS NULL THEN '-1'
			 WHEN vnd.vendor_key IS NULL  THEN '-2'
			ELSE vnd.vendor_key END vendor_key
		, ISNULL(substring(document,1,3),'-2') scenario_key
		, ISNULL(ent.op_nonop, 'Operated') as op_nonnop
		, ISNULL(ent.cc_create_date, -2) AS cc_creation_date_key
		, ISNULL(convert(int,convert(varchar(8),convert(date,afe.term_date),112)), -2) as afe_termination_date_key
		, ISNULL(ent.on_production_date, -2) AS on_production_date_key
		, ISNULL(ent.spud_date, -2) AS spud_date_key
		, ISNULL(ent.rig_release_date, -2) AS rig_release_date_key
		, ISNULL(ent.cc_term_date,-2) cc_termination_date_key
		, ISNULL(ent.budget_group, 'Unknown Budget Group') AS budget_group
		, COALESCE( afe.afe_type_code,'-2') as afe_type
		, CASE gn.gross_net_key WHEN '1' THEN pwv.reporting_curr_amt 
			ELSE (pwv.reporting_curr_amt * ISNULL (afe.net_estimate_pct, 100) / 100) END cdn_dollars
		, null us_dollars
		, null working_interest
	FROM [stage].[v_fact_source_powervision] pwv
	JOIN [data_mart].[t_dim_authorization_for_expenditure] afe ON pwv.afe_num = afe.afe_num
	LEFT OUTER JOIN (
			SELECT entity_key
				, op_nonop
				, budget_group
				, CASE WHEN ISDATE(create_date) = 0 THEN NULL 
					ELSE convert(int,convert(varchar(8),convert(date,e.create_date),112)) END AS cc_create_date
				, case when convert(date,e.on_production_date)< md.minDate then null
					else convert(int,convert(varchar(8),convert(date,e.on_production_date),112)) end on_production_date
				, case when convert(date,e.rig_release_date)< md.minDate then null
					else convert(int,convert(varchar(8),convert(date,e.rig_release_date),112)) end rig_release_date
				, case when convert(date,e.spud_date)< md.minDate then null
					else convert(int,convert(varchar(8),convert(date,e.spud_date),112)) end spud_date
				, CASE WHEN ISDATE(cc_term_date) = 0 THEN NULL 
					ELSE convert(int,convert(varchar(8),convert(date,e.cc_term_date),112)) end as cc_term_date
			FROM [data_mart].[t_dim_entity] e
			, (	select min(full_date) minDate from [data_mart].[dim_date]) md
			WHERE is_cc_dim = 1
	) ent ON pwv.cc_num  = ent.entity_key
	JOIN (	
		SELECT account_id
		FROM [stage].[t_ctrl_special_accounts]
		WHERE [is_capital] = 1

		union all

		select account_id
		from [data_mart].[t_dim_account_hierarchy]
		WHERE is_capital = 1
	) cap ON pwv.net_acct = cap.account_id
	LEFT OUTER JOIN [data_mart].[t_dim_vendor] vnd ON pwv.ba_id = vnd.vendor_key
	CROSS JOIN (SELECT '1' gross_net_key UNION ALL SELECT '2') gn

	union all

	select '-1' as afe_key
		, f.entity_key
		, 'Working Interest' as account_key
		, accounting_period
		, activity_period
		, 1 as gross_net_key
		, -1 as vendor_key
		, Scenario
		, op_nonop
		, isnull(create_date,-2) create_date
		, -2 as afe_term_date
		, isnull(on_production_date,-2) on_production_date
		, isnull(spud_date,-2) spud_date
		, isnull(rig_release_date,-2) rig_release_date
		, isnull(cc_term_date,-2) cc_term_date
		, budget_group
		, '-2' as afe_type
		, null as cdn_dollars
		, null as usd_dollars
		, working_interest
	from [stage].[t_fact_source_qbyte_working_interest] f

	union all

	select '-1' as afe_key
		, f.entity_key
		, 'Working Interest' as account_key
		, accounting_period
		, activity_period
		, 2 as gross_net_key
		, -1 as vendor_key
		, Scenario
		, op_nonop
		, isnull(create_date,-2) create_date
		, -2 as afe_term_date
		, isnull(on_production_date,-2) on_production_date
		, isnull(spud_date,-2) spud_date
		, isnull(rig_release_date,-2) rig_release_date
		, isnull(cc_term_date,-2) cc_term_date
		, budget_group
		, '-2' as afe_type
		, null as cdn_dollars
		, null as usd_dollars
		, working_interest
	from [stage].[t_fact_source_qbyte_working_interest] f
	
) sq
, (	SELECT max(case when variable_name = 'CAPITAL_ACTIVITY_DATE_START' then int_value end) AS actv_start_date
			, convert(int,convert(varchar(4),max(case when variable_name = 'CAPITAL_ACCOUNTING_DATE_START_YEAR' then int_value end)) +'0131') AS acct_start_date
			, max(case when variable_name = 'CAPITAL_ACTIVITY_DATE_END' then int_value end) AS actv_end_date
			, convert(int,convert(varchar(4),max(case when variable_name = 'CAPITAL_ACCOUNTING_DATE_END_YEAR' then int_value end)) +'1231') AS acct_end_date
		FROM [stage].[t_ctrl_etl_variables]
) sd;