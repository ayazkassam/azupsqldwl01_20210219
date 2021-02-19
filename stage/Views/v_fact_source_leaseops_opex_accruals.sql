CREATE VIEW [stage].[v_fact_source_leaseops_opex_accruals] AS SELECT entity_key,
	account_key,
	accounting_month_key,
	accounting_month_key activity_month_key,
	gross_net_key,
	vendor_key,
	scenario_key,
	sum(amount) cad
FROM (
	SELECT isnull(cc.cc_num,ev.default_entity) entity_key,
		acc.gl_account account_key,
		CASE WHEN ISDATE(cast (oa.accounting_month as datetime)) = 1 THEN cast(replace(eomonth(cast (oa.accounting_month as datetime)),'-','') as int) ELSE -1 END accounting_month_key,
		2 gross_net_key,
		-1 vendor_key,
		LTRIM(RTRIM(scenario)) scenario_key,
		amount
	FROM (
			SELECT variable_value default_entity
			FROM [stage].t_ctrl_etl_variables
			WHERE variable_name = 'OPEX_ACCRUAL_DEFAULT_COST_CENTRE'
	) ev
	, ( 
		SELECT *
		FROM [stage].t_stg_opex_accruals_xls
		WHERE (UPPER (accounting_month) NOT LIKE '%Q%'
		AND UPPER (accounting_month) NOT LIKE '%AVERAGE%'
		AND UPPER (accounting_month) NOT LIKE '%CALENDAR%')
		AND accounts <> 'Operating Expenses'
		AND UPPER (area) NOT LIKE '%DISTRICT:%'
	) oa
	LEFT OUTER JOIN (
			SELECT DISTINCT area_name,
				FIRST_VALUE (entity_key) OVER (PARTITION BY area_name ORDER BY create_date DESC) cc_num
			FROM [data_mart].t_dim_entity
			WHERE is_cc_dim=1
			AND UPPER(cc_type) like 'ACCRUAL%'
			AND cc_term_date IS NULL
	) cc ON oa.area = cc.area_name
	LEFT OUTER JOIN (
			SELECT h.gl_account
				, h.account_level_03
				, h.gl_account_description 
			FROM [data_mart].t_dim_account_hierarchy h
			join stage.t_qbyte_accounts a on h.gl_account = concat(a.MAJOR_ACCT,'_',a.MINOR_ACCT)
			WHERE h.gl_account_description like '%Accrual%'
			AND h.zero_level=1
			and a.TERM_DATE is null
	) acc ON oa.accounts = acc.account_level_03
	WHERE UPPER (LTRIM (RTRIM(oa.scenario))) IN ('WORKING BUDGET','ACCRUAL')
) sd
GROUP BY entity_key, account_key, accounting_month_key, gross_net_key, vendor_key, scenario_key;