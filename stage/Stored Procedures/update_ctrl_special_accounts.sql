CREATE PROC [stage].[update_ctrl_special_accounts] AS
BEGIN
	UPDATE stage.t_ctrl_special_accounts
	SET Hierarchy_Path_desc = 
		CONCAT(COALESCE(account_level_01 + '//', ''),
					COALESCE(account_level_02 + '//', ''),
					COALESCE(account_level_03 + '//', ''),
					COALESCE(account_level_04 + '//', ''),
					COALESCE(account_level_05 + '//', ''),
					COALESCE(account_level_06 + '//', ''),
					COALESCE(account_level_07 + '//', ''),
					COALESCE(account_level_08 + '//', ''),
					COALESCE(account_level_09 + '//', ''),
					COALESCE(account_level_10 + '//', ''))

	UPDATE stage.t_ctrl_special_accounts 
	set Hierarchy_Path_desc =NULL
	WHERE len(Hierarchy_Path_desc) = 0
	UPDATE stage.t_ctrl_special_accounts 
	set Hierarchy_Path_desc = SUBSTRING(Hierarchy_Path_desc,1,len(Hierarchy_Path_desc)-2)
	WHERE
		Hierarchy_Path_desc is not null

	SELECT 1
END