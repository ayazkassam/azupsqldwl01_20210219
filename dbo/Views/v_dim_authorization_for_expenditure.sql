CREATE VIEW [dbo].[v_dim_authorization_for_expenditure]
AS SELECT
       [afe_num] AS [afe_key],
       [afe_num],
	   CASE WHEN afe_num = '-1'
		    THEN 'AFE Not Required'
			ELSE  'AFE: ' + [afe_num] + ' ' + [afe_name] 
	   END AS [afe_name],
	   [afe_name] + ' (' + [afe_num] + ')' AS [afe_name_attribute],
       [client_id],
       [client_name],
       [op_nonop],
       [ref_org_id],
       COALESCE ([afe_type_code], 'AFE Type Not Applicable') AS [afe_type_code],
       COALESCE ([afe_type_description], 'Unspecified AFE Type') AS [afe_type_description],
       COALESCE ([afe_status_code], 'AFE Status Not Applicable') AS [afe_status_code],
       COALESCE ([afe_status_description], 'Unspecified AFE Status') AS [afe_status_description],
       [cost_centre],
       [cost_centre_name],
       COALESCE ([corp_code], 'CORP') AS [corp_code],
       /*CASE
          WHEN [corp_name] = 'Corporate'
             THEN 'Bonavista AFE Hierarchy'
          ELSE
             COALESCE ([corp_name], 'Unknown CORP_HIER AFE')
		*/
       'Bonavista AFE Hierarchy' AS [corp_name],
       CASE WHEN afe_num='-1' THEN 'Region_Not_Required'
	        WHEN afe_num='-2' or region is null THEN 'Region_Not_Matched'
	        ELSE [region]
	   END region,
       [region_code],
       COALESCE ([region_name],
                 CASE
                    WHEN afe_num = '-1'
                       THEN 'AFE Not Required'
                    ELSE
                       'Unknown CORP_HIER AFE'
                 END
                ) AS [region_name],
       CASE WHEN afe_num='-1' THEN 'District_Not_Required'
	        WHEN afe_num='-2' or district is null THEN 'District_Not_Matched'
	        ELSE [district]
	   END district,
       [district_code],
       COALESCE ([district_name],
                 CASE
                     WHEN afe_num = '-1'
                       THEN 'AFE Not Required'
                    ELSE
                       'Unknown CORP_HIER AFE'
                 END
                ) AS [district_name],
       CASE WHEN afe_num='-1' THEN 'Area_Not_Required'
	        WHEN afe_num='-2' or area is null THEN 'Area_Not_Matched'
	        ELSE [area]
	   END area,
       [area_code],
       COALESCE ([area_name],
                 CASE
                     WHEN afe_num = '-1'
                       THEN 'AFE Not Required'
                    ELSE
                       'Unknown CORP_HIER AFE'
                 END
                ) AS [area_name],
       CASE WHEN afe_num='-1' THEN 'Facility_Not_Required'
	        WHEN afe_num='-2' or facility is null THEN 'Facility_Not_Matched'
	        ELSE [facility]
	   END [facility],
       [facility_code],
       COALESCE ([facility_name],
                 CASE
                    WHEN afe_num = '-1'
                       THEN 'AFE Not Required'
                    ELSE
                       'Unknown CORP_HIER AFE'
                 END
                ) AS [facility_name],
       COALESCE ([curr_code], 'CAD') AS [curr_code],
       [ownership_org_id],
       [jib_flag],
       [cip_transfer_flag],
       [use_jibe_edits_flag],
       [accrual_flag],
       CONVERT (NVARCHAR, [create_date]) AS [create_date],
       [create_user],
       CONVERT (NVARCHAR, [last_updt_date]) AS [last_updt_date],
       [last_updt_user],
       CONVERT (NVARCHAR, [term_date], 23) AS [term_date],
       [term_user],
       CONVERT (NVARCHAR, [effective_date], 23) AS [effective_date],
       CONVERT (NVARCHAR, [proposal_date], 23) AS [proposal_date],
       CONVERT (NVARCHAR, [due_date], 23) AS [due_date],
       CONVERT (NVARCHAR, [commitment_date], 23) AS [commitment_date],
       CONVERT (NVARCHAR, [afe_approval_date], 23) AS [afe_approval_date],
       CONVERT (NVARCHAR, [afe_start_date], 23) AS [afe_start_date],
       [budget_activity_year],
	   [budget_activity_year_desc],
       [extrapolated_budget_year],
       [project_approval_status],
       [project_execution_status],
       CONVERT (NVARCHAR, [afe_date], 23) AS [afe_date],
       [acct_yr],
       [alloc_amt],
       [tax_code],
       [capital_accrual_method_code],
       [managing_org_id],
       ISNULL([net_estimate_pct], 0.0) net_estimate_pct,
       [internal_approver],
       [manager_name],
       [success_effort_type_code],
       [capital_accrual_cc_num],
       [equip_component_amt],
       [wrhse_component_amt],
       [translation_rate],
       [original_alloc_amt],
       [reporting_alloc_amt],
       [allow_other_orgs_code],
       [province],
       [engineer_assigned],
       [geologist_assigned],
       [geophysicist_assigned],
       [last_updt_status_user],
       CONVERT (NVARCHAR, [last_updt_status_date], 23) AS [last_updt_status_date],
       [doi_type_code],
       [afe_class_code],
       [default_gl_sub_code],
       CONVERT (NVARCHAR, [overhead_start_date], 23) AS [overhead_start_date],
       CONVERT (NVARCHAR, [overhead_end_date], 23) AS [overhead_end_date],
       [capital_or_dry_hole_exp_code],
       CONVERT (NVARCHAR, [last_accrued_date], 23) AS [last_accrued_date],
       [country_code],
       [survey_system_code],
       [primary_uwi],
       [uwi_alias],
       [primary_location],
       [sorted_uwi],
       [uwi_sort_element_1],
       [uwi_sort_element_2],
       [uwi_sort_element_3],
       [uwi_sort_element_4],
       [uwi_sort_element_5],
       [uwi_sort_element_6],
       [uwi_sort_element_7],
       [uwi_sort_element_8],
       [uwi_sort_element_9],
       [afe_udf_1_code],
       [afe_udf_5_code],
       [afe_udf_7_code],
       [afe_udf_20_code],
       [project_justification_comments],
	    COALESCE ([afe_type_group], 'UnKnown AFE Type Group') afe_type_group,
	    COALESCE ([afe_type_group_desc], 'UnKnown AFE Type Group') afe_type_group_desc,
		job_start_date,
		ISNULL(rig_number, '') rig_number,
		ISNULL(rig_name, '') rig_name,
		zone_play,
		wellview_spud_date, 
		wellview_rig_release_date, 
		wellview_total_depth, 
		wellview_intermediate_casing_depth,
		wellview_horizontal_depth,
		AFE_GCA_FCC,
		cc_list, Number_of_CCs, job_end_date
  FROM
       [data_mart].[t_dim_authorization_for_expenditure];