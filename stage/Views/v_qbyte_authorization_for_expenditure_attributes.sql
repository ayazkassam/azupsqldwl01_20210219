CREATE VIEW [stage].[v_qbyte_authorization_for_expenditure_attributes]
AS SELECT ae.afe_num,
	CAST ([stage].[InitCap] (ae.afe_name) AS VARCHAR (40)) AS afe_name,
	CAST (op.client_id AS VARCHAR (50)) AS client_id,
	CAST (op.client_name AS VARCHAR (100)) AS client_name,
	CAST (op.op_nonop AS VARCHAR (10)) AS op_nonop,
	CAST (op.ref_org_id AS VARCHAR (50)) AS ref_org_id,
	CAST (COALESCE (ae.afe_type_code, '-1') AS VARCHAR (10)) AS afe_type_code,
	CAST (COALESCE (at.afe_type_description, 'Unspecified AFE Type') AS VARCHAR (100)) AS afe_type_description,
	CAST (COALESCE (ae.afe_stat_code, '-1') AS VARCHAR (10)) AS afe_status_code,
	CAST (COALESCE (stat.afe_status_description, 'Unspecified AFE Status') AS VARCHAR (100)) AS afe_status_description,
	COALESCE (ae.cc_num, '-1') AS cost_centre,
	COALESCE (cc.cost_centre_name, 'Unspecified Cost Centre') AS cost_centre_name,
	cc.corp_code,
	cc.corp_name,
	cc.region,
	cc.region_code,
	cc.region_name,
	cc.district,
	cc.district_code,
	cc.district_name,
	cc.area,
	cc.area_code,
	cc.area_name,
	cc.facility,
	cc.facility_code,
	cc.facility_name,
	ae.curr_code,
	ae.ownership_org_id,
	ae.jib_flag,
	CAST (ae.cip_transfer_flag AS VARCHAR (1)) AS cip_transfer_flag,
	ae.use_jibe_edits_flag,
	ae.accrual_flag,
	ae.create_date,
	ae.create_user,
	ae.last_updt_date,
	ae.last_updt_user,
	ae.term_date,
	ae.term_user,
	ae.effective_date,
	ae.proposal_date,
	ae.due_date,
	ae.commitment_date,
	ae.approval_date AS afe_approval_date,
	ae.afe_start_date,
	CASE WHEN COALESCE (ae.afe_udf_1_code,CAST (DATEPART (YYYY, ae.budget_activity_year) AS NVARCHAR(4)),CAST (ae.extrapolated_budget_year AS NVARCHAR(4))) IS NOT NULL
		THEN REPLACE ('BY' + COALESCE (ae.afe_udf_1_code,CAST (DATEPART (YYYY, ae.budget_activity_year) AS NVARCHAR(4)),CAST (ae.extrapolated_budget_year AS NVARCHAR(4))),'BYPRIOR PER','PRIOR_PERIOD')
		ELSE 'UNDEFINED_BUDGET_YEAR' END AS budget_activity_year,
	CASE WHEN COALESCE (ae.afe_udf_1_code,CAST (DATEPART (YYYY, ae.budget_activity_year) AS NVARCHAR(4)),CAST (ae.extrapolated_budget_year AS NVARCHAR(4))) IS NOT NULL
		THEN REPLACE (COALESCE (ae.afe_udf_1_code,CAST (DATEPART (YYYY, ae.budget_activity_year) AS NVARCHAR(4)),CAST (ae.extrapolated_budget_year AS NVARCHAR(4)))  + ' Budget Year','PRIOR PER Budget Year', 'Prior Period')
		ELSE 'Undefined Budget Year' END AS budget_activity_year_desc,
	ae.extrapolated_budget_year,
	CAST (NULL AS VARCHAR (50)) AS project_approval_status,
	CAST (NULL AS VARCHAR (50)) AS project_execution_status,
	COALESCE (ae.afe_start_date, ae.create_date) AS afe_date,
	DATEPART (YYYY, COALESCE (ae.afe_start_date, ae.create_date)) AS acct_yr,
	ae.alloc_amt,
	CAST (ae.tax_code AS VARCHAR (10)) AS tax_code,
	ae.capital_accrual_method_code,
	CAST (ae.managing_org_id AS VARCHAR (50)) AS managing_org_id,
	ae.net_estimate_pct,
	ae.internal_approver,
	ae.manager_name,
	ae.success_effort_type_code,
	ae.capital_accrual_cc_num,
	ae.equip_component_amt,
	ae.wrhse_component_amt,
	ae.translation_rate,
	ae.original_alloc_amt,
	ae.reporting_alloc_amt,
	ae.allow_other_orgs_code,
	ae.province,
	CAST (ae.engineer_assigned AS VARCHAR (50)) AS engineer_assigned,
	ae.geologist_assigned,
	ae.geophysicist_assigned,
	ae.last_updt_status_user,
	ae.last_updt_status_date,
	ae.doi_type_code,
	ae.afe_class_code,
	ae.default_gl_sub_code,
	ae.overhead_start_date,
	ae.overhead_end_date,
	ae.capital_or_dry_hole_exp_code,
	ae.last_accrued_date, 
	ae.country_code,
	ae.survey_system_code,
	ae.uwi AS primary_uwi,
	ae.uwi_description AS uwi_alias,
	ae.location AS primary_location,
	ae.sorted_uwi,
	ae.uwi_sort_element_1,
	ae.uwi_sort_element_2,
	ae.uwi_sort_element_3,
	ae.uwi_sort_element_4,
	ae.uwi_sort_element_5,
	ae.uwi_sort_element_6,
	ae.uwi_sort_element_7,
	ae.uwi_sort_element_8,
	ae.uwi_sort_element_9,
	CAST (LTRIM (RTRIM (UPPER (ae.afe_udf_1_code))) AS VARCHAR (50)) AS afe_udf_1_code,
	CAST (LTRIM (RTRIM (UPPER (ae.afe_udf_5_code))) AS VARCHAR (50)) AS afe_udf_5_code, /* Alternate source of Assigned Engineer information */
	CAST (LTRIM (RTRIM (ae.afe_udf_7_code)) AS VARCHAR (50)) AS afe_udf_7_code, /* Source of Capital Project Number information */
	CAST (LTRIM (RTRIM (ae.afe_udf_20_code)) AS VARCHAR (50)) AS afe_udf_20_code, /* Alternate source of Capital Project Number information */
	CAST (SUBSTRING (jst.project_justification_comments,1,4000) AS VARCHAR (4000)) AS project_justification_comments,
	CAST(ag.afe_type_group AS VARCHAR(50)) afe_type_group,
	CAST(ag.afe_type_group_desc AS VARCHAR(500)) afe_type_group_desc,
	convert(varchar(18),convert(date,isnull(wv_afe.job_start_date, sv_afe.job_start_date))) job_start_date,
	convert(varchar(18),convert(date,isnull(wv_afe.job_end_date, sv_afe.job_end_date))) job_end_date,
	wv_rig.rigno rig_number,
	wv_rig.contractor rig_name,
	zp.zone_play,
	CASE WHEN wv_afe.spud_date IS NULL THEN NULL
		ELSE CONCAT(DATEPART(year,wv_afe.spud_date),'-',RIGHT(CONCAT('0', DATEPART(mm,wv_afe.spud_date)),2),'-',
			RIGHT(CONCAT('0', DATEPART(dd,wv_afe.spud_date)),2)) END wellview_spud_date,
	CASE WHEN wv_afe.rig_release_date IS NULL THEN NULL 
		ELSE CONCAT(DATEPART(year,wv_afe.rig_release_date),'-',
			RIGHT(CONCAT('0', DATEPART(mm,wv_afe.rig_release_date)),2),'-',
			RIGHT(CONCAT('0', DATEPART(dd,wv_afe.rig_release_date)),2)) 
		END wellview_rig_release_date,
	wv_depths.total_depth wellview_total_depth,
	wv_depths.intermediate_casing_depth wellview_intermediate_casing_depth,
	wv_depths.total_depth - isnull(wv_depths.intermediate_casing_depth,0) wellview_horizontal_depth,
	cast(ae.afe_udf_2_code as varchar(50)) as afe_gca_fcc,
	list.cc_list, list.Number_of_CCs
