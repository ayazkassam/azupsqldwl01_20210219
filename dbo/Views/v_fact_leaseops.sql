CREATE VIEW [dbo].[v_fact_leaseops]
AS select li_id
	, voucher_id
	, entity_key
	, account_key
	, CASE	WHEN accounting_month_key < sd.acct_start_date THEN sd.acct_start_date 
			WHEN accounting_month_key > sd.acct_end_date THEN 9999
		ELSE accounting_month_key END AS accounting_month_key
	, CASE	WHEN activity_month_key < sd.actv_start_date THEN sd.actv_start_date 
			WHEN activity_month_key > sd.actv_end_date THEN 9999
		ELSE activity_month_key END activity_month_key
	, gross_net_key
	, vendor_key
	, scenario_key
	, spud_date_key
	, rig_release_date_key
	, on_production_date_key
	, last_production_date_key
	, cc_create_date_key
	, cc_termination_date_key
	, cad
	, usd
	, metric_volume
	, imperial_volume
	, boe_volume
	, mcfe_volume
	, cad_fixed
	, cad_variable
	, cad_econ_fixed
	, cad_econ_variable_gas
	, cad_econ_variable_oil
	, working_interest
from (	
	select f.li_id
		, f.voucher_id
		, f.entity_key
		, f.account_key
		, f.accounting_month_key
		, f.activity_month_key
		, f.gross_net_key
		, f.vendor_key
		, f.scenario_key
		, isnull(cc.spud_date,-2) spud_date_key
		, isnull(cc.rig_release_date,-2) rig_release_date_key
		, isnull(cc.on_production_date,-2) on_production_date_key
		, isnull(cc.last_production_date,-2) last_production_date_key
		, isnull(cc.cc_create_date,-2) cc_create_date_key
		, isnull(cc.cc_termination_date,-2) cc_termination_date_key
		, f.cad
		, f.usd
		, f.metric_volume
		, f.imperial_volume
		, f.boe_volume
		, f.mcfe_volume
		, f.cad_fixed
		, f.cad_variable
		, f.cad_econ_fixed
		, f.cad_econ_variable_gas
		, f.cad_econ_variable_oil
		, null working_interest
	from [data_mart].[t_fact_gl] f
	LEFT OUTER JOIN ( 
			SELECT entity_key
				, case when convert(date,spud_date) < md.minDate then null else convert(int, convert(varchar(8),convert(datetime,spud_date),112)) end spud_date
				, case when convert(date,rig_release_date) < md.minDate then null else convert(int, convert(varchar(8),convert(datetime,rig_release_date),112)) end rig_release_date
				, case when convert(date,on_production_date) < md.minDate then null else convert(int, convert(varchar(8),convert(datetime,on_production_date),112)) end on_production_date
				, case when convert(date,last_production_date) < md.minDate then null else convert(int, convert(varchar(8),convert(datetime,last_production_date),112)) end last_production_date
				, case when isdate(create_date) = 0 or convert(date,create_date) < md.minDate then null else  convert(int, convert(varchar(8),convert(datetime,create_date),112)) end cc_create_date
				, case when isdate(cc_term_date) = 0 or convert(date,cc_term_date) < md.minDate then null else convert(int, convert(varchar(8),convert(datetime,cc_term_date),112)) end cc_termination_date
			FROM [data_mart].[t_dim_entity]
			, (	select min(full_date) minDate from data_mart.dim_date) md
			WHERE is_cc_dim=1
	) cc ON f.entity_key = cc.entity_key
	where f.gross_net_key <> 4
	and f.is_leaseops = 1

	UNION ALL
	--
	SELECT -1 li_id,
		-1 voucher_id,
		entity_key,
		account_key,
		accounting_month_key,
		activity_month_key,
		gross_net_key,
		vendor_key,
		scenario_key,
		spud_date_key,
		rig_release_date_key,
		on_production_date_key,
		last_production_date_key,
		cc_create_date_key,
		cc_termination_date_key,
		cad,
		usd,
		metric_volume,
		imperial_volume,
		boe_volume,
		mcfe_volume,
		cad_fixed,
		cad_variable,
		cad_econ_fixed,
		cad_econ_variable_gas,
		cad_econ_variable_oil, 
		null working_interest
	FROM [data_mart].[t_fact_opex_budgets] facts
	
	UNION ALL

	/*combine opex budgets into one scenario*/
	SELECT -1 li_id
		, -1 voucher_id
		, entity_key
		, account_key
		, accounting_month_key
		, activity_month_key
		, gross_net_key
		, vendor_key
		, 'OPEX Budget' scenario_key
		, spud_date_key
		, rig_release_date_key
		, on_production_date_key
		, last_production_date_key
		, cc_create_date_key
		, cc_termination_date_key
		, cad
		, usd
		, metric_volume
		, imperial_volume
		, boe_volume
		, mcfe_volume
		, cad_fixed
		, cad_variable
		, cad_econ_fixed
		, cad_econ_variable_gas
		, cad_econ_variable_oil
		, null working_interest
	FROM [data_mart].[t_fact_opex_budgets] facts
	where scenario_key in (select VARIABLE_VALUE from stage.t_ctrl_etl_variables where VARIABLE_NAME = 'OPEX_BUDGET_SCENARIOS')

	UNION ALL

	/*---- pull volumes from VALNAV BUDGET for opex budget */
	SELECT -1 li_id
		, -1 voucher_id
		, [entity_key]
		, [account_key]
		, [accounting_month_key]
		, [activity_month_key]
		, [gross_net_key]
		, [vendor_key]
		, 'OPEX Budget' [scenario_key]
		, [spud_date_key]
		, [rig_release_date_key]
		, [on_production_date_key]
		, [last_production_date_key]
		, [cc_create_date_key]
		, [cc_termination_date_key]
		, null cad
		, null usd
		, [metric_volume]
		, [imperial_volume]
		, [boe_volume]
		, [mcfe_volume]
		, null cad_fixed
		, null cad_variable
		, null cad_econ_fixed
		, null cad_econ_variable_gas
		, null cad_econ_variable_oil
		, null working_interest
	FROM [stage].[t_fact_source_leaseops_valnav_volumes] f	
	--where scenario_key in (select VARIABLE_VALUE from stage.dbo.t_ctrl_etl_variables where VARIABLE_NAME = 'OPEX_BUDGET_SCENARIOS')
	join (
		select left(VARIABLE_VALUE ,4) as Year
			, VARIABLE_VALUE
		from stage.t_ctrl_etl_variables where VARIABLE_NAME = 'OPEX_BUDGET_SCENARIOS'
	) v on f.scenario_key = v.VARIABLE_VALUE 
		and left(f.activity_month_key,4) = v.year

	UNION ALL
	--
	/*---- VALNAV BUDGET*/
	SELECT -1 li_id
		, -1 voucher_id
		, [entity_key]
		, [account_key]
		, [accounting_month_key]
		, [activity_month_key]
		, [gross_net_key]
		, [vendor_key]
		, [scenario_key]
		, [spud_date_key]
		, [rig_release_date_key]
		, [on_production_date_key]
		, [last_production_date_key]
		, [cc_create_date_key]
		, [cc_termination_date_key]
		, null cad
		, null usd
		, [metric_volume]
		, [imperial_volume]
		, [boe_volume]
		, [mcfe_volume]
		, null cad_fixed
		, null cad_variable
		, null cad_econ_fixed
		, null cad_econ_variable_gas
		, null cad_econ_variable_oil
		, null working_interest
	FROM [stage].[t_fact_source_leaseops_valnav_volumes]
	---
	UNION ALL
	--
	/*---- OPEX ACCRUAL*/
	SELECT -1 li_id
		, -1 voucher_id
		, fl.entity_key
		, [account_key]
		, [accounting_month_key]
		, [activity_month_key]
		, [gross_net_key]
		, [vendor_key]
		, [scenario_key]
		, isnull(cc.spud_date,-1) spud_date_key
		, isnull(cc.rig_release_date,-1) rig_release_date_key
		, isnull(cc.on_production_date,-1) on_production_date_key
		, isnull(cc.last_production_date,-1) last_production_date_key
		, isnull(cc.cc_create_date,-1) cc_create_date_key
		, isnull(cc.cc_termination_date,-1) cc_termination_date_key
		, cad
		, null usd
		, null [metric_volume]
		, null [imperial_volume]
		, null [boe_volume]
		, null [mcfe_volume]
		, null cad_fixed
		, null cad_variable
		, null cad_econ_fixed
		, null cad_econ_variable_gas
		, null cad_econ_variable_oil
		, null working_interest
	FROM [data_mart].t_fact_leaseops_opex_accruals fl
	INNER JOIN (
		SELECT variable_value leaseops_scenario
		FROM [stage].t_ctrl_etl_variables
		WHERE variable_name='OPEX_ACCRUAL_LEASEOPS_CUBE_SCENARIO'
	) sc ON fl.scenario_key = sc.leaseops_scenario
	LEFT OUTER JOIN (
			SELECT entity_key
				, case when convert(date,spud_date) < md.minDate then null else convert(int, convert(varchar(8),convert(datetime,spud_date),112)) end spud_date
				, case when convert(date,rig_release_date) < md.minDate then null else convert(int, convert(varchar(8),convert(datetime,rig_release_date),112)) end rig_release_date
				, case when convert(date,on_production_date) < md.minDate then null else convert(int, convert(varchar(8),convert(datetime,on_production_date),112)) end on_production_date
				, case when convert(date,last_production_date) < md.minDate then null else convert(int, convert(varchar(8),convert(datetime,last_production_date),112)) end last_production_date
				, case when isdate(create_date) = 0 or convert(date,create_date) < md.minDate then null else  convert(int, convert(varchar(8),convert(datetime,create_date),112)) end cc_create_date
				, case when isdate(cc_term_date) = 0 or convert(date,cc_term_date) < md.minDate then null else convert(int, convert(varchar(8),convert(datetime,cc_term_date),112)) end cc_termination_date
			FROM [data_mart].[t_dim_entity]
			, (	select min(full_date) minDate from data_mart.dim_date) md
			WHERE is_cc_dim=1
	) cc ON fl.entity_key = cc.entity_key
	--
	UNION ALL
	
	/*-->>  POWERVISION DATA*/
	SELECT -1 li_id
		, -1 voucher_id
		, CASE WHEN pwv.cc_num IS NULL THEN '-1' WHEN cc.entity_key IS NULL  THEN '-2' ELSE cc.entity_key END entity_key
		, pwv.net_acct account_key
		, isnull(convert(int,convert(varchar(8),eomonth(pwv.actvy_per_date),112)),'-1') accounting_month_key
		, isnull(convert(int,convert(varchar(8),eomonth(pwv.actvy_per_date),112)),'-1') activity_month_key
		, gn.gross_net_key
		, CASE WHEN pwv.ba_id IS NULL THEN '-1' WHEN vnd.vendor_key IS NULL  THEN '-2' ELSE vnd.vendor_key END vendor_key
		, ISNULL(substring(document,1,3),'-2') scenario_key
		, isnull(cc.spud_date,-2) spud_date_key
		, isnull(cc.rig_release_date,-2) rig_release_date_key
		, isnull(cc.on_production_date,-2) on_production_date_key
		, isnull(cc.last_production_date,-2) last_production_date_key
		, isnull(cc.cc_create_date,-2) cc_create_date_key
		, isnull(cc.cc_termination_date,-2) cc_termination_date_key
		, CASE gn.gross_net_key WHEN '1' THEN pwv.reporting_curr_amt ELSE (pwv.reporting_curr_amt * ISNULL (ccw.working_interest, 100) / 100) END cdn_dollars
		, null usd
		, null [metric_volume]
		, null [imperial_volume]
		, null [boe_volume]
		, null [mcfe_volume]
		, null cad_fixed
		, null cad_variable
		, null cad_econ_fixed
		, null cad_econ_variable_gas
		, null cad_econ_variable_oil
		, null working_interest
	FROM [stage].v_fact_source_powervision pwv
	LEFT OUTER JOIN ( 
			SELECT entity_key
				, case when convert(date,spud_date) < md.minDate then null else convert(int, convert(varchar(8),convert(datetime,spud_date),112)) end spud_date
				, case when convert(date,rig_release_date) < md.minDate then null else convert(int, convert(varchar(8),convert(datetime,rig_release_date),112)) end rig_release_date
				, case when convert(date,on_production_date) < md.minDate then null else convert(int, convert(varchar(8),convert(datetime,on_production_date),112)) end on_production_date
				, case when convert(date,last_production_date) < md.minDate then null else convert(int, convert(varchar(8),convert(datetime,last_production_date),112)) end last_production_date
				, case when isdate(create_date) = 0 or convert(date,create_date) < md.minDate then null else  convert(int, convert(varchar(8),convert(datetime,create_date),112)) end cc_create_date
				, case when isdate(cc_term_date) = 0 or convert(date,cc_term_date) < md.minDate then null else convert(int, convert(varchar(8),convert(datetime,cc_term_date),112)) end cc_termination_date
			FROM [data_mart].[t_dim_entity]
			, (	select min(full_date) minDate from data_mart.dim_date) md
			WHERE is_cc_dim=1
	) cc ON pwv.cc_num  = cc.entity_key
	LEFT OUTER JOIN [data_mart].t_dim_vendor vnd ON pwv.ba_id = vnd.vendor_key
	JOIN (
		SELECT DISTINCT account_id
		FROM [data_mart].t_dim_account_hierarchy 
		WHERE gl_account IS NOT NULL 
		and is_leaseops = 1
	) cap ON pwv.net_acct = cap.account_id
	JOIN (SELECT '1' gross_net_key UNION ALL SELECT '2') gn on 1=1
	LEFT OUTER JOIN [stage].t_cc_num_working_interest ccw
		ON pwv.cc_num = ccw.cc_num
		AND pwv.actvy_per_date >= ccw.effective_date
		AND pwv.actvy_per_date < ccw.termination_date

	union all

	select -1 li_id
		, -1 voucher_id
		, entity_key
		, Account as account_key
		, accounting_period
		, activity_period
		, 1 gross_net_key
		, -1 as vendor_key
		, Scenario
		, isnull(spud_date,-2) spud_date_key
		, isnull(rig_release_date,-2) rig_release_date_key
		, isnull(on_production_date,-2) on_production_date_key
		, isnull(last_production_date,-2) last_production_date_key
		, isnull(create_date,-2) cc_create_date_key
		, isnull(cc_term_date,-2) cc_termination_date_key
		, null cad
		, null usd
		, null [metric_volume]
		, null [imperial_volume]
		, null [boe_volume]
		, null [mcfe_volume]
		, null cad_fixed
		, null cad_variable
		, null cad_econ_fixed
		, null cad_econ_variable_gas
		, null cad_econ_variable_oil
		, working_interest
	from stage.t_fact_source_qbyte_working_interest f

	union all

	select -1 li_id
		, -1 voucher_id
		, entity_key
		, Account as account_key
		, accounting_period
		, activity_period
		, 2 gross_net_key
		, -1 as vendor_key
		, Scenario
		, isnull(spud_date,-2) spud_date_key
		, isnull(rig_release_date,-2) rig_release_date_key
		, isnull(on_production_date,-2) on_production_date_key
		, isnull(last_production_date,-2) last_production_date_key
		, isnull(create_date,-2) cc_create_date_key
		, isnull(cc_term_date,-2) cc_termination_date_key
		, null cad
		, null usd
		, null [metric_volume]
		, null [imperial_volume]
		, null [boe_volume]
		, null [mcfe_volume]
		, null cad_fixed
		, null cad_variable
		, null cad_econ_fixed
		, null cad_econ_variable_gas
		, null cad_econ_variable_oil
		, working_interest
	from stage.t_fact_source_qbyte_working_interest f
) sq
, (	SELECT max(case when variable_name = 'LEASEOPS_ACTIVITY_DATE_START' then int_value end) AS actv_start_date
		, convert(int,convert(varchar(4),max(case when variable_name = 'LEASEOPS_ACCOUNTING_DATE_START_YEAR' then int_value end)) +'0131') AS acct_start_date
		, max(case when variable_name = 'LEASEOPS_ACTIVITY_DATE_END' then int_value end) AS actv_end_date
		, convert(int,convert(varchar(4),max(case when variable_name = 'LEASEOPS_ACCOUNTING_DATE_END_YEAR' then int_value end)) +'1231') AS acct_end_date
	FROM [stage].t_ctrl_etl_variables
) sd;