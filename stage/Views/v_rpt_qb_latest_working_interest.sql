CREATE VIEW [stage].[v_rpt_qb_latest_working_interest]
AS select lnk.cc_num
		, ccl.uwi
		, lnk.ownership_link_id
		, lnk.agreement_id
		, lnk.effective_date
		, lnk.expiry_date
		, lnk.next_effective_date
		, lnk.org_id
		, lnk.major_acct
		, lnk.minor_acct
		, lnk.last_updt_date
		, lnk.create_date
		, lnk.acct_group_code
		, lnk.[RANK] 
		, ddp.PARTNER_BA_ID
		, ddp.LA_PARTNER_PCT
		, ddp.FM_PARTNER_PCT AS QB_DOI
		, sum(ddp.FM_PARTNER_PCT) over (partition by lnk.cc_num) as TOTAL_WI
		, cc.CC_TYPE_CODE
		, cde.CODE_DESC
		, cc.TERM_DATE
		, BA.ID as BA_ID
		, BA.NAME_1 as BA_NAME
				/*--rank partners by ownership weight, and name*/
		, ROW_NUMBER() over (PARTITION BY lnk.cc_num order by ddp.FM_PARTNER_PCT desc, BA.NAME_1) as pct_rnk 
	from  (
			SELECT al.cc_num,	
				al.ownership_link_id,
				al.agreement_id,
				al.effective_date,
				al.expiry_date,
				lead (al.effective_date) OVER (PARTITION BY al.cc_num ORDER BY al.effective_date) AS next_effective_date,
				al.org_id,
				al.major_acct,
				al.minor_acct,
				al.last_updt_date,
				al.create_date,
				al.acct_group_code,
				/*-- rank latest based on date criteria (used in pref to dense rank as records may exist with same effective date)*/
				ROW_NUMBER () OVER (PARTITION BY al.cc_num 
					ORDER BY effective_date desc, al.expiry_date desc, al.last_updt_date DESC, al.create_date DESC) AS [RANK] 
			FROM stage.t_qbyte_ownership_agreement_links al
			WHERE al.effective_date IS NOT NULL
			AND al.afe_num IS NULL
			AND (al.acct_group_code IS NULL or al.acct_group_code = 'NOPWI')  /*-- null for operated || 'NOPWI'	for nonoperated*/
			AND al.major_acct IS NULL
			AND al.minor_acct IS NULL
			AND al.production_revenue_code IS NULL
			AND al.terminate_flag = 'N'
	) lnk /*--most recent Ownership Agreement link per CC*/
	left join stage.t_qbyte_doi_deck_partners ddp ON lnk.agreement_id = ddp.doi_deck_id
	left join stage.t_qbyte_cost_centres cc ON lnk.CC_NUM = cc.CC_NUM
	left join stage.t_qbyte_codes cde on (cc.CC_TYPE_CODE = cde.CODE and cde.CODE_TYPE_CODE = 'CC_TYPE_CODE')
	left join stage.t_qbyte_business_associates ba ON ba.id = ddp.PARTNER_BA_ID
	left join stage.iv_qbyte_cost_centre_legals ccl on lnk.CC_NUM = ccl.CC_NUM	and ccl.PRIMARY_FLAG = 'Y'	--revisit this logic
	where ddp.SILENT_PARTNER_FLAG = 'N'	/*--non silent partners*/
	and lnk.RANK = 1;