FROM (
	SELECT a.*,
		CASE WHEN COALESCE (LEN (REPLACE ([stage].[Translate] (UPPER (SUBSTRING (a.afe_num, 3, 1)),'ABCDEFGHIJKLMNOPQRSTUVWXYZ','                          '),' ','')),0) = 0
				AND COALESCE (LEN (REPLACE ([stage].[Translate] (UPPER (SUBSTRING (a.afe_num, 1, 2)),'ABCDEFGHIJKLMNOPQRSTUVWXYZ','                          '),' ','')),0) <> 0
				AND a.afe_num <> '-1'
              THEN DATEPART (YYYY, CAST (CONCAT ('12/31/',RIGHT(REPLICATE ('0', 2)+ 
				REPLACE ([stage].[Translate] (UPPER (SUBSTRING (a.afe_num,1,2)),'ABCDEFGHIJKLMNOPQRSTUVWXYZ','                          '),' ',''),2 ))AS DATETIME))
			--THEN DATEPART (YYYY, TRY_CONVERT (DATETIME,CONCAT ('12/31/',RIGHT(REPLICATE ('0', 2)+ 
			--	REPLACE ([stage].[dbo].[Translate] (UPPER (SUBSTRING (a.afe_num,1,2)),'ABCDEFGHIJKLMNOPQRSTUVWXYZ','                          '),' ',''),2)),1))
			ELSE NULL END AS extrapolated_budget_year
	FROM [stage].[v_qbyte_afe_cc_uwis] a
) ae
LEFT OUTER JOIN (
		SELECT DISTINCT cost_centre,
			cost_centre_name,
			corp_code,
			REPLACE (corp_name, 'Bonavista Corporate Hierarchy', 'Bonavista AFE Hierarchy') AS corp_name,
			reporting_code_level2 + '_' + region_code AS region,
			region_code,
			'Region: ' + REPLACE (region_name, CHAR(9), ' ') AS region_name,
			reporting_code_level3 + '_' + district_code AS district,
			district_code,
			'District: ' + REPLACE (district_code, CHAR(9), ' ') AS district_name,
			reporting_code_level4 + '_' + area_code AS area,
			area_code,
			'Area: ' + REPLACE (area_name, CHAR(9), ' ') AS area_name,
			reporting_code_level5 + '_' + facility_code AS facility,
			facility_code,
			'Facility: ' + facility_name AS facility_name
		FROM [stage].[v_qbyte_corp_hierarchy]
		WHERE cost_centre IS NOT NULL
) cc ON (ae.cc_num = cc.cost_centre)
LEFT OUTER JOIN (
		SELECT o.afe_num,
			o.client_id AS client_id,
			CASE WHEN LTRIM (RTRIM (ba.name_1)) IS NOT NULL 
				THEN LTRIM (RTRIM ([stage].[InitCap] (ba.name_1))) + ' (' + CONVERT (VARCHAR, o.client_id) + ')' ELSE NULL END AS client_name,
			CASE WHEN LTRIM (RTRIM (ba.ref_org_id)) IS NOT NULL THEN 'OP' ELSE 'NOP' END AS op_nonop,
			LTRIM (RTRIM (ba.ref_org_id)) AS ref_org_id
		FROM (
				SELECT DISTINCT FIRST_VALUE(client_id) OVER (PARTITION BY afe_num ORDER BY last_update_date DESC,last_update_user,create_date) AS client_id,
					afe_num
				FROM [stage].[t_qbyte_operator_afes]
		) o 
		LEFT OUTER JOIN [stage].[t_qbyte_business_associates] ba ON (o.client_id = ba.id)
) op ON (ae.afe_num = op.afe_num)
LEFT OUTER JOIN [stage].[v_qbyte_afe_project_justification_comments] jst ON (ae.afe_num = jst.afe_num) 
LEFT OUTER JOIN (
		SELECT UPPER (c.code) AS afe_type_code,
			[stage].[InitCap] (LTRIM (RTRIM (code_desc))) AS afe_type_description,
			[stage].[InitCap] (REPLACE (LTRIM (RTRIM (code_desc)), ' ', '_')) + '_' + c.code AS sort_key
		FROM [stage].[t_qbyte_codes] c
		WHERE c.code_type_code = 'AFE_TYPE_CODE'
) at ON (UPPER (ae.afe_type_code) = at.afe_type_code)
LEFT OUTER JOIN (
		SELECT UPPER (c.code) AS afe_status_code,
			[stage].[InitCap] (LTRIM (RTRIM (code_desc))) AS afe_status_description,
			[stage].[InitCap] (REPLACE (LTRIM (RTRIM (code_desc)), ' ', '_')) + '_' + c.code AS sort_key
		FROM [stage].[t_qbyte_codes] c
		WHERE c.code_type_code = 'AFE_STAT_CODE'
) stat ON (UPPER (ae.afe_stat_code) = stat.afe_status_code)
LEFT OUTER JOIN (
		SELECT t.afe_type_code, t.afe_type_group, tc.afe_type_group_desc
		FROM (
				SELECT b.reporting_entity_code AS afe_type_code,
					b.parent_reporting_entity_code AS afe_type_group
				FROM [stage].[t_qbyte_reporting_entities] b
				WHERE b.parent_reporting_level_code = 'ROLLUP'
				AND b.hierarchy_code = 'AFETYPE'
		) t
		, (		SELECT a.reporting_entity_code AS afe_type_group,
						CASE WHEN a.reporting_entity_desc IS NULL THEN NULL 
							ELSE RTRIM(LTRIM (REPLACE ([stage].[InitCap](a.reporting_entity_desc),CHAR (9), ' '))) + ' AFE Types' END  AS afe_type_group_desc
				FROM [stage].[t_qbyte_reporting_entities] a
				WHERE a.parent_reporting_level_code IS NULL
				AND a.hierarchy_code = 'AFETYPE'
		) tc 
		WHERE t.afe_type_group = tc.afe_type_group
) ag ON (UPPER (ae.afe_type_code) =ag.afe_type_code)
LEFT OUTER JOIN ( 
		SELECT DISTINCT LTRIM (RTRIM (a.afenumber)) afe_num,
			MIN(wj.dttmstart) OVER (PARTITION BY LTRIM (RTRIM (a.afenumber))) job_start_date,
			MIN(wj.dttmend) OVER (PARTITION BY LTRIM (RTRIM (a.afenumber))) job_end_date,
			MIN(wh.dttmspud) OVER (PARTITION BY LTRIM (RTRIM (a.afenumber))) spud_date,
			MIN(wh.dttmrr) OVER (PARTITION BY LTRIM (RTRIM (a.afenumber))) rig_release_date
		FROM [stage].[t_wellview_wvt_wvjob] wj
		INNER JOIN  [stage].[t_wellview_wvt_wvjobafe] a ON wj.idwell = a.idwell AND wj.idrec = a.idrecparent
		INNER JOIN  [stage].[t_wellview_wvt_wvwellheader] wh ON wj.idwell = wh.idwell
		WHERE LTRIM (RTRIM (a.afenumber)) IS NOT NULL
) wv_afe ON ae.afe_num = wv_afe.afe_num
LEFT OUTER JOIN (
		SELECT  DISTINCT LTRIM (RTRIM (a.refno)) afe_num,
			MIN(sj.dttmstart) OVER (PARTITION BY  LTRIM (RTRIM (a.refno))) job_start_date,
			MIN(sj.dttmend) OVER (PARTITION BY  LTRIM (RTRIM (a.refno))) job_end_date
		FROM [stage].[t_siteview_svt_svjob] sj
		INNER JOIN [stage].[t_siteview_svt_svjobafe] a ON sj.idsite = a.idsite AND sj.idrec = a.idrecparent
		WHERE LTRIM (RTRIM (a.refno)) IS NOT NULL
) sv_afe ON ae.afe_num = sv_afe.afe_num
LEFT OUTER JOIN (
		/*-- Rig# and Rigname from Wellview*/
		SELECT DISTINCT afenumber,
			first_value(rigno) over (partition by afenumber order by calc_dttmend, dttmstart desc) rigno,
			first_value(contractor) over (partition by afenumber order by calc_dttmend, dttmstart desc) contractor
		FROM (
				SELECT afe.afenumber, jr.*,isnull(jr.dttmend, current_timestamp) calc_dttmend
				FROM (
						SELECT wj.*, a.afenumber
						FROM [stage].[t_wellview_wvt_wvjob] wj
						INNER JOIN  [stage].[t_wellview_wvt_wvjobafe] a ON wj.idwell = a.idwell AND wj.idrec = a.idrecparent
						WHERE LTRIM (RTRIM (a.afenumber)) IS NOT NULL
				) afe
				LEFT OUTER JOIN [stage].[t_wellview_wvt_wvjobrig] jr ON afe.idwell = jr.idwell AND afe.idrec = jr.idrecparent
				WHERE (jr.proposed = 0 or jr.proposed is null)
		) sd
) wv_rig ON ae.afe_num = wv_rig.afenumber
LEFT OUTER JOIN (
		/*-- Zone Play*/
		SELECT DISTINCT afe_cc.afe_num, 
			FIRST_VALUE(zone_play) OVER (PARTITION BY afe_cc.afe_num ORDER BY cc_zone.cost_centre) zone_play
		FROM [stage].t_qbyte_afes_cost_centres afe_cc
		JOIN (
				SELECT DISTINCT cost_centre,
					FIRST_VALUE(ISNULL(zone_desc,zone_play)) OVER (PARTITION BY cost_centre ORDER BY ISNULL(zone_desc,zone_play)) zone_play
				FROM [data_mart].t_dim_entity
				WHERE is_valnav='1'
				and ISNULL(zone_desc,zone_play) IS NOT NULL
		) cc_zone ON afe_cc.cc_num = cc_zone.cost_centre
) zp ON ae.afe_num = zp.afe_num
LEFT OUTER JOIN (
		SELECT DISTINCT LTRIM (RTRIM (afenumber)) afe_num,
			max(depthend) over (partition by afenumber) total_depth,	 
			max (intermediate_casing_depth) over (partition by afenumber) intermediate_casing_depth
		FROM (
				SELECT afe.afenumber, 
					wsp.*, 
					cas.des case_descr, 
					cas.depthbtm,
					case when  upper(cas.des) = 'INTERMEDIATE' then  cas.depthbtm  else null end intermediate_casing_depth
				FROM (
						SELECT wj.*, a.afenumber
						FROM [stage].[t_wellview_wvt_wvjob] wj
						INNER JOIN  [stage].[t_wellview_wvt_wvjobafe] a ON wj.idwell = a.idwell AND wj.idrec = a.idrecparent
						WHERE LTRIM (RTRIM (a.afenumber)) IS NOT NULL
				) afe
				LEFT OUTER JOIN [stage].t_wellview_wvt_wvjobdrillstring ws ON afe.idwell = ws.idwell AND afe.idrec = ws.idrecparent
				LEFT OUTER JOIN [stage].[t_wellview_wvt_wvjobdrillstringdrillparam] wsp ON ws.idwell = wsp.idwell AND ws.idrec = wsp.idrecparent
				LEFT OUTER JOIN [stage].t_wellview_wvt_wvwellheader wh ON afe.idwell = wh.idwell
				LEFT OUTER JOIN [stage].[t_wellview_wvt_wvcas] cas ON wh.idwell = cas.idwell
		) sd
) wv_depths ON ae.afe_num = wv_depths.afe_num
left outer join stage.v_qbyte_afe_cc_list list on ae.afe_num = list.afe_num;