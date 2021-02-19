CREATE VIEW [dbo].[v_dim_valnav_account]
AS SELECT  account_id,
	   parent_id,
	   account_desc,
	   account_formula,
	   account_formula_property,
	   unary_operator,
	   sort_key,
	   qbyte_major_minor,
	   afe_type,
	   is_valnav,
	   source
FROM [stage].t_ctrl_special_accounts
WHERE is_valnav=1;