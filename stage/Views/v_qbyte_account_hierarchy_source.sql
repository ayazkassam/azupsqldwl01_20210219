CREATE VIEW [stage].[v_qbyte_account_hierarchy_source]
AS SELECT 
      stage.InitCap(child_id) as child_id
	, stage.InitCap(parent_id) as parent_id
	, stage.InitCap(child_alias) as child_alias
	, major_minor AS gl_account
	, stage.InitCap(gl_account_description) as gl_account_description
	, major_account
	, minor_account
	, major_account_description
	, major_class_code
	, class_code_description
	, product_code
	, si_to_imp_conv_factor
	, boe_thermal
	, mcfe6_thermal
	, product_description
	, account_group
	, display_sequence_number
	, gross_or_net_code
	, sort_key
	, is_leaseops
	, is_capital
	, is_valnav
	, zero_level
	, [Hierarchy_Path]
	, level  
FROM (
		SELECT child_id
			, parent_id
			, child_alias
			, gl_account_description
			, major_minor
			, CASE WHEN major_minor IS NOT NULL THEN coalesce(child_alias, child_id) END AS major_minor_description
			, major_account
			, major_account_description AS major_account_description
			, minor_account
			, account_uda AS major_class_code
			, class_code_description
			, product_uda AS product_code
			, si_to_imp_conv_factor
			, boe_thermal
			, mcfe6_thermal
			, product_description AS product_description
			, account_group
			, gross_or_net_code
			, display_seq_num AS display_sequence_number
			, sort_key
			, zero_level
			, [Hierarchy_Path]
			, level
			, case when account_group = 'LSEOP' then 'Y' else 'N' end as is_leaseops
			, case when account_group = 'CAPRT' then 'Y' else 'N' end as is_capital
			, 'N' as is_valnav
		FROM [dbo].[CTE_v_qbyte_account_hierarchy_source]
) t;