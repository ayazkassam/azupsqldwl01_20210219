CREATE VIEW [dbo].[v_dim_account_leaseops]
AS SELECT 
       --account_key
	   CASE WHEN [account_id] = 'Lease Operating Reporting' THEN 'Netback' else [account_id] end as [account_id]
	  ,CASE WHEN [parent_id] = 'Lease Operating Reporting' THEN 'Netback' else [parent_id] end as [parent_id]
      ,CASE WHEN [account_desc] = 'Lease Operating Reporting' THEN 'Netback' else [account_desc] end as [account_desc]
      ,CASE WHEN account_level_01 = 'Lease Operating Reporting' THEN 'Netback' else account_level_01 end as account_level_01
      ,account_level_02
	  ,gl_account
	  ,gl_account_description
      ,[account_level_03]
      ,[account_level_04]
      ,[account_level_05]
      ,null [account_formula]
      ,null [account_formula_property]
	   ,CASE WHEN upper(account_id) IN ('OPERATING EXPENSES','ROYALTIES')
		    THEN '-'
			ELSE '+'
	   END unary_operator
	 -- ,unary_operator
      ,[major_account]
	  ,[minor_account]
      ,[major_account_description]
      ,[major_class_code]
      ,[class_code_description]
      ,[product_code]
      ,	account_level_01_sort_key
	  ,account_level_02_sort_key
	  ,account_level_03_sort_key
	  ,account_level_04_sort_key
	  ,account_level_05_sort_key
      ,[source]
	from [data_mart].t_dim_account_hierarchy
	WHERE is_leaseops=1
	--where zero_level=1
	 UNION ALL
--
SELECT 
	  account_id,
	  parent_id,
		account_desc,
    	 account_level_01, 
         account_level_02, 
		 NULL as gl_account,
	  NULL as gl_account_description,
         account_level_03, 
         account_level_04, 
		 account_level_05, 
	    account_formula, 
		account_formula_property, 
		unary_operator,
        NULL major_account, 
		NULL minor_account,
		NULL major_account_description, 
		NULL major_class_code,
		NULL class_code_description, 
		NULL product_code, 
		account_level_01_sort_key
	    ,account_level_02_sort_key
	  ,account_level_03_sort_key
	  ,account_level_04_sort_key
	  ,account_level_05_sort_key
	 ,source
FROM     [stage].[t_ctrl_special_accounts]
WHERE is_leaseops=1;