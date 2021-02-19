CREATE VIEW [dbo].[v_dim_account_capital2]
AS SELECT account_id,
	parent_id,
	account_desc,
	account_level_01,
	account_level_02,
	account_level_03,
	account_level_04,
	account_level_05,
	null as account_formula,
	null as account_formula_property,
	'+' as unary_operator,
	major_account,
	minor_account,
	gl_account,
	major_account_description,
	major_class_code,
	class_code_description,
	product_code,
	source
	, coalesce(account_level_05_sort_key
			, account_level_04_sort_key
			, account_level_03_sort_key
			, account_level_02_sort_key
			, account_level_01_sort_key) as sort_key

from [data_mart].t_dim_account_hierarchy
WHERE is_capital = 1

union all

SELECT ctrl.account_id,
	ctrl.parent_id,
	ctrl.account_desc,
	ctrl.account_level_01,
	ctrl.account_level_02,
	ctrl.account_level_03,
	ctrl.account_level_04,
	ctrl.account_level_05,
	ctrl.account_formula,
	ctrl.account_formula_property,
	ctrl.unary_operator,
	acct.major_acct AS major_account,
	acct.minor_acct as minor_account,
	acct.gl_account,
	acct.major_account_description,
	acct.major_class_code,
	acct.class_code_description,
	acct.product_code,
	ctrl.source,
	RIGHT (REPLICATE ('0', 6) + ctrl.sort_key, 6) AS sort_key
FROM (SELECT * 
	FROM [stage].[t_ctrl_special_accounts] 
	WHERE is_capital = 1 
) ctrl
LEFT OUTER JOIN (SELECT a.major_acct,
					a.minor_acct,
					a.acct_desc,
					a.major_acct + '_' + a.minor_acct AS gl_account,
					COALESCE (ma.net_major_acct, a.major_acct) + '_' + a.minor_acct AS gl_net_account,
					[stage].InitCap (ma.major_acct_desc) AS major_account_description,
					ma.class_code AS major_class_code,
					[stage].InitCap (code.code_desc) AS class_code_description,
					a.prod_code AS product_code
				FROM [stage].[t_qbyte_accounts] a
				LEFT OUTER JOIN [stage].[t_qbyte_major_accounts] ma ON (a.major_acct = ma.major_acct)
				LEFT OUTER JOIN (SELECT * FROM [stage].[t_qbyte_codes] WHERE code_type_code LIKE 'CLASS_CODE') code ON (ma.class_code = code.code)
	) acct ON (ctrl.account_id = acct.gl_account)


--
UNION ALL
--
SELECT
       'Unknown Field Est Account' AS account_id,
       NULL AS parent_id,
       'Unknown Field Est Account' AS account_desc,
       NULL AS [account_level_01],
       NULL AS [account_level_02],
       NULL AS [account_level_03],
       NULL AS [account_level_04],
       NULL AS [account_level_05],
       NULL AS [account_formula],
       NULL AS [account_formula_property],
       '+' AS [unary_operator],
       NULL AS [major_account],
	   NULL AS minor_account,
	   NULL AS gl_account,
       NULL AS [major_account_description],
       NULL AS [major_class_code],
       NULL AS [class_code_description],
       NULL AS [product_code],
       'Various Cost Estimates' AS [source],
       '010000' AS [sort_key]
--
UNION ALL
--
/*
SELECT
       [gl_net_account] AS [account_id],
       'Unknown Field Est Account' AS [parent_id],
       [account_description] AS [account_desc],
       NULL AS [account_level_01],
       NULL AS [account_level_02],
       NULL AS [account_level_03],
       NULL AS [account_level_04],
       NULL AS [account_level_05],
       NULL AS [account_formula],
       NULL AS [account_formula_property],
       '+' AS [unary_operator],
       [major_acct] AS [major_account],
	   minor_acct as minor_account,
	   [gl_net_account] AS gl_account,
       [major_account_description],
       [major_class_code],
       [class_code_description],
       [product_code],
       'Various Cost Estimates' AS [source],
       RIGHT (REPLICATE ('0', 6) + CONVERT (VARCHAR (10),
                                            10000 + ROW_NUMBER ()
                                                       OVER (ORDER BY gl_net_account)
                                           ), 6
             ) AS [sort_key]
  FROM
       [stage].[v_acct_non_capital_expenditure]
 WHERE
       [gl_net_account] IS NOT NULL
--
UNION ALL
--
*/
SELECT
       '-1' AS account_id,
       'Unknown Field Est Account' AS parent_id,
       'Unspecified Account' AS account_desc,
       NULL AS [account_level_01],
       NULL AS [account_level_02],
       NULL AS [account_level_03],
       NULL AS [account_level_04],
       NULL AS [account_level_05],
       NULL AS [account_formula],
       NULL AS [account_formula_property],
       '+' AS [unary_operator],
       NULL AS [major_account],
	   NULL AS minor_account,
	   NULL AS gl_account,
       NULL AS [major_account_description],
       NULL AS [major_class_code],
       NULL AS [class_code_description],
       NULL AS [product_code],
       'Various Cost Estimates' AS [source],
       '999999' AS [sort_key];