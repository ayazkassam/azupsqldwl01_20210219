CREATE VIEW [stage].[v_fact_source_qbyte]
AS SELECT qb_li_vc.li_id,
	qb_li_vc.voucher_id,
	CAST (CASE WHEN qb_li_vc.cc_num IS NULL THEN '-1' ELSE qb_li_vc.cc_num END AS VARCHAR(100)) AS entity_key,
	CAST (CASE WHEN qb_li_vc.afe_num IS NULL THEN '-1' ELSE qb_li_vc.afe_num END AS VARCHAR(100) ) AS afe_key,
	
	CASE WHEN qb_li_vc.acct_per_date IS NULL THEN -1 
		ELSE cast(convert(varchar(8), qb_li_vc.acct_per_date, 112) as int) END AS accounting_month_key,
	
	CASE WHEN qb_li_vc.actvy_per_date IS NULL 
		THEN /*-- use acct per date*/
			CASE WHEN qb_li_vc.acct_per_date IS NULL THEN -1 
				ELSE cast(convert(varchar(8), qb_li_vc.acct_per_date, 112) as int) END
				ELSE cast(convert(varchar(8), qb_li_vc.actvy_per_date, 112) as int) END AS activity_month_key,

	coalesce(qb_li_vc.org_id,-1) AS organization_key,
	CASE WHEN grs_net IS NULL THEN CAST (-2 AS int) ELSE grs_net END AS gross_net_key, 
	CAST (CASE WHEN qb_li_vc.net_acct IS NULL THEN '-1' ELSE qb_li_vc.net_acct END AS VARCHAR(20)) AS account_key,
	
	ISNULL (acr_act_key, '-1')  AS scenario_key,

	ISNULL (inv.vendor_id, -1) AS vendor_key,
	(CASE	WHEN org.op_curr_code = 'CAD' AND qb_li_vc.li_amt IS NOT NULL THEN qb_li_vc.li_amt
			WHEN org.reporting_curr_code = 'CAD' AND qb_li_vc.org_rep_curr_amt IS NOT NULL THEN qb_li_vc.org_rep_curr_amt
		ELSE NULL END) * ISNULL (acct.rev_multiplier, 1) AS cad,
	
	(CASE	WHEN org.op_curr_code = 'CAD' AND qb_li_vc.li_amt IS NOT NULL THEN qb_li_vc.li_amt
			WHEN org.reporting_curr_code = 'CAD' AND qb_li_vc.org_rep_curr_amt IS NOT NULL THEN qb_li_vc.org_rep_curr_amt
		ELSE NULL END) AS qb_cad,

	(CASE	WHEN org.op_curr_code = 'USD' AND qb_li_vc.li_amt IS NOT NULL THEN qb_li_vc.li_amt 
			WHEN org.reporting_curr_code = 'USD' AND qb_li_vc.org_rep_curr_amt IS NOT NULL THEN qb_li_vc.org_rep_curr_amt
		ELSE NULL END) * ISNULL (acct.rev_multiplier, 1) AS usd,
	--
	qb_li_vc.li_vol AS qb_metric_volume,
	qb_li_vc.li_vol * ISNULL (acct.rev_multiplier, 1) AS metric_volume,
	--
	CASE WHEN qb_li_vc.li_vol IS NULL OR UPPER (acct.account_level_02) = 'OPERATING EXPENSES' THEN NULL 
		ELSE qb_li_vc.li_vol * ISNULL (acct.si_to_imp_conv_factor, 1) END AS qb_imperial_volume,
	(CASE WHEN qb_li_vc.li_vol IS NULL OR UPPER (acct.account_level_02) = 'OPERATING EXPENSES' THEN NULL 
		ELSE qb_li_vc.li_vol * ISNULL (acct.si_to_imp_conv_factor, 1) END) * ISNULL (acct.rev_multiplier, 1) AS imperial_volume,
	--
	CASE WHEN qb_li_vc.li_vol IS NULL OR UPPER (acct.account_level_02) = 'OPERATING EXPENSES' THEN NULL 
		ELSE qb_li_vc.li_vol * ISNULL (acct.boe_thermal, 1) END AS qb_boe_volume, 
	(CASE WHEN qb_li_vc.li_vol IS NULL OR UPPER (acct.account_level_02) = 'OPERATING EXPENSES' THEN NULL 
		ELSE qb_li_vc.li_vol * ISNULL (acct.boe_thermal, 1) END) * ISNULL (acct.rev_multiplier, 1) AS boe_volume, 
	--
	CASE WHEN qb_li_vc.li_vol IS NULL OR UPPER (acct.account_level_02) = 'OPERATING EXPENSES' THEN NULL 
		ELSE qb_li_vc.li_vol * ISNULL (acct.si_to_imp_conv_factor, 1) 
			*  (CASE WHEN acct.product_code = 'GAS' THEN ISNULL (acct.mcfe6_thermal, 1) ELSE ISNULL (acct.mcfe6_thermal, 6) END) END AS qb_mcfe_volume,
	(CASE WHEN qb_li_vc.li_vol IS NULL OR UPPER (acct.account_level_02) = 'OPERATING EXPENSES' THEN NULL  
		ELSE qb_li_vc.li_vol * ISNULL (acct.si_to_imp_conv_factor, 1) 
			*  (CASE WHEN acct.product_code = 'GAS' THEN ISNULL (acct.mcfe6_thermal, 1) 
				ELSE ISNULL (acct.mcfe6_thermal, 6) END) 
		END) * ISNULL (acct.rev_multiplier, 1) AS mcfe_volume,

	(CASE WHEN fv.fixed_opex_percent IS NULL THEN NULL 
		ELSE (CASE	WHEN org.op_curr_code = 'CAD' AND qb_li_vc.li_amt IS NOT NULL THEN qb_li_vc.li_amt
					WHEN org.reporting_curr_code = 'CAD' AND qb_li_vc.org_rep_curr_amt IS NOT NULL THEN  qb_li_vc.org_rep_curr_amt
				ELSE NULL END) * fv.fixed_opex_percent / 100 END) * ISNULL (acct.rev_multiplier, 1) AS cad_fixed,
	(CASE WHEN fv.variable_opex_percent IS NULL THEN NULL
		ELSE (CASE	WHEN org.op_curr_code = 'CAD' AND qb_li_vc.li_amt IS NOT NULL THEN qb_li_vc.li_amt
					WHEN org.reporting_curr_code = 'CAD' AND qb_li_vc.org_rep_curr_amt IS NOT NULL THEN  qb_li_vc.org_rep_curr_amt
				ELSE NULL END) * fv.variable_opex_percent / 100 END) * ISNULL (acct.rev_multiplier, 1) AS cad_variable,
	(CASE WHEN fv.econ_fixed_percent IS NULL THEN NULL
		ELSE (CASE	WHEN org.op_curr_code = 'CAD' AND qb_li_vc.li_amt IS NOT NULL THEN qb_li_vc.li_amt
					WHEN org.reporting_curr_code = 'CAD' AND qb_li_vc.org_rep_curr_amt IS NOT NULL THEN  qb_li_vc.org_rep_curr_amt
				ELSE NULL END) * fv.econ_fixed_percent / 100 END) * ISNULL (acct.rev_multiplier, 1) AS cad_econ_fixed,
	(CASE WHEN fv.econ_variable_gas_percent IS NULL THEN NULL 
		ELSE (CASE	WHEN org.op_curr_code = 'CAD' AND qb_li_vc.li_amt IS NOT NULL THEN qb_li_vc.li_amt
					WHEN org.reporting_curr_code = 'CAD' AND qb_li_vc.org_rep_curr_amt IS NOT NULL THEN qb_li_vc.org_rep_curr_amt
				ELSE NULL END) * fv.econ_variable_gas_percent / 100 END) * ISNULL (acct.rev_multiplier, 1) AS cad_econ_variable_gas,
	(CASE WHEN fv.econ_variable_oil_percent IS NULL THEN NULL
		ELSE (CASE	WHEN org.op_curr_code = 'CAD' AND qb_li_vc.li_amt IS NOT NULL THEN qb_li_vc.li_amt
					WHEN org.reporting_curr_code = 'CAD' AND qb_li_vc.org_rep_curr_amt IS NOT NULL THEN qb_li_vc.org_rep_curr_amt
				ELSE NULL END) * fv.econ_variable_oil_percent / 100 END) * ISNULL (acct.rev_multiplier, 1) AS cad_econ_variable_oil,                  
	case when voucher_stat_code = 'U' then 0 else acct.is_leaseops end as is_leaseops,
	CASE WHEN cap.account_id IS NULL or voucher_stat_code = 'U' THEN 0 ELSE 1 END AS is_capital,
	CASE WHEN vol_acct.account IS NULL or voucher_stat_code = 'U' THEN 0 ELSE 1 END AS is_volumes,
	0 AS is_valnav,
	CASE WHEN grs_net IN (1,2) THEN 1 ELSE 0 END as is_finance
