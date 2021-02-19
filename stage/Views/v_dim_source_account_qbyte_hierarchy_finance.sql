CREATE VIEW [stage].[v_dim_source_account_qbyte_hierarchy_finance]
AS SELECT   fin_bs_is.account_id
	   , fin_bs_is.parent_id
	   , fin_bs_is.child_alias
	   , fin_bs_is.gl_account
	   , fin_bs_is.gl_account_description

	   , fin_bs_is.account_level_01_desc
	   , coalesce(fin_bs_is.account_level_02_desc,fin_bs_is.account_level_01_desc) account_level_02_desc
	   , coalesce(fin_bs_is.account_level_03_desc,fin_bs_is.account_level_02_desc,fin_bs_is.account_level_01_desc) account_level_03_desc
	   , coalesce(fin_bs_is.account_level_04_desc,fin_bs_is.account_level_03_desc,fin_bs_is.account_level_02_desc,fin_bs_is.account_level_01_desc) account_level_04_desc
	   , coalesce(fin_bs_is.account_level_05_desc,fin_bs_is.account_level_04_desc,fin_bs_is.account_level_03_desc,fin_bs_is.account_level_02_desc,fin_bs_is.account_level_01_desc) account_level_05_desc
	   , coalesce(fin_bs_is.account_level_06_desc,fin_bs_is.account_level_05_desc,fin_bs_is.account_level_04_desc,fin_bs_is.account_level_03_desc,fin_bs_is.account_level_02_desc,fin_bs_is.account_level_01_desc) account_level_06_desc
	   , coalesce(fin_bs_is.account_level_07_desc,fin_bs_is.account_level_06_desc,fin_bs_is.account_level_05_desc,fin_bs_is.account_level_04_desc,fin_bs_is.account_level_03_desc,fin_bs_is.account_level_02_desc,fin_bs_is.account_level_01_desc) account_level_07_desc
	   , coalesce(fin_bs_is.account_level_08_desc,fin_bs_is.account_level_07_desc,fin_bs_is.account_level_06_desc,fin_bs_is.account_level_05_desc,fin_bs_is.account_level_04_desc,fin_bs_is.account_level_03_desc,fin_bs_is.account_level_02_desc,fin_bs_is.account_level_01_desc) account_level_08_desc
	   , coalesce(fin_bs_is.account_level_09_desc,fin_bs_is.account_level_08_desc,fin_bs_is.account_level_07_desc,fin_bs_is.account_level_06_desc,fin_bs_is.account_level_05_desc,fin_bs_is.account_level_04_desc,fin_bs_is.account_level_03_desc,fin_bs_is.account_level_02_desc,fin_bs_is.account_level_01_desc) account_level_09_desc
	   , coalesce(fin_bs_is.account_level_10_desc,fin_bs_is.account_level_09_desc,fin_bs_is.account_level_08_desc,fin_bs_is.account_level_07_desc,fin_bs_is.account_level_06_desc,fin_bs_is.account_level_05_desc,fin_bs_is.account_level_04_desc,fin_bs_is.account_level_03_desc,fin_bs_is.account_level_02_desc,fin_bs_is.account_level_01_desc) account_level_10_desc
	   , fin_bs_is.major_account
	   , fin_bs_is.minor_account
	   , fin_bs_is.major_account_description
	   , fin_bs_is.major_class_code
	   , fin_bs_is.class_code_description
	   , fin_bs_is.product_code
	   , fin_bs_is.si_to_imp_conv_factor
	   , fin_bs_is.boe_thermal
	   , fin_bs_is.mcfe6_thermal
	   , fin_bs_is.product_description
	   , fin_bs_is.account_group
	   , fin_bs_is.display_sequence_number
	   , fin_bs_is.gross_or_net_code
	   , CASE WHEN UPPER(fin_bs_is.account_level_02_desc) IN  ('OPERATING EXPENSES','ROYALTIES') THEN '-' ELSE '+' END unary_operator
	   , fin_bs_is.sort_key
	   , fin_bs_is.account_level_01_sort_key
	   , coalesce(fin_bs_is.account_level_02_sort_key,fin_bs_is.account_level_01_sort_key) account_level_02_sort_key
	   , coalesce(fin_bs_is.account_level_03_sort_key,fin_bs_is.account_level_02_sort_key,fin_bs_is.account_level_01_sort_key) account_level_03_sort_key
	   , coalesce(fin_bs_is.account_level_04_sort_key,fin_bs_is.account_level_03_sort_key,fin_bs_is.account_level_02_sort_key,fin_bs_is.account_level_01_sort_key) account_level_04_sort_key
	   , coalesce(fin_bs_is.account_level_05_sort_key,fin_bs_is.account_level_04_sort_key,fin_bs_is.account_level_03_sort_key,fin_bs_is.account_level_02_sort_key,fin_bs_is.account_level_01_sort_key) account_level_05_sort_key
	   , coalesce(fin_bs_is.account_level_06_sort_key,fin_bs_is.account_level_05_sort_key,fin_bs_is.account_level_04_sort_key,fin_bs_is.account_level_03_sort_key,fin_bs_is.account_level_02_sort_key,fin_bs_is.account_level_01_sort_key) account_level_06_sort_key
	   , coalesce(fin_bs_is.account_level_07_sort_key,fin_bs_is.account_level_06_sort_key,fin_bs_is.account_level_05_sort_key,fin_bs_is.account_level_04_sort_key,fin_bs_is.account_level_03_sort_key,fin_bs_is.account_level_02_sort_key,fin_bs_is.account_level_01_sort_key) account_level_07_sort_key
	   , coalesce(fin_bs_is.account_level_08_sort_key,fin_bs_is.account_level_07_sort_key,fin_bs_is.account_level_06_sort_key,fin_bs_is.account_level_05_sort_key,fin_bs_is.account_level_04_sort_key,fin_bs_is.account_level_03_sort_key,fin_bs_is.account_level_02_sort_key,fin_bs_is.account_level_01_sort_key) account_level_08_sort_key
	   , coalesce(fin_bs_is.account_level_09_sort_key,fin_bs_is.account_level_08_sort_key,fin_bs_is.account_level_07_sort_key,fin_bs_is.account_level_06_sort_key,fin_bs_is.account_level_05_sort_key,fin_bs_is.account_level_04_sort_key,fin_bs_is.account_level_03_sort_key,fin_bs_is.account_level_02_sort_key,fin_bs_is.account_level_01_sort_key) account_level_09_sort_key
	   , coalesce(fin_bs_is.account_level_10_sort_key,fin_bs_is.account_level_09_sort_key,fin_bs_is.account_level_08_sort_key,fin_bs_is.account_level_07_sort_key,fin_bs_is.account_level_06_sort_key,fin_bs_is.account_level_05_sort_key,fin_bs_is.account_level_04_sort_key,fin_bs_is.account_level_03_sort_key,fin_bs_is.account_level_02_sort_key,fin_bs_is.account_level_01_sort_key) account_level_10_sort_key
	   , fin_bs_is.is_leaseops
	   , fin_bs_is.is_capital
	   , fin_bs_is.is_volumes
	   , fin_bs_is.is_valnav
	   , fin_bs_is.is_Finance
	   , fin_bs_is.zero_level
	   , fin_bs_is.hierarchy_path
	   , fin_bs_is.level
	   --
	   -----
	   --DEP
	   -----
	   , dep.account_group dep_account_group
	   , dep.account_id dep_account_id
	   , dep.parent_id dep_parent_id
	   , dep.child_alias dep_child_alias
	   , dep.gl_account dep_gl_account
	   , dep.gl_account_description dep_gl_account_description
	   , dep.account_level_01_desc dep_level_01_desc
	   , coalesce(dep.account_level_02_desc,dep.account_level_01_desc) dep_level_02_desc
	   , coalesce(dep.account_level_03_desc,dep.account_level_02_desc,dep.account_level_01_desc) dep_level_03_desc
	   , coalesce(dep.account_level_04_desc,dep.account_level_03_desc,dep.account_level_02_desc,dep.account_level_01_desc) dep_level_04_desc
	   , coalesce(dep.account_level_05_desc,dep.account_level_04_desc,dep.account_level_03_desc,dep.account_level_02_desc,dep.account_level_01_desc) dep_level_05_desc
	   --
	   , dep.major_account dep_major_account
	   , dep.minor_account dep_minor_account
	   , dep.major_account_description dep_major_account_description
	   , dep.major_class_code dep_major_class_code
	   , dep.class_code_description dep_class_code_description
	    , CASE WHEN UPPER(dep.account_level_02_desc) IN  ('OPERATING EXPENSES','ROYALTIES') THEN '-' ELSE '+' END dep_unary_operator
	   , dep.sort_key dep_sort_key
	   , dep.account_level_01_sort_key dep_level_01_sort_key
	   , coalesce(dep.account_level_02_sort_key,dep.account_level_01_sort_key) dep_level_02_sort_key
	   , coalesce(dep.account_level_03_sort_key,dep.account_level_02_sort_key,dep.account_level_01_sort_key) dep_level_03_sort_key
	   , coalesce(dep.account_level_04_sort_key,dep.account_level_03_sort_key,dep.account_level_02_sort_key,dep.account_level_01_sort_key) dep_level_04_sort_key
	   , coalesce(dep.account_level_05_sort_key,dep.account_level_04_sort_key,dep.account_level_03_sort_key,dep.account_level_02_sort_key,dep.account_level_01_sort_key) dep_level_05_sort_key
	   --
	   --------
	   -- TAXOP
	   --------
	   , taxop.account_group taxop_account_group
	   , taxop.account_id taxop_account_id
	   , taxop.parent_id taxop_parent_id
	   , taxop.child_alias taxop_child_alias
	   , taxop.gl_account taxop_gl_account
	   , taxop.gl_account_description taxop_gl_account_description
	   , taxop.account_level_01_desc taxop_level_01_desc
	   , coalesce(taxop.account_level_02_desc,taxop.account_level_01_desc) taxop_level_02_desc
	   , coalesce(taxop.account_level_03_desc,taxop.account_level_02_desc,taxop.account_level_01_desc) taxop_level_03_desc
	   , coalesce(taxop.account_level_04_desc,taxop.account_level_03_desc,taxop.account_level_02_desc,taxop.account_level_01_desc) taxop_level_04_desc
	   , coalesce(taxop.account_level_05_desc,taxop.account_level_04_desc,taxop.account_level_03_desc,taxop.account_level_02_desc,taxop.account_level_01_desc) taxop_level_05_desc
	   --
	   , taxop.major_account taxop_major_account
	   , taxop.minor_account taxop_minor_account
	   , taxop.major_account_description taxop_major_account_description
	   , taxop.major_class_code taxop_major_class_code
	   , taxop.class_code_description taxop_class_code_description
	    , CASE WHEN UPPER(taxop.account_level_02_desc) IN  ('OPERATING EXPENSES','ROYALTIES') THEN '-' ELSE '+' END taxop_unary_operator
	   , taxop.sort_key taxop_sort_key
	   , taxop.account_level_01_sort_key taxop_level_01_sort_key
	   , coalesce(taxop.account_level_02_sort_key,taxop.account_level_01_sort_key) taxop_level_02_sort_key
	   , coalesce(taxop.account_level_03_sort_key,taxop.account_level_02_sort_key,taxop.account_level_01_sort_key) taxop_level_03_sort_key
	   , coalesce(taxop.account_level_04_sort_key,taxop.account_level_03_sort_key,taxop.account_level_02_sort_key,taxop.account_level_01_sort_key) taxop_level_04_sort_key
	   , coalesce(taxop.account_level_05_sort_key,taxop.account_level_04_sort_key,taxop.account_level_03_sort_key,taxop.account_level_02_sort_key,taxop.account_level_01_sort_key) taxop_level_05_sort_key
	   --
	   --------
	   -- GCART
	   --------
	   , gcart.account_group gcart_account_group
	   , gcart.account_id gcart_account_id
	   , gcart.parent_id gcart_parent_id
	   , gcart.child_alias gcart_child_alias
	   , gcart.gl_account gcart_gl_account
	   , gcart.gl_account_description gcart_gl_account_description
	   , gcart.account_level_01_desc gcart_level_01_desc
	   , coalesce(gcart.account_level_02_desc,gcart.account_level_01_desc) gcart_level_02_desc
	   , coalesce(gcart.account_level_03_desc,gcart.account_level_02_desc,gcart.account_level_01_desc) gcart_level_03_desc
	   , coalesce(gcart.account_level_04_desc,gcart.account_level_03_desc,gcart.account_level_02_desc,gcart.account_level_01_desc) gcart_level_04_desc
	   , coalesce(gcart.account_level_05_desc,gcart.account_level_04_desc,gcart.account_level_03_desc,gcart.account_level_02_desc,gcart.account_level_01_desc) gcart_level_05_desc
	   --
	   , gcart.major_account gcart_major_account
	   , gcart.minor_account gcart_minor_account
	   , gcart.major_account_description gcart_major_account_description
	   , gcart.major_class_code gcart_major_class_code
	   , gcart.class_code_description gcart_class_code_description
	    , CASE WHEN UPPER(gcart.account_level_02_desc) IN  ('OPERATING EXPENSES','ROYALTIES') THEN '-' ELSE '+' END gcart_unary_operator
	   , gcart.sort_key gcart_sort_key
	   , gcart.account_level_01_sort_key gcart_level_01_sort_key
	   , coalesce(gcart.account_level_02_sort_key,gcart.account_level_01_sort_key) gcart_level_02_sort_key
	   , coalesce(gcart.account_level_03_sort_key,gcart.account_level_02_sort_key,gcart.account_level_01_sort_key) gcart_level_03_sort_key
	   , coalesce(gcart.account_level_04_sort_key,gcart.account_level_03_sort_key,gcart.account_level_02_sort_key,gcart.account_level_01_sort_key) gcart_level_04_sort_key
	   , coalesce(gcart.account_level_05_sort_key,gcart.account_level_04_sort_key,gcart.account_level_03_sort_key,gcart.account_level_02_sort_key,gcart.account_level_01_sort_key) gcart_level_05_sort_key
	   --
	   --------
	   -- ESTMA
	   --------
	   , estma.account_group estma_account_group
	   , estma.account_id estma_account_id
	   , estma.parent_id estma_parent_id
	   , estma.child_alias estma_child_alias
	   , estma.gl_account estma_gl_account
	   , estma.gl_account_description estma_gl_account_description
	   , estma.account_level_01_desc estma_level_01_desc
	   , coalesce(estma.account_level_02_desc,estma.account_level_01_desc) estma_level_02_desc
	   , coalesce(estma.account_level_03_desc,estma.account_level_02_desc,estma.account_level_01_desc) estma_level_03_desc
	   , coalesce(estma.account_level_04_desc,estma.account_level_03_desc,estma.account_level_02_desc,estma.account_level_01_desc) estma_level_04_desc
	   , coalesce(estma.account_level_05_desc,estma.account_level_04_desc,estma.account_level_03_desc,estma.account_level_02_desc,estma.account_level_01_desc) estma_level_05_desc
	   --
	   , estma.major_account estma_major_account
	   , estma.minor_account estma_minor_account
	   , estma.major_account_description estma_major_account_description
	   , estma.major_class_code estma_major_class_code
	   , estma.class_code_description estma_class_code_description
	    , CASE WHEN UPPER(estma.account_level_02_desc) IN  ('OPERATING EXPENSES','ROYALTIES') THEN '-' ELSE '+' END estma_unary_operator
	   , estma.sort_key estma_sort_key
	   , estma.account_level_01_sort_key estma_level_01_sort_key
	   , coalesce(estma.account_level_02_sort_key,estma.account_level_01_sort_key) estma_level_02_sort_key
	   , coalesce(estma.account_level_03_sort_key,estma.account_level_02_sort_key,estma.account_level_01_sort_key) estma_level_03_sort_key
	   , coalesce(estma.account_level_04_sort_key,estma.account_level_03_sort_key,estma.account_level_02_sort_key,estma.account_level_01_sort_key) estma_level_04_sort_key
	   , coalesce(estma.account_level_05_sort_key,estma.account_level_04_sort_key,estma.account_level_03_sort_key,estma.account_level_02_sort_key,estma.account_level_01_sort_key) estma_level_05_sort_key
	   --
	   , fin_bs_is.source
