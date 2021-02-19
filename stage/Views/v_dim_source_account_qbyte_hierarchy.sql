CREATE VIEW [stage].[v_dim_source_account_qbyte_hierarchy]
AS SELECT account_id,
	   parent_id,
	   child_alias,
	   gl_account,
	   gl_account_description,
	   account_level_01,
	   isnull(account_level_02,account_level_01) account_level_02,
	   isnull(account_level_03,isnull(account_level_02,account_level_01)) account_level_03,
	   isnull( account_level_04, isnull(account_level_03,isnull(account_level_02,account_level_01)))  account_level_04,
	   isnull( account_level_05, isnull( account_level_04, isnull(account_level_03,isnull(account_level_02,account_level_01))))  account_level_05,
	   major_account,
	   minor_account,
	   major_account_description,
	   major_class_code,
	   class_code_description,
	   product_code,
	   si_to_imp_conv_factor,
	   boe_thermal,
	   mcfe6_thermal,
	   product_description,
	   account_group,
	   display_sequence_number,
	   gross_or_net_code,
	   CASE WHEN UPPER(account_level_02) IN  ('OPERATING EXPENSES',
                                                                  'ROYALTIES')
					     THEN '-'
						 ELSE '+'
	   END unary_operator,
	   sort_key,
	   account_level_01_sort_key,
	   isnull(account_level_02_sort_key,account_level_01_sort_key) account_level_02_sort_key,
	   isnull(account_level_03_sort_key,isnull(account_level_02_sort_key,account_level_01_sort_key)) account_level_03_sort_key,
	   isnull( account_level_04_sort_key, isnull(account_level_03_sort_key,isnull(account_level_02_sort_key,account_level_01_sort_key)))  account_level_04_sort_key,
	   isnull( account_level_05_sort_key, isnull( account_level_04_sort_key, isnull(account_level_03_sort_key,isnull(account_level_02_sort_key,account_level_01_sort_key))))  account_level_05_sort_key,
	   is_leaseops,
	   is_capital,
	   is_volumes,
	   is_valnav,
	   zero_level,
	   hierarchy_path,
	   level,
	   source
FROM
(
 SELECT 
					-- account_key
					 RCHI.child_id_Revised as account_id
					,RPI.[parent_id_Revised] as [parent_id]
					-- parent_key,
					,RCHA.[child_alias_Revised] as [child_alias]
					,[gl_account]
					,RGAD.[gl_account_description_Revised] as [gl_account_description]
					,PHP.account_level_01
					,PHP.account_level_02
					,PHP.account_level_03
					,PHP.account_level_04
					,PHP.account_level_05
					,[major_account]
					,[minor_account]
					,RMAD.[major_account_description_Revised] as [major_account_description]
					,[major_class_code]
					,[class_code_description]
					,[product_code]
					,[si_to_imp_conv_factor]
					,[boe_thermal]
					,[mcfe6_thermal]
					,[product_description]
					,[account_group]
					,[display_sequence_number]
					,[gross_or_net_code]
					,src.[sort_key]
					,PSK.account_level_01_sort_key
					,PSK.account_level_02_sort_key
					,PSK.account_level_03_sort_key
					,PSK.account_level_04_sort_key
					,PSK.account_level_05_sort_key
					, case when [is_leaseops] = 'Y' then 1 else 0 end [is_leaseops]
					, case when [is_capital] = 'Y' then 1 else 0 end [is_capital]
					, 0 [is_volumes]
					, 0 [is_valnav]
					,[zero_level]
					,src.[Hierarchy_Path]
					,[level]
					,'QBYTE' AS [source]
			 FROM [stage].[v_qbyte_account_hierarchy_source] src
			 LEFT JOIN [dbo].[Parse_Hierarchy_Path] PHP
			   ON PHP.[Hierarchy_Path] = src.[Hierarchy_Path] 
             LEFT JOIN [dbo].[Parse_sort_key] PSK
			   ON PSK.[sort_key] = src.[sort_key]
			 LEFT JOIN [dbo].[Revised_child_id] RCHI
			   ON RCHI.[child_id] = src.[child_id] 
			 LEFT JOIN [dbo].[Revised_parent_id] RPI
			   ON RPI.[parent_id] = src.[parent_id] 
			 LEFT JOIN [dbo].[Revised_child_alias] RCHA
			   ON RCHA.[child_alias] = src.[child_alias] 
			 LEFT JOIN [dbo].[Revised_gl_account_description] RGAD
			   ON RGAD.[gl_account_description] = src.[gl_account_description]
			 LEFT JOIN [dbo].[Revised_major_account_description] RMAD
			   ON RMAD.[major_account_description] = src.[major_account_description] 			   
) S;