FROM (
		/* Obtain all line item entries corresponding to posted vouchers */
		SELECT li.li_id,
			li.cc_num,
			li.voucher_id,
			li.major_acct,
			li.minor_acct,
			li.grs_net,
			li.net_acct,
			li.afe_num,
			coalesce(li.src_invc_id, li.result_invc_id) as src_invc_id,
			actvy_per_date,
			li.li_amt,
			li.reporting_curr_amt,
			li.org_rep_curr_amt,
			li.li_vol,
			CASE WHEN li.dest_org_id IS NULL THEN vouchers.org_id ELSE li.dest_org_id END AS org_id,
			CASE WHEN vouchers.voucher_type_code IS NULL THEN '-1' 
				ELSE case when vouchers.voucher_stat_code = 'U' 
					then 'U_' + vouchers.voucher_type_code else vouchers.voucher_type_code end END AS acr_act_key,
			vouchers.acct_per_date, 
			vouchers.voucher_num,
			vouchers.curr_code,
			vouchers.src_code,
			vouchers.voucher_stat_code,
			vouchers.create_date AS vouchers_create_date,
			vouchers.create_user AS vouchers_create_user,
			vouchers.ctrl_amt,
			vouchers.ctrl_vol,
			vouchers.gl_posting_date,
			vouchers.curr_conv_date,
			vouchers.src_module_id,
			vouchers.voucher_rem,
			vouchers.gl_post_user,
			vouchers.last_update_date AS vouchers_last_update_date,
			vouchers.last_update_user AS vouchers_last_update_user,
			vouchers.voucher_type_code,
			ISNULL (li.dest_org_id, vouchers.org_id) AS lv_dest_org_id
		FROM (	SELECT l.*,
					l.major_acct + '_' + l.minor_acct AS major_minor,
					CASE WHEN maj.net_major_acct IS NULL THEN l.major_acct + '_' + l.minor_acct ELSE maj.net_major_acct + '_' + l.minor_acct END net_acct,
					CAST (CASE maj.gross_or_net_code WHEN 'N' THEN 2 ELSE 1 END AS INT) AS grs_net,
					maj.class_code
				FROM [stage].[t_qbyte_line_items] l
				LEFT OUTER JOIN [stage].[t_qbyte_major_accounts] maj ON (l.major_acct = maj.major_acct)
				WHERE l.minor_acct <> 'CLR'
			) li
		, (		SELECT v.*
				FROM [stage].[t_qbyte_vouchers] v
				WHERE v.voucher_stat_code in ('P','U')
				AND v.voucher_type_code <> 'PLC'
				AND v.voucher_type_code <> 'YE'
			) vouchers
		WHERE li.voucher_id = vouchers.voucher_id
		--
		UNION ALL
		--
		/* Calculate true gross actuals for cost centre-based Net Line Item entries and point-in-time Ownership Agreements */
		SELECT li.li_id,
			li.cc_num,
			li.voucher_id,
			li.major_acct,
			li.minor_acct,
			3 AS grs_net,
			li.net_acct,
			li.afe_num,
			coalesce(li.src_invc_id, li.result_invc_id) as src_invc_id,
			actvy_per_date,
			CASE WHEN ccw.working_interest = 0 THEN li.li_amt ELSE li.li_amt * 100 / ISNULL (ccw.working_interest, 100) END AS li_amt,
			CASE WHEN ccw.working_interest = 0 THEN li.reporting_curr_amt ELSE li.reporting_curr_amt * 100 / ISNULL (ccw.working_interest, 100) END AS reporting_curr_amt,
			CASE WHEN ccw.working_interest = 0 THEN li.org_rep_curr_amt ELSE li.org_rep_curr_amt * 100 / ISNULL (ccw.working_interest, 100) END AS org_rep_curr_amt,
			CASE WHEN ccw.working_interest = 0 THEN li.li_vol ELSE li.li_vol * 100 / ISNULL (ccw.working_interest, 100) END AS li_vol, 
			CASE WHEN li.dest_org_id IS NULL THEN vouchers.org_id ELSE li.dest_org_id END AS org_id,
			CASE WHEN vouchers.voucher_type_code IS NULL THEN '-1' 
				ELSE case when vouchers.voucher_stat_code = 'U' 
					then 'U_' + vouchers.voucher_type_code else vouchers.voucher_type_code end END AS acr_act_key,
			vouchers.acct_per_date,
			vouchers.voucher_num,
			vouchers.curr_code,
			vouchers.src_code,
			vouchers.voucher_stat_code,
			vouchers.create_date AS vouchers_create_date,
			vouchers.create_user AS vouchers_create_user,
			vouchers.ctrl_amt,
			vouchers.ctrl_vol,
			vouchers.gl_posting_date,
			vouchers.curr_conv_date,
			vouchers.src_module_id,
			vouchers.voucher_rem,
			vouchers.gl_post_user,
			vouchers.last_update_date AS vouchers_last_update_date,
			vouchers.last_update_user AS vouchers_last_update_user,
			vouchers.voucher_type_code,
			ISNULL (li.dest_org_id, vouchers.org_id) AS lv_dest_org_id
		FROM (	SELECT l.*,
					l.major_acct + '_' + l.minor_acct AS major_minor,
					CASE WHEN maj.net_major_acct IS NULL  THEN l.major_acct + '_' + l.minor_acct ELSE maj.net_major_acct + '_' + l.minor_acct END net_acct,
					CASE maj.gross_or_net_code WHEN 'N' THEN 'NET' ELSE 'GRS' END AS grs_net_flag,
					maj.class_code
				FROM [stage].[t_qbyte_line_items] l
				LEFT OUTER JOIN [stage].[t_qbyte_major_accounts] maj ON l.major_acct = maj.major_acct
				WHERE l.minor_acct <> 'CLR'
				AND LTRIM (RTRIM (l.cc_num)) IS NOT NULL
			) li
		, (		SELECT v.*
				FROM [stage].[t_qbyte_vouchers] v
				WHERE v.voucher_stat_code in ('P','U')
				AND v.voucher_type_code <> 'PLC'
				AND v.voucher_type_code <> 'YE'
				AND v.voucher_type_code <> 'RVINT'
			) vouchers
		, [stage].t_cc_num_working_interest ccw
		WHERE li.grs_net_flag    = 'NET'
		AND li.voucher_id      = vouchers.voucher_id
		AND li.cc_num          = ccw.cc_num
		AND li.actvy_per_date >= ccw.effective_date
		AND li.actvy_per_date <  ccw.termination_date
		--
		UNION ALL
		--
		/* Calculate true gross actuals for externally loaded cost centre-based Net Line Item entries, based on gross up amounts and volumes */
		SELECT li.li_id,
			li.cc_num,
			li.voucher_id,
			li.major_acct,
			li.minor_acct,
			3 AS grs_net,
			li.net_acct,
			li.afe_num,
			coalesce(li.src_invc_id, li.result_invc_id) as src_invc_id,
			actvy_per_date,
			CASE WHEN li.li_amt IS NULL THEN NULL ELSE li.li_amt + ISNULL (li.gross_up_amt,0) END AS li_amt,
			CASE WHEN li.reporting_curr_amt IS NULL THEN NULL ELSE li.reporting_curr_amt + ISNULL (li.reporting_curr_gross_up_amt, 0) END AS reporting_curr_amt,
			CASE WHEN li.org_rep_curr_amt IS NULL THEN NULL ELSE li.org_rep_curr_amt + ISNULL (li.org_rep_curr_gross_up_amt, 0) END AS org_rep_curr_amt,
			CASE WHEN li.li_vol IS NULL THEN NULL ELSE li.li_vol + ISNULL (li.gross_up_vol, 0) END AS li_vol, 
			CASE WHEN li.dest_org_id IS NULL THEN vouchers.org_id ELSE li.dest_org_id END AS org_id,
			CASE WHEN vouchers.voucher_type_code IS NULL THEN '-1' 
				ELSE case when vouchers.voucher_stat_code = 'U' 
					then 'U_' + vouchers.voucher_type_code else vouchers.voucher_type_code end END AS acr_act_key,
			vouchers.acct_per_date,
			vouchers.voucher_num,
			vouchers.curr_code,
			vouchers.src_code,
			vouchers.voucher_stat_code,
			vouchers.create_date AS vouchers_create_date,
			vouchers.create_user AS vouchers_create_user,
			vouchers.ctrl_amt,
			vouchers.ctrl_vol,
			vouchers.gl_posting_date,
			vouchers.curr_conv_date,
			vouchers.src_module_id,
			vouchers.voucher_rem,
			vouchers.gl_post_user,
			vouchers.last_update_date AS vouchers_last_update_date,
			vouchers.last_update_user AS vouchers_last_update_user,
			vouchers.voucher_type_code,
			ISNULL (li.dest_org_id, vouchers.org_id) AS lv_dest_org_id
		FROM (	SELECT l.*,
					l.major_acct + '_' + l.minor_acct AS major_minor,
					CASE WHEN maj.net_major_acct IS NULL THEN l.major_acct + '_' + l.minor_acct ELSE maj.net_major_acct + '_' + l.minor_acct END AS net_acct,
					CASE maj.gross_or_net_code WHEN 'N' THEN 'NET' ELSE 'GRS' END AS grs_net_flag,
					maj.class_code
				FROM [stage].[t_qbyte_line_items] l
				LEFT OUTER JOIN [stage].[t_qbyte_major_accounts] maj ON l.major_acct = maj.major_acct
				WHERE l.minor_acct <> 'CLR'
				AND LTRIM (RTRIM (l.cc_num)) IS NOT NULL
			) li
		, (		SELECT v.*
				FROM [stage].[t_qbyte_vouchers] v
				WHERE v.voucher_stat_code in ('P','U')
				AND v.voucher_type_code = 'RVINT'
			) vouchers
		WHERE li.grs_net_flag = 'GRS'
		AND li.voucher_id   = vouchers.voucher_id
		--
		UNION ALL
		--
		/* Obtain grossed up accruals for Operated AFE's */
		SELECT li.li_id,
			li.cc_num,
			li.voucher_id,
			li.major_acct,
			li.minor_acct,
			4 AS grs_net, -- 4 IS FOR CALC_GRS
			li.net_acct,
			li.afe_num,
			coalesce(li.src_invc_id, li.result_invc_id) as src_invc_id,
			actvy_per_date,
			CASE WHEN afe_op.afe_num IS NOT NULL 
					AND vouchers.voucher_type_code IN ('ACCR', 'ACCRU', 'STACCR') 
					AND li.grs_net_flag = 'NET' 
					AND ISNULL (afe_op.net_estimate_pct, 0) <> 0
				THEN li.li_amt * 100 / ISNULL(afe_op.net_estimate_pct, 100) /* Gross up only posted accruals for operated AFE's */
				ELSE li.li_amt END AS li_amt,
			CASE WHEN afe_op.afe_num IS NOT NULL
					AND vouchers.voucher_type_code IN ('ACCR','ACCRU','STACCR')
					AND li.grs_net_flag = 'NET'
					AND ISNULL (afe_op.net_estimate_pct, 0) <> 0
				THEN li.reporting_curr_amt  * 100  / ISNULL(afe_op.net_estimate_pct, 100) 
				ELSE li.reporting_curr_amt END AS reporting_curr_amt,
			CASE WHEN afe_op.afe_num IS NOT NULL
					AND vouchers.voucher_type_code IN ('ACCR','ACCRU','STACCR')
					AND li.grs_net_flag = 'NET'
					AND ISNULL(afe_op.net_estimate_pct, 0) <> 0
				THEN li.org_rep_curr_amt * 100 / ISNULL (afe_op.net_estimate_pct, 100)
				ELSE li.org_rep_curr_amt
				END AS org_rep_curr_amt,
			CASE WHEN afe_op.afe_num IS NOT NULL
					AND vouchers.voucher_type_code IN ('ACCR','ACCRU','STACCR')
					AND li.grs_net_flag = 'NET'
					AND ISNULL (afe_op.net_estimate_pct, 0) <> 0
				THEN li.li_vol * 100 / ISNULL (afe_op.net_estimate_pct, 100)
				ELSE li.li_vol
				END AS li_vol,
			CASE WHEN li.dest_org_id IS NULL THEN vouchers.org_id ELSE li.dest_org_id END AS org_id,
			CASE WHEN vouchers.voucher_type_code IS NULL THEN '-1' 
				ELSE case when vouchers.voucher_stat_code = 'U' 
					then 'U_' + vouchers.voucher_type_code else vouchers.voucher_type_code end END AS acr_act_key,
			vouchers.acct_per_date,
			vouchers.voucher_num,
			vouchers.curr_code,
			vouchers.src_code,
			vouchers.voucher_stat_code,
			vouchers.create_date AS vouchers_create_date,
			vouchers.create_user AS vouchers_create_user,
			vouchers.ctrl_amt,
			vouchers.ctrl_vol,
			vouchers.gl_posting_date,
			vouchers.curr_conv_date,
			vouchers.src_module_id,
			vouchers.voucher_rem,
			vouchers.gl_post_user,
			vouchers.last_update_date AS vouchers_last_update_date,
			vouchers.last_update_user AS vouchers_last_update_user,
			vouchers.voucher_type_code,
			ISNULL (li.dest_org_id, vouchers.org_id) AS lv_dest_org_id
		FROM (	SELECT l.*,
					l.major_acct + '_' + l.minor_acct AS major_minor,
					CASE WHEN maj.net_major_acct IS NULL  THEN l.major_acct + '_' + l.minor_acct ELSE maj.net_major_acct + '_' + l.minor_acct END net_acct,
					CASE maj.gross_or_net_code WHEN 'N' THEN 'NET' ELSE 'CALC_GRS' END AS grs_net_flag,
					maj.class_code 
				FROM [stage].[t_qbyte_line_items] l
				LEFT OUTER JOIN [stage].[t_qbyte_major_accounts] maj ON l.major_acct = maj.major_acct
				WHERE l.minor_acct <> 'CLR'
			) li
		, (		SELECT v.*
				FROM [stage].[t_qbyte_vouchers] v
				WHERE v.voucher_stat_code in ('P','U')
				AND v.voucher_type_code <> 'PLC'
				AND v.voucher_type_code <> 'YE'
			) vouchers
		, (		SELECT ae.afe_num,
					op.client_id,
					op.op_nonop,
					op.ref_org_id,
					ae.net_estimate_pct
				FROM [stage].t_qbyte_authorizations_for_expenditure ae
				INNER JOIN (	SELECT o.afe_num,
									o.client_id AS client_id,
									CASE WHEN LTRIM(RTRIM(ba.ref_org_id)) IS NULL THEN 'NOP' ELSE 'OP' END op_nonop,
									LTRIM (RTRIM(ba.ref_org_id)) AS ref_org_id
								FROM (	SELECT DISTINCT FIRST_VALUE (client_id) OVER (PARTITION BY afe_num
													ORDER BY last_update_date DESC,last_update_user,create_date) AS client_id,
											afe_num
										FROM [stage].t_qbyte_operator_afes
									) o
								LEFT OUTER JOIN [stage].t_qbyte_business_associates ba ON o.client_id = ba.id
					) op ON ae.afe_num = op.afe_num
				WHERE op.op_nonop = 'OP' /* This filter ensures that only Operated AFE's are selected */
			) afe_op
		WHERE li.voucher_id      = vouchers.voucher_id
		AND  li.afe_num         = afe_op.afe_num
		AND ((vouchers.voucher_type_code IN ('ACCR','ACCRU','STACCR') AND li.grs_net_flag    = 'NET')
			OR (vouchers.voucher_type_code NOT IN ('ACCR','ACCRU','STACCR') AND li.grs_net_flag = 'CALC_GRS'))
		--
		UNION ALL
		--
		/* Obtain grossed up actuals for Non-operated AFE's */
		SELECT li.li_id,
			li.cc_num,
			li.voucher_id,
			li.major_acct,
			li.minor_acct,
			4 AS grs_net, -- 4 IS FOR CALC_GRS
			li.net_acct,
			li.afe_num,
			coalesce(li.src_invc_id, li.result_invc_id) as src_invc_id,
			actvy_per_date,
			CASE afe_nop.net_estimate_pct WHEN 0 THEN li.li_amt ELSE li.li_amt / ISNULL (afe_nop.net_estimate_pct, 1) END AS li_amt,
			CASE afe_nop.net_estimate_pct WHEN 0 THEN li.reporting_curr_amt ELSE li.reporting_curr_amt / ISNULL (afe_nop.net_estimate_pct, 1) END AS reporting_curr_amt,
			CASE afe_nop.net_estimate_pct WHEN 0 THEN li.org_rep_curr_amt ELSE li.org_rep_curr_amt  / ISNULL (afe_nop.net_estimate_pct, 1) END AS org_rep_curr_amt,
			CASE afe_nop.net_estimate_pct WHEN 0 THEN li.li_vol ELSE li.li_vol / ISNULL (afe_nop.net_estimate_pct, 1) END AS li_vol, 
			CASE WHEN li.dest_org_id IS NULL THEN vouchers.org_id ELSE li.dest_org_id END AS org_id,
			CASE WHEN vouchers.voucher_type_code IS NULL THEN '-1' 
				ELSE case when vouchers.voucher_stat_code = 'U' 
					then 'U_' + vouchers.voucher_type_code else vouchers.voucher_type_code end END AS acr_act_key,
			vouchers.acct_per_date,
			vouchers.voucher_num,
			vouchers.curr_code,
			vouchers.src_code,
			vouchers.voucher_stat_code,
			vouchers.create_date AS vouchers_create_date,
			vouchers.create_user AS vouchers_create_user,
			vouchers.ctrl_amt,
			vouchers.ctrl_vol,
			vouchers.gl_posting_date,
			vouchers.curr_conv_date,
			vouchers.src_module_id,
			vouchers.voucher_rem,
			vouchers.gl_post_user,
			vouchers.last_update_date AS vouchers_last_update_date,
			vouchers.last_update_user AS vouchers_last_update_user,
			vouchers.voucher_type_code,
			ISNULL (li.dest_org_id, vouchers.org_id) AS lv_dest_org_id
		FROM (	SELECT l.*,
					l.major_acct + '_' + l.minor_acct AS major_minor,
					CASE WHEN maj.net_major_acct IS NULL THEN l.major_acct + '_' + l.minor_acct ELSE maj.net_major_acct + '_' + l.minor_acct END net_acct,
					CASE maj.gross_or_net_code WHEN 'N' THEN 'NET' ELSE 'CALC_GRS' END AS grs_net_flag,
					maj.class_code 
				FROM [stage].[t_qbyte_line_items] l
				LEFT OUTER JOIN [stage].[t_qbyte_major_accounts] maj ON l.major_acct = maj.major_acct
				WHERE l.minor_acct <> 'CLR'
			) li
		, (		SELECT v.*
				FROM [stage].[t_qbyte_vouchers] v
				WHERE v.voucher_stat_code in ('P','U')
				AND v.voucher_type_code <> 'PLC'
				AND v.voucher_type_code <> 'YE'
			) vouchers
		, (		SELECT ae.afe_num,
					op.client_id,
					op.op_nonop,
					op.ref_org_id,
					CASE WHEN net_estimate_pct > 1 THEN net_estimate_pct / 100 ELSE net_estimate_pct END  AS net_estimate_pct
				FROM [stage].t_qbyte_authorizations_for_expenditure ae
				INNER JOIN (	SELECT o.afe_num,
									o.client_id AS client_id,
									CASE WHEN LTRIM(RTRIM(ba.ref_org_id)) IS NULL THEN 'NOP' ELSE 'OP' END op_nonop,
									LTRIM (RTRIM(ba.ref_org_id)) AS ref_org_id
								FROM (	SELECT DISTINCT FIRST_VALUE (client_id) OVER (PARTITION BY afe_num
												ORDER BY last_update_date DESC,last_update_user,create_date) AS client_id,
											afe_num
										FROM [stage].t_qbyte_operator_afes
									) o
								LEFT OUTER JOIN [stage].t_qbyte_business_associates ba ON o.client_id = ba.id
					) op ON ae.afe_num = op.afe_num
				WHERE op.op_nonop = 'NOP' /* This filter ensures that only Operated AFE's are selected */
			) afe_nop
		WHERE li.voucher_id      = vouchers.voucher_id
		AND  li.afe_num         = afe_nop.afe_num
		AND  li.grs_net_flag    = 'NET'
		--
		UNION ALL
		--
		/* Obtain grossed up actuals for AFE's with only Net Line Item entries */
	
		SELECT li.li_id,
			li.cc_num,
			li.voucher_id,
			li.major_acct,
			li.minor_acct,
			4 grs_net,
			li.net_acct,
			li.afe_num,
			coalesce(li.src_invc_id, li.result_invc_id) as src_invc_id,
			actvy_per_date,
			li.li_amt,
			li.reporting_curr_amt,
			li.org_rep_curr_amt,
			li.li_vol,
			CASE WHEN li.dest_org_id IS NULL THEN vouchers.org_id ELSE li.dest_org_id END AS org_id,
			CASE WHEN vouchers.voucher_type_code IS NULL THEN '-1' 
				ELSE case when vouchers.voucher_stat_code = 'U' 
					then 'U_' + vouchers.voucher_type_code else vouchers.voucher_type_code end END AS acr_act_key,
			vouchers.acct_per_date,
			vouchers.voucher_num,
			vouchers.curr_code,
			vouchers.src_code,
			vouchers.voucher_stat_code,
			vouchers.create_date AS vouchers_create_date,
			vouchers.create_user AS vouchers_create_user,
			vouchers.ctrl_amt,
			vouchers.ctrl_vol,
			vouchers.gl_posting_date,
			vouchers.curr_conv_date,
			vouchers.src_module_id,
			vouchers.voucher_rem,
			vouchers.gl_post_user,
			vouchers.last_update_date AS vouchers_last_update_date,
			vouchers.last_update_user AS vouchers_last_update_user,
			vouchers.voucher_type_code,
			ISNULL (li.dest_org_id, vouchers.org_id) AS lv_dest_org_id
		FROM (	SELECT l.*,
					l.major_acct + '_' + l.minor_acct AS major_minor,
					CASE WHEN maj.net_major_acct IS NULL  THEN l.major_acct + '_' + l.minor_acct ELSE maj.net_major_acct + '_' + l.minor_acct END net_acct,
					CAST (CASE maj.gross_or_net_code WHEN 'N' THEN 2 ELSE 1 END AS INT) AS grs_net,  
					maj.class_code
				FROM [stage].[t_qbyte_line_items] l
				LEFT OUTER JOIN [stage].[t_qbyte_major_accounts] maj ON (l.major_acct = maj.major_acct)
				WHERE l.minor_acct <> 'CLR' 
			) li
		, (		SELECT v.*
				FROM [stage].[t_qbyte_vouchers] v
				WHERE v.voucher_stat_code in ('P','U')
				AND NOT v.voucher_type_code IN ('PLC','YE','ACCR','ACCRU','STACCR') /* Purposely exclude all accrual entries to prevent overlap with functionality that grosses up accruals for operated AFE's */
			) vouchers
	WHERE li.voucher_id = vouchers.voucher_id         
	AND li.afe_num IN (	SELECT DISTINCT ae.afe_num
							FROM (	SELECT DISTINCT l.afe_num,
										FIRST_VALUE (CASE maj.gross_or_net_code WHEN 'N' THEN 'NET' ELSE 'GRS' END)
											OVER (PARTITION BY l.afe_num ORDER BY ISNULL(maj.gross_or_net_code,'A')) AS first_indicator_code
									FROM [stage].t_qbyte_major_accounts maj /* Source of gross/net flag and class code information */
							, (		SELECT f.*
									FROM [stage].[t_qbyte_line_items] f
									WHERE     f.minor_acct <> 'CLR'
									AND ISNULL (f.afe_num,'0') <> '0'
								) l
							WHERE maj.major_acct = l.major_acct
								) grs
							LEFT OUTER JOIN [stage].t_qbyte_authorizations_for_expenditure ae 
								ON ae.afe_num = grs.afe_num
								AND CASE grs.first_indicator_code WHEN 'NET' THEN 'Y' ELSE 'N' END = 'Y') /* This filter ensures that only AFE's associated with NET transactions are selected */
	AND li.afe_num NOT IN (	SELECT ae.afe_num 
							FROM [stage].t_qbyte_authorizations_for_expenditure ae
							JOIN (	SELECT o.afe_num,
										CASE WHEN lTRIM (RTRIM(ba.ref_org_id)) IS NULL THEN 'NOP' ELSE 'OP' END op_nonop,
										RTRIM(LTRIM(ba.ref_org_id))  AS ref_org_id
									FROM (	SELECT DISTINCT FIRST_VALUE (client_id) OVER (PARTITION BY afe_num
													ORDER BY last_update_date DESC,last_update_user,create_date) AS client_id, 
												afe_num
											FROM  [stage].t_qbyte_operator_afes
										)  o
									LEFT OUTER JOIN [stage].t_qbyte_business_associates ba ON o.client_id = ba.id
								) op ON ae.afe_num = op.afe_num
							WHERE op.op_nonop = 'NOP') /* This filter ensures that only Non-operated AFE's are selected */
	AND li.grs_net=2 -- NET
) qb_li_vc
LEFT OUTER JOIN [stage].t_vendor_invoices inv ON (qb_li_vc.src_invc_id = inv.invc_id)
LEFT OUTER JOIN [stage].[t_qbyte_organizations] org ON (qb_li_vc.lv_dest_org_id = org.org_id)
LEFT OUTER JOIN (	SELECT distinct ac.account_id, si_to_imp_conv_factor, boe_thermal, mcfe6_thermal, account_level_02, product_code, is_leaseops
						, CASE WHEN LTRIM (RTRIM (UPPER (ac.account_level_02))) = 'REVENUE' THEN -1 ELSE 1 END AS rev_multiplier
					FROM [data_mart].t_dim_account_hierarchy ac 
					WHERE zero_level = 1
					and is_leaseops = 1
	) acct ON (qb_li_vc.net_acct = acct.account_id)
LEFT OUTER JOIN (	SELECT DISTINCT account
					FROM [stage].[t_ctrl_accounts_xref]
					WHERE target_app = 'VOLUMES'
					AND source_app = 'STG_QBYTE'
					AND is_active  = 'Y'
	) vol_acct ON (qb_li_vc.net_acct = vol_acct.account)
LEFT OUTER JOIN [stage].[t_ctrl_fixed_var_opex] fv ON (qb_li_vc.net_acct = fv.qbyte_net_major_minor)
LEFT OUTER JOIN (	SELECT account_id
					FROM [stage].[t_ctrl_special_accounts]
					WHERE [is_capital] = 1

					union all

					select account_id
					from [data_mart].t_dim_account_hierarchy
					WHERE is_capital = 1
	) cap ON (qb_li_vc.net_acct = cap.account_id);