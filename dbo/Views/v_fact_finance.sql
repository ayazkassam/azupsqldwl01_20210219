CREATE VIEW [dbo].[v_fact_finance] AS SELECT li_id
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
	, organization_key
	, afe_key
	, cdn_dollars
	, metric_volume
	, imperial_volume
	, boe_volume
	, mcfe_volume
	, working_interest
from (
	SELECT cast(li_id as int) li_id
		, cast(voucher_id as int) voucher_id
		, cast(entity_key as varchar(500)) as entity_key
		, cast(account_key as varchar(1000)) as account_key
		, cast(accounting_month_key as int) accounting_month_key
		, cast(activity_month_key as int) activity_month_key
		, cast(gross_net_key as int) gross_net_key
		, cast(vendor_key as int) vendor_key
		, cast(scenario_key as varchar(1000)) scenario_key
		, cast(organization_key as int) organization_key
		, cast(afe_key as varchar(10)) afe_key
		, qb_cad as cdn_dollars
		, qb_metric_volume as metric_volume
		, qb_imperial_volume as imperial_volume
		, qb_boe_volume as boe_volume
		, qb_mcfe_volume mcfe_volume
		, null working_interest
	FROM [data_mart].[t_fact_gl]
	WHERE is_finance = 1

	UNION ALL

	 /* -->>  POWERVISION DATA*/
	SELECT 
		cast(-1 as int) li_id
		, cast(-1 as int) voucher_id
		, cast(CASE WHEN pwv.cc_num IS NULL THEN '-1' WHEN cc.entity_key IS NULL  THEN '-2' ELSE cc.entity_key END as varchar(500)) entity_key
		, cast(pwv.net_acct as varchar(1000)) account_key
		, isnull(convert(int,convert(varchar(8),eomonth(pwv.actvy_per_date),112)),'-1') accounting_month_key
		, isnull(convert(int,convert(varchar(8),eomonth(pwv.actvy_per_date),112)),'-1') activity_month_key
		, cast(gn.gross_net_key as int) gross_net_key
		, cast(CASE WHEN pwv.ba_id IS NULL THEN -1 WHEN vnd.vendor_key IS NULL  THEN -2 ELSE vnd.vendor_key END as int) vendor_key
		, cast(ISNULL(substring(document,1,3),'-2') as varchar(1000)) scenario_key
		, cast(org_id as int) org_id
		, cast(CASE WHEN pwv.afe_num IS NULL THEN '-1'
				WHEN afe.afe_key IS NULL  THEN '-2'
				ELSE afe.afe_num
		   END as varchar(10)) afe_key
		, CASE gn.gross_net_key WHEN '1' THEN pwv.reporting_curr_amt  ELSE (pwv.reporting_curr_amt * ISNULL (ccw.working_interest, 100) / 100) END cdn_dollars
		, null [metric_volume]
		, null [imperial_volume]
		, null [boe_volume]
		, null [mcfe_volume]
		, null working_interest
	FROM [stage].v_fact_source_powervision pwv

	left outer JOIN [data_mart].[t_dim_authorization_for_expenditure] afe ON pwv.afe_num = afe.afe_num
	-- 
	LEFT OUTER JOIN
	 ( SELECT entity_key
			  FROM [data_mart].[t_dim_entity]
			  WHERE is_cc_dim=1
	  ) cc ON pwv.cc_num  = cc.entity_key

	JOIN (	SELECT DISTINCT account_id
			FROM [data_mart].t_dim_account_finance 
			WHERE gl_account IS NOT NULL
		) act ON pwv.net_acct = act.account_id

	LEFT OUTER JOIN [data_mart].t_dim_vendor vnd ON pwv.ba_id = vnd.vendor_key
	--
	CROSS JOIN (SELECT '1' gross_net_key UNION ALL SELECT '2') gn
	--
	LEFT OUTER JOIN [stage].t_cc_num_working_interest ccw
		ON pwv.cc_num = ccw.cc_num
		AND pwv.actvy_per_date >= ccw.effective_date
		AND pwv.actvy_per_date <  ccw.termination_date
	--
	UNION ALL
	--
	/*-- ALL Budgets*/
	--
	SELECT [li_id]
		, [voucher_id]
		, [entity_key]
		, [account_key]
		, [accounting_month_key]
		, [activity_month_key]
		, [gross_net_key]
		, [vendor_key]
		, [scenario_key]
		, [organization_key]
		, [afe_key]
		, [cdn_dollars]
		, [metric_volume]
		, [imperial_volume]
		, [boe_volume]
		, [mcfe_volume]
		, null working_interest
	FROM [data_mart].[t_fact_finance_budgets]
	
	union all

	SELECT -1 li_id
		, -1 voucher_id
		, entity_key
		, 'Cost Centre ' + Account account_key
		, accounting_period
		, activity_period
		, 1 gross_net_key
		, -1 vendor_key
		, scenario
		, -1 organization_key
		, '-1' afe_key
		, null cdn_dollars
		, null metric_volume
		, null imperial_volume
		, null boe_volume
		, null mcfe_volume
		, working_interest
	FROM stage.t_fact_source_qbyte_working_interest

	union all

	SELECT -1 li_id
		, -1 voucher_id
		, entity_key
		, 'Cost Centre ' + Account account_key
		, accounting_period
		, activity_period
		, 2 gross_net_key
		, -1 vendor_key
		, scenario
		, -1 organization_key
		, '-1' afe_key
		, null cdn_dollars
		, null metric_volume
		, null imperial_volume
		, null boe_volume
		, null mcfe_volume
		, working_interest
	FROM stage.t_fact_source_qbyte_working_interest
) sq
, (	
	SELECT max(case when variable_name = 'FINANCE_ACTIVITY_DATE_START' then int_value end) AS actv_start_date
		, convert(int,convert(varchar(4),max(case when variable_name = 'FINANCE_ACCOUNTING_DATE_START_YEAR' then int_value end)) +'0131') AS acct_start_date
		, max(case when variable_name = 'FINANCE_ACTIVITY_DATE_END' then int_value end) AS actv_end_date
		, convert(int,convert(varchar(4),max(case when variable_name = 'FINANCE_ACCOUNTING_DATE_END_YEAR' then int_value end)) +'1231') AS acct_end_date
	FROM [stage].t_ctrl_etl_variables
) sd;