FROM
(
 SELECT 
					 RCHI.child_id_Revised as account_id
					,RPI.[parent_id_Revised] as [parent_id]
					,RCHA.[child_alias_Revised] as [child_alias]
					,[gl_account]
					,RGAD.[gl_account_description_Revised] as [gl_account_description]
					,PHP.account_level_01 account_level_01_desc
					,PHP.account_level_02 account_level_02_desc
					,PHP.account_level_03 account_level_03_desc
					,PHP.account_level_04 account_level_04_desc
					,PHP.account_level_05 account_level_05_desc
					,PHP.account_level_06 account_level_06_desc
					,PHP.account_level_07 account_level_07_desc
					,PHP.account_level_08 account_level_08_desc
					,PHP.account_level_09 account_level_09_desc
					,PHP.account_level_10 account_level_10_desc
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
					,PSK.account_level_01_sort_key account_level_01_sort_key
					,PSK.account_level_02_sort_key account_level_02_sort_key
					,PSK.account_level_03_sort_key account_level_03_sort_key
					,PSK.account_level_04_sort_key account_level_04_sort_key
					,PSK.account_level_05_sort_key account_level_05_sort_key
					,PSK.account_level_06_sort_key account_level_06_sort_key
					,PSK.account_level_07_sort_key account_level_07_sort_key
					,PSK.account_level_08_sort_key account_level_08_sort_key
					,PSK.account_level_09_sort_key account_level_09_sort_key
					,PSK.account_level_10_sort_key account_level_10_sort_key
					, case when [is_leaseops] = 'Y' then 1 else 0 end [is_leaseops]
					, case when [is_capital] = 'Y' then 1 else 0 end [is_capital]
					, case when [is_Finance] = 'Y' then 1 else 0 end [is_Finance]
					, 0 [is_volumes]
					, 0 [is_valnav]
					,[zero_level]
					,src.[Hierarchy_Path]
					,[level]
					,'QBYTE' AS [source]
			  FROM [stage].[t_qbyte_account_hierarchy_source_finance] src
			  LEFT JOIN [dbo].[Parse_Hierarchy_Path] PHP
			    ON PHP.[Hierarchy_Path] = src.[Hierarchy_Path_desc] 
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
			  WHERE [account_group] in ('FINBS','FINIS')
) fin_bs_is
--
LEFT OUTER JOIN
--
(
SELECT 
					 RCHI.child_id_Revised as account_id
					,RPI.[parent_id_Revised] as [parent_id]
					,RCHA.[child_alias_Revised] as [child_alias]
					,[gl_account]
					,RGAD.[gl_account_description_Revised] as [gl_account_description]
					,PHP.account_level_01 account_level_01_desc
					,PHP.account_level_02 account_level_02_desc
					,PHP.account_level_03 account_level_03_desc
					,PHP.account_level_04 account_level_04_desc
					,PHP.account_level_05 account_level_05_desc
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
					,PSK.account_level_01_sort_key account_level_01_sort_key
					,PSK.account_level_02_sort_key account_level_02_sort_key
					,PSK.account_level_03_sort_key account_level_03_sort_key
					,PSK.account_level_04_sort_key account_level_04_sort_key
					,PSK.account_level_05_sort_key account_level_05_sort_key
					, case when [is_leaseops] = 'Y' then 1 else 0 end [is_leaseops]
					, case when [is_capital] = 'Y' then 1 else 0 end [is_capital]
					, case when [is_Finance] = 'Y' then 1 else 0 end [is_Finance]
					, 0 [is_volumes]
					, 0 [is_valnav]
					,[zero_level]
					,src.[Hierarchy_Path]
					,[level]
					,'QBYTE' AS [source]
			  FROM [stage].[t_qbyte_account_hierarchy_source_finance] src
			  LEFT JOIN [dbo].[Parse_Hierarchy_Path] PHP
			    ON PHP.[Hierarchy_Path] = src.[Hierarchy_Path_desc] 
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
			  WHERE [account_group] in ('DEP')
			  AND gl_account is not null
) dep
--
ON 
fin_bs_is.account_id = dep.account_id
--
LEFT OUTER JOIN
--
-- TAXOP
(
SELECT 
					 RCHI.child_id_Revised as account_id
					,RPI.[parent_id_Revised] as [parent_id]
					,RCHA.[child_alias_Revised] as [child_alias]
					,[gl_account]
					,RGAD.[gl_account_description_Revised] as [gl_account_description]	
					,PHP.account_level_01 account_level_01_desc
					,PHP.account_level_02 account_level_02_desc
					,PHP.account_level_03 account_level_03_desc
					,PHP.account_level_04 account_level_04_desc
					,PHP.account_level_05 account_level_05_desc
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
					,PSK.account_level_01_sort_key account_level_01_sort_key
					,PSK.account_level_02_sort_key account_level_02_sort_key
					,PSK.account_level_03_sort_key account_level_03_sort_key
					,PSK.account_level_04_sort_key account_level_04_sort_key
					,PSK.account_level_05_sort_key account_level_05_sort_key
					, case when [is_leaseops] = 'Y' then 1 else 0 end [is_leaseops]
					, case when [is_capital] = 'Y' then 1 else 0 end [is_capital]
					, case when [is_Finance] = 'Y' then 1 else 0 end [is_Finance]
					, 0 [is_volumes]
					, 0 [is_valnav]
					,[zero_level]
					,src.[Hierarchy_Path]
					,[level]
					,'QBYTE' AS [source]
			  FROM [stage].[t_qbyte_account_hierarchy_source_finance]src
			  LEFT JOIN [dbo].[Parse_Hierarchy_Path] PHP
			    ON PHP.[Hierarchy_Path] = src.[Hierarchy_Path_desc] 
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
			  WHERE [account_group] in ('TAXOP')
			  AND gl_account is not null
) taxop
--
ON 
fin_bs_is.account_id = taxop.account_id
--
LEFT OUTER JOIN
--
-- GCART
(
SELECT 
					 RCHI.child_id_Revised as account_id
					,RPI.[parent_id_Revised] as [parent_id]
					,RCHA.[child_alias_Revised] as [child_alias]
					,[gl_account]
					,RGAD.[gl_account_description_Revised] as [gl_account_description]		
					,PHP.account_level_01 account_level_01_desc
					,PHP.account_level_02 account_level_02_desc
					,PHP.account_level_03 account_level_03_desc
					,PHP.account_level_04 account_level_04_desc
					,PHP.account_level_05 account_level_05_desc
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
					,PSK.account_level_01_sort_key account_level_01_sort_key
					,PSK.account_level_02_sort_key account_level_02_sort_key
					,PSK.account_level_03_sort_key account_level_03_sort_key
					,PSK.account_level_04_sort_key account_level_04_sort_key
					,PSK.account_level_05_sort_key account_level_05_sort_key
					, case when [is_leaseops] = 'Y' then 1 else 0 end [is_leaseops]
					, case when [is_capital] = 'Y' then 1 else 0 end [is_capital]
					, case when [is_Finance] = 'Y' then 1 else 0 end [is_Finance]
					, 0 [is_volumes]
					, 0 [is_valnav]
					,[zero_level]
					,src.[Hierarchy_Path]
					,[level]
					,'QBYTE' AS [source]
			  FROM [stage].[t_qbyte_account_hierarchy_source_finance] src
			  LEFT JOIN [dbo].[Parse_Hierarchy_Path] PHP
			    ON PHP.[Hierarchy_Path] = src.[Hierarchy_Path_desc] 
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
			  WHERE [account_group] in ('GCART')
			  AND gl_account is not null
) gcart
--
ON 
fin_bs_is.account_id = gcart.account_id
--
LEFT OUTER JOIN
--
-- ESTMA
(
SELECT 
					 RCHI.child_id_Revised as account_id
					,RPI.[parent_id_Revised] as [parent_id]
					,RCHA.[child_alias_Revised] as [child_alias]
					,[gl_account]
					,RGAD.[gl_account_description_Revised] as [gl_account_description]		
					,PHP.account_level_01 account_level_01_desc
					,PHP.account_level_02 account_level_02_desc
					,PHP.account_level_03 account_level_03_desc
					,PHP.account_level_04 account_level_04_desc
					,PHP.account_level_05 account_level_05_desc
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
					,PSK.account_level_01_sort_key account_level_01_sort_key
					,PSK.account_level_02_sort_key account_level_02_sort_key
					,PSK.account_level_03_sort_key account_level_03_sort_key
					,PSK.account_level_04_sort_key account_level_04_sort_key
					,PSK.account_level_05_sort_key account_level_05_sort_key
					, case when [is_leaseops] = 'Y' then 1 else 0 end [is_leaseops]
					, case when [is_capital] = 'Y' then 1 else 0 end [is_capital]
					, case when [is_Finance] = 'Y' then 1 else 0 end [is_Finance]
					, 0 [is_volumes]
					, 0 [is_valnav]
					,[zero_level]
					,src.[Hierarchy_Path]
					,[level]
					,'QBYTE' AS [source]
			  FROM [stage].[t_qbyte_account_hierarchy_source_finance]src
			  LEFT JOIN [dbo].[Parse_Hierarchy_Path] PHP
			    ON PHP.[Hierarchy_Path] = src.[Hierarchy_Path_desc] 
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
			  WHERE [account_group] in ('ESTMA')
			  AND gl_account is not null
) estma
--
ON 
fin_bs_is.account_id = estma.account_id;