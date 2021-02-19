CREATE PROC [data_mart].[LoadData_For_View_v_qbyte_account_hierarchy_source_finance] AS
  BEGIN
      IF OBJECT_ID('tempdb..#toplvl_finance') IS NOT NULL
        DROP TABLE #toplvl_finance	 

      CREATE TABLE #toplvl_finance WITH (DISTRIBUTION = ROUND_ROBIN)
        AS
       SELECT CAST (code_desc AS VARCHAR (500)) AS child_id
		   , CAST (' ' AS VARCHAR (500)) AS parent_id
		   , CAST (code_desc AS VARCHAR (500)) AS parent_alias
           , CAST (code_desc AS VARCHAR (500)) AS child_alias
		   , CAST (code_desc AS VARCHAR (500)) AS gl_account_description
           , CAST (NULL AS VARCHAR (50)) AS account_uda
           , CAST (NULL AS VARCHAR (100)) AS class_code_description
           , CAST (NULL AS VARCHAR (50)) AS product_uda
		   , CAST (NULL AS VARCHAR (50)) AS si_to_imp_conv_factor
		   , CAST (NULL AS VARCHAR (50)) AS boe_thermal
		   , CAST (NULL AS VARCHAR (50)) AS mcfe6_thermal
           , CAST (NULL AS VARCHAR (100)) AS product_description
           , CAST (NULL AS VARCHAR (25)) AS gross_or_net_code
           , CAST (code AS VARCHAR (50)) AS account_group
           , CAST ('0000' AS VARCHAR (4)) AS display_seq_num
           , CAST (NULL AS VARCHAR (50)) AS major_minor
           , CAST (NULL AS VARCHAR (4)) AS major_account
           , CAST (NULL AS VARCHAR (500)) AS major_account_description
           , CAST (NULL AS VARCHAR (4)) AS minor_account
           , CAST ('A00_' + CASE code                                                      
								WHEN 'PPECTY'  THEN '5'                                                      
								WHEN 'NRIREV'  THEN '4'                                                      
								WHEN 'WIREV'   THEN '3'                                                      
								WHEN 'BALSHT'  THEN '2'                                                      
								WHEN 'INCSTM'  THEN '1'                                                      
								WHEN 'LSEOP'   THEN '0' END AS VARCHAR (500)) AS sort_key            
			, CAST(0 AS INT) zero_level                                         
		FROM [stage].t_qbyte_codes                                                    
		WHERE code IN (select variable_value from stage.t_ctrl_etl_variables where variable_name = 'FINANCE_ACCOUNT_GROUPS')
		AND code_type_code = 'ACCT_GROUP_TYPE_CODE'                                                   
		
		UNION ALL
		--
		/************************************************************/ 
		/* Obtain Rollup Parent Accounts from acct group and rollup */ 
		/************************************************************/ 
		SELECT DISTINCT ag.acct_group_code AS child_id
			, c.code AS parent_id
			, c.code_desc as parent_alias
			, ag.acct_group_desc AS child_alias
			, ag.acct_group_desc AS gl_account_description
			, CAST (NULL AS VARCHAR (50)) AS account_uda
			, CAST (NULL AS VARCHAR (100)) AS class_code_description
			, CAST (NULL AS VARCHAR (50)) AS product_uda
			, CAST (NULL AS VARCHAR (50)) AS si_to_imp_conv_factor
			, CAST (NULL AS VARCHAR (50)) AS boe_thermal
			, CAST (NULL AS VARCHAR (50)) AS mcfe6_thermal
			, CAST (NULL AS VARCHAR (100)) AS product_description
			, CAST (NULL AS VARCHAR (25)) AS gross_or_net_code
			, ag.acct_group_type_code AS account_group
			, RIGHT (REPLICATE ('0', 4) + CAST (ag.display_seq_num AS VARCHAR), 4) AS display_seq_num
			, NULL AS major_minor
			, CAST (NULL AS VARCHAR (4)) AS major_account
			, CAST (NULL AS VARCHAR (50)) AS major_account_description
			, CAST (NULL AS VARCHAR (4)) AS minor_account
			, 'B' + REPLICATE ('0', 4) + CAST (ag.display_seq_num AS VARCHAR) AS sort_key
			,  CAST(0 AS INT) zero_level  
		FROM [stage].t_qbyte_account_groups ag
		join [stage].t_qbyte_account_group_rollups agr1 on ag.acct_group_code = agr1.rollup_acct_group_code
		join (	SELECT * FROM [stage].t_qbyte_codes 
				WHERE code_type_code = 'ACCT_GROUP_TYPE_CODE' 
			  ) c on ag.acct_group_type_code = c.code
		WHERE ag.acct_group_type_code IN (select variable_value from stage.t_ctrl_etl_variables where variable_name = 'FINANCE_ACCOUNT_GROUPS')
		AND agr1.rollup_acct_group_code NOT IN (SELECT  b.acct_group_code AS child_id 
												FROM [stage].t_qbyte_account_group_rollups b 
												WHERE b.acct_group_type_code = ag.acct_group_type_code)
		--
		UNION ALL
		--
		/******************************************************/ 
		/* Obtain Rollup Parent Accounts from acct group only */ 
		/******************************************************/ 
		SELECT ag.acct_group_code AS child_id
			, c.code AS parent_id
			, c.code_desc as parent_alias
			, REPLACE (ag.acct_group_desc, '(GAIN)', 'GAIN') AS alias
			, REPLACE (ag.acct_group_desc, '(GAIN)', 'GAIN') AS gl_account_description
			, CAST (NULL AS VARCHAR (50)) AS account_uda
			, CAST (NULL AS VARCHAR (100)) AS class_code_description
			, CAST (NULL AS VARCHAR (50)) AS product_uda
			, CAST (NULL AS VARCHAR (50)) AS si_to_imp_conv_factor
			, CAST (NULL AS VARCHAR (50)) AS boe_thermal
			, CAST (NULL AS VARCHAR (50)) AS mcfe6_thermal
			, CAST (NULL AS VARCHAR (100)) AS product_description
			, CAST (NULL AS VARCHAR (25)) AS gross_or_net_code
			, ag.acct_group_type_code AS account_group
			, RIGHT (REPLICATE ('0', 4) + CAST (ag.display_seq_num AS VARCHAR), 4) AS display_seq_num
			, NULL AS major_minor
			, CAST (NULL AS VARCHAR (4)) AS major_account
			, CAST (NULL AS VARCHAR (50)) AS major_account_description
			, CAST (NULL AS VARCHAR (4)) AS minor_account
			, 'B' + REPLICATE ('0', 4) + CAST (ag.display_seq_num AS VARCHAR) AS sort_key
			, CAST(0 AS INT) zero_level       
		FROM [stage].t_qbyte_account_groups ag
		join (	SELECT * FROM [stage].t_qbyte_codes 
				WHERE code_type_code = 'ACCT_GROUP_TYPE_CODE' 
			   ) c on ag.acct_group_type_code = c.code 
		WHERE ag.acct_group_type_code IN (select variable_value from stage.t_ctrl_etl_variables where variable_name = 'FINANCE_ACCOUNT_GROUPS')
		AND ag.acct_group_code + '_' + ag.acct_group_type_code 
				NOT IN (SELECT ag.acct_group_code + '_' + ag.acct_group_type_code AS child_code 
						FROM [stage].t_qbyte_account_groups ag
							, [stage].t_qbyte_account_group_rollups agr1 
						WHERE ag.acct_group_type_code IN (select variable_value from stage.t_ctrl_etl_variables where variable_name = 'FINANCE_ACCOUNT_GROUPS')
						AND ag.acct_group_code = agr1.rollup_acct_group_code 
						AND agr1.rollup_acct_group_code + '_' + agr1.acct_group_type_code
							NOT IN (SELECT b.acct_group_code + '_' + b.acct_group_type_code AS child_id 
									FROM [stage].t_qbyte_account_group_rollups b 
									WHERE b.acct_group_type_code = agr1.acct_group_type_code)
						
						UNION ALL
						
						SELECT ag1.acct_group_code + '_' + ag1.acct_group_type_code AS child_code
						FROM [stage].t_qbyte_account_group_rollups agr
							, [stage].t_qbyte_account_groups ag1
							, [stage].t_qbyte_account_groups ag2 
						WHERE agr.acct_group_type_code IN (select variable_value from stage.t_ctrl_etl_variables where variable_name = 'FINANCE_ACCOUNT_GROUPS')
						AND agr.acct_group_type_code = ag1.acct_group_type_code 
						AND agr.acct_group_type_code = ag2.acct_group_type_code 
						AND agr.acct_group_code = ag1.acct_group_code 
						AND agr.rollup_acct_group_code = ag2.acct_group_code)


      IF OBJECT_ID('tempdb..#secondlvl_finance') IS NOT NULL
        DROP TABLE #secondlvl_finance	 

      CREATE TABLE #secondlvl_finance WITH (DISTRIBUTION = ROUND_ROBIN)
        AS
		 SELECT DISTINCT CAST (ag1.acct_group_code AS VARCHAR(500)) AS child_id
			, CAST (ag2.acct_group_code AS VARCHAR(500)) AS parent_id
			, CAST (ag2.acct_group_desc AS VARCHAR(500)) AS parent_alias
			, REPLACE (ag1.acct_group_desc, '(GAIN)', 'GAIN') AS child_alias
			, REPLACE (ag1.acct_group_desc, '(GAIN)', 'GAIN') AS gl_account_description
			, CAST (NULL AS VARCHAR (50)) AS account_uda
			, CAST (NULL AS VARCHAR (100)) AS class_code_description
			, CAST (NULL AS VARCHAR (50)) AS product_uda
			, CAST (NULL AS VARCHAR (50)) AS si_to_imp_conv_factor
			, CAST (NULL AS VARCHAR (50)) AS boe_thermal
			, CAST (NULL AS VARCHAR (50)) AS mcfe6_thermal
			, CAST (NULL AS VARCHAR (100)) AS product_description
			, CAST (NULL AS VARCHAR (25)) AS gross_or_net_code
			, agr.acct_group_type_code AS account_group
			, RIGHT (REPLICATE ('0', 4) + CAST (ag1.display_seq_num AS VARCHAR), 4) AS display_seq_num
			, NULL AS major_minor
			, CAST (NULL AS VARCHAR (4)) AS major_account
			, CAST (NULL AS VARCHAR (50)) AS major_account_description
			, CAST (NULL AS VARCHAR (4)) AS minor_account
			, 'B' + REPLICATE ('0', 4) + CAST (ag1.display_seq_num AS VARCHAR) AS sort_key
			, CAST(0 AS INT) zero_level      
		FROM [stage].t_qbyte_account_group_rollups agr
			, [stage].t_qbyte_account_groups ag1
			, [stage].t_qbyte_account_groups ag2 
		WHERE agr.acct_group_type_code IN (select variable_value from stage.t_ctrl_etl_variables where variable_name = 'FINANCE_ACCOUNT_GROUPS')
		AND agr.acct_group_type_code = ag1.acct_group_type_code 
		AND agr.acct_group_type_code = ag2.acct_group_type_code 
		AND agr.acct_group_code = ag1.acct_group_code 
		AND agr.rollup_acct_group_code = ag2.acct_group_code 
		--
		UNION ALL
		--
		/***************************/ 
		/* Obtain Level 0 Accounts */ 
		/***************************/ 
		 SELECT CAST (child_id AS VARCHAR (500)) AS child_id
			, CAST (parent_id AS VARCHAR (500)) AS parent_id
			, CAST (parent_alias AS VARCHAR(500)) AS parent_alias
			, CAST (alias AS VARCHAR (500)) AS child_alias
			, CAST (gl_account_description AS VARCHAR (500)) AS gl_account_description
			, CAST (account_uda AS VARCHAR (50)) AS account_uda
			, CAST ((z.code_desc) AS VARCHAR (100)) AS class_code_description
			, CAST (product_uda AS VARCHAR (50)) AS product_uda
			, CAST (si_to_imp_conv_factor AS VARCHAR (50)) AS si_to_imp_conv_factor
			, CAST (boe_thermal AS VARCHAR (50)) AS boe_thermal
			, CAST (mcfe6_thermal AS VARCHAR (50)) AS mcfe6_thermal
			, CAST ((prod_name) AS VARCHAR (100)) AS product_description
			, CAST (gross_or_net_code AS VARCHAR (25)) AS gross_or_net_code
			, CAST (account_group AS VARCHAR (50)) AS account_group
			, CAST (display_seq_num AS VARCHAR (4)) AS display_seq_num
			, CAST (major_minor AS VARCHAR (50)) AS major_minor
			, CAST (major_account AS VARCHAR (4)) AS major_account
			, CAST (major_account_description AS VARCHAR (500)) AS major_account_description
			, CAST (minor_account AS VARCHAR (4)) AS minor_account
			, CAST (sort_key AS VARCHAR (500)) AS sort_key
			, CAST (1 AS INT) zero_level    
		FROM (
				/************************************************************/ 
				/* Obtain Level 0 Accounts for Accounts in the Rollup Table */ 
				/************************************************************/
				SELECT DISTINCT CAST (ag.acct_group_code AS VARCHAR(500)) AS parent_id
					, CAST (ag.acct_group_desc AS VARCHAR(500)) AS parent_alias
					, a.major_acct + '_' + a.minor_acct AS child_id
					, coalesce(a.acct_desc, 'UNKNOWN') + ' (' + a.major_acct + '_' + a.minor_acct + ')' AS alias
					, coalesce(a.acct_desc, 'UNKNOWN') AS gl_account_description
					, mj.class_code AS account_uda
					, a.prod_code AS product_uda
					, mj.gross_or_net_code AS gross_or_net_code
					, ag.acct_group_type_code AS account_group
					, RIGHT (REPLICATE ('0', 4) + CAST (ag.display_seq_num AS VARCHAR), 4) AS display_seq_num
					, a.major_acct + '_' + a.minor_acct AS major_minor
					, mj.major_acct AS major_account
					, a.minor_acct AS minor_account
					, (mj.major_acct_desc) + CASE WHEN mj.major_acct IS NOT NULL THEN '(' + mj.major_acct + ')'  ELSE '' END AS major_account_description
					, 'C' + REPLICATE ('0', 4) + CAST (ag.display_seq_num AS VARCHAR(4)) + '.' + a.major_acct + '_' + REPLICATE ('0', 3) + CAST(a.minor_acct AS VARCHAR) AS sort_key 
				FROM [stage].t_qbyte_account_groups ag
				--
				INNER JOIN [stage].t_qbyte_account_group_accounts aga 
					ON ag.acct_group_type_code = aga.acct_group_type_code
					AND ag.acct_group_code = aga.acct_group_code
				--
				INNER JOIN (SELECT acct_group_type_code, rollup_acct_group_code, acct_group_code 
							FROM [stage].t_qbyte_account_group_rollups 
					) agr
					ON ag.acct_group_type_code = agr.acct_group_type_code
					AND ag.acct_group_code = agr.acct_group_code
				--
				INNER JOIN [stage].t_qbyte_accounts a
					ON aga.major_acct = a.major_acct
					AND aga.minor_acct = a.minor_acct
				--
				LEFT OUTER JOIN [stage].t_qbyte_major_accounts mj
					ON aga.major_acct = mj.major_acct
				--
				WHERE ag.acct_group_type_code IN (select variable_value from stage.t_ctrl_etl_variables where variable_name = 'FINANCE_ACCOUNT_GROUPS')
				AND ag.rollup_acct_group_flag = 'N'
				AND mj.GROSS_OR_NET_CODE = 'N'
				-- 
				UNION
				--
				/*******************************************************************/
				/* Obtain Level 0 Accounts for Acct Groups not in the Rollup Table */
				/*******************************************************************/
				SELECT DISTINCT CAST (ag.acct_group_code AS VARCHAR(500)) AS parent_id
					, CAST (ag.acct_group_desc AS VARCHAR(500)) AS parent_alias
					, a.major_acct + '_' + a.minor_acct AS child_id
					, coalesce(a.acct_desc, 'UNKNOWN') + ' (' + a.major_acct + '_' + a.minor_acct + ')' AS alias
					, coalesce(a.acct_desc, 'UNKNOWN') AS gl_account_description
					, mj.class_code AS account_uda
					, a.prod_code AS product_uda
					, mj.gross_or_net_code AS gross_or_net_code
					, ag.acct_group_type_code AS account_group
					, RIGHT (REPLICATE ('0', 4) + CAST (ag.display_seq_num AS VARCHAR), 4) AS display_seq_num
					, a.major_acct + '_' + a.minor_acct AS major_minor
					, mj.major_acct AS major_account
					, (mj.major_acct_desc) + CASE WHEN mj.major_acct IS NOT NULL THEN ' (' + mj.major_acct + ')' ELSE '' END AS major_account_description
					, a.minor_acct AS minor_account
					, 'C' + REPLICATE ('0', 4) + CAST(ag.display_seq_num AS VARCHAR) + '.' + a.major_acct + '_' + REPLICATE ('0', 3) + CAST(a.minor_acct AS VARCHAR) AS sort_key 
				FROM [stage].t_qbyte_account_groups ag
				--
				INNER JOIN [stage].t_qbyte_account_group_accounts aga
					ON ag.acct_group_type_code = aga.acct_group_type_code
					AND ag.acct_group_code = aga.acct_group_code
				--
				INNER JOIN [stage].t_qbyte_accounts a
					ON aga.major_acct = a.major_acct
					AND aga.minor_acct = a.minor_acct
				--
				LEFT OUTER JOIN [stage].t_qbyte_major_accounts mj
					ON aga.major_acct = mj.major_acct
				--
				WHERE ag.acct_group_type_code IN (select variable_value from stage.t_ctrl_etl_variables where variable_name = 'FINANCE_ACCOUNT_GROUPS')
				AND ag.rollup_acct_group_flag = 'N'
				AND mj.gross_or_net_code = 'N'
				AND ag.acct_group_code + '_' + ag.acct_group_type_code
					NOT IN (SELECT ag1.acct_group_code + '_' + ag1.acct_group_type_code AS child_id
							FROM [stage].t_qbyte_account_group_rollups agr
								, [stage].t_qbyte_account_groups ag1
								, [stage].t_qbyte_account_groups ag2 
							WHERE agr.acct_group_type_code IN (select variable_value from stage.t_ctrl_etl_variables where variable_name = 'FINANCE_ACCOUNT_GROUPS')
							AND agr.acct_group_type_code = ag1.acct_group_type_code
							AND agr.acct_group_type_code = ag2.acct_group_type_code
							AND agr.acct_group_code = ag1.acct_group_code
							AND agr.rollup_acct_group_code = ag2.acct_group_code)
		) x
	LEFT OUTER JOIN [stage].t_qbyte_products y ON x.product_uda = y.prod_code
	LEFT OUTER JOIN (	SELECT  * FROM  [stage].t_qbyte_codes
						WHERE  code_type_code = 'CLASS_CODE') z ON x.account_uda = z.code



    IF OBJECT_ID('[dbo].[CTE_v_qbyte_account_hierarchy_source_finance]') IS NOT NULL    
      TRUNCATE TABLE [dbo].[CTE_v_qbyte_account_hierarchy_source_finance]
    
    INSERT INTO [dbo].[CTE_v_qbyte_account_hierarchy_source_finance]
	SELECT CAST (child_id AS VARCHAR (500)) AS child_id
		, CAST (parent_id AS VARCHAR (500)) AS parent_id
		, CAST (child_alias AS VARCHAR(500)) AS child_alias
		, CAST (parent_alias AS VARCHAR(500)) AS parent_alias
		, CAST (gl_account_description AS VARCHAR(500)) AS gl_account_description
		, account_uda
		, class_code_description
		, product_uda
		, si_to_imp_conv_factor
		, boe_thermal
		, mcfe6_thermal
		, product_description
		, gross_or_net_code
		, CAST (account_group AS VARCHAR (50)) AS account_group
		, display_seq_num
		, CAST (major_minor AS VARCHAR (50)) AS major_minor
		, major_account
		, major_account_description 
		, minor_account
		, CAST (CASE WHEN LTRIM (RTRIM ([parent_id])) <> '' THEN '000000 // ' ELSE '' END + LTRIM (RTRIM (display_seq_num)) AS VARCHAR (500)) AS sort_key
		, zero_level   
		, CONVERT (NVARCHAR (1000), case when ltrim(rtrim(parent_id)) <> '' then parent_id + ' // ' else '' end + LTRIM(RTRIM(child_id))) AS [Hierarchy_Path]
		, CONVERT (NVARCHAR (1000), case when ltrim(rtrim(parent_id)) <> '' then parent_alias + ' // ' else '' end + LTRIM(RTRIM(child_alias))) AS Hierarchy_Path_Desc
		, 1 as level
    FROM #toplvl_finance

    -------------------------------------- 
	DECLARE @counter INT = 1;

	WHILE EXISTS (
	SELECT *
	from #secondlvl_finance child
	join [dbo].[CTE_v_qbyte_account_hierarchy_source_finance] parent 
		on child.parent_id = parent.child_id AND
		   child.account_group = parent.account_group
		WHERE parent.level = @counter
		)

	BEGIN
-- Insert next level
		INSERT INTO [dbo].[CTE_v_qbyte_account_hierarchy_source_finance] 

		SELECT CAST (child.child_id AS VARCHAR (500)) AS child_id
			, CAST (child.parent_id AS VARCHAR (500)) AS parent_id
			, CAST (child.child_alias AS VARCHAR(500)) AS child_alias
			, CAST (child.parent_alias AS VARCHAR(500)) AS parent_alias
			, CAST (child.gl_account_description AS VARCHAR(500)) AS gl_account_description
			, child.account_uda
			, child.class_code_description
			, child.product_uda
			, child.si_to_imp_conv_factor
			, child.boe_thermal
			, child.mcfe6_thermal
			, child.product_description
			, child.gross_or_net_code
			, CAST (child.account_group AS VARCHAR (50)) AS account_group
			, child.display_seq_num
			, CAST (child.major_minor AS VARCHAR (50)) AS major_minor
			, child.major_account
			, child.major_account_description
			, child.minor_account
			, CAST (  CONVERT (NVARCHAR (1000), parent.sort_key + ' // ' + LTRIM (RTRIM (child.display_seq_num))) AS VARCHAR (500)) AS sort_key
			, child.zero_level
			, CONVERT (NVARCHAR (1000),parent.[Hierarchy_Path] + ' // ' + LTRIM (RTRIM (child.child_id))) AS [Hierarchy_Path]
			, CONVERT (NVARCHAR (1000),parent.[Hierarchy_Path_desc] + ' // ' + LTRIM (RTRIM (child.child_alias))) AS Hierarchy_Path_desc
			, @counter + 1 AS level
		FROM #secondlvl_finance child
		inner join [dbo].[CTE_v_qbyte_account_hierarchy_source_finance] parent 
		  ON  child.parent_id = parent.child_id AND
		      child.account_group = parent.account_group
        WHERE parent.level = @counter;

		SET @counter += 1;

		-- Loop safety
		IF @counter > 99
		BEGIN 
			RAISERROR( 'Too many loops!', 16, 1 ) 
			BREAK 
		END;
	END

	SELECT 1
END