CREATE PROC [data_mart].[full_afe_facts] AS
BEGIN
  -- SET NOCOUNT ON added to prevent extra result sets from
  -- interfering with SELECT statements.
  SET NOCOUNT ON;

  DECLARE @v_Job_Name     AS NVARCHAR (200) = '[data_mart].[full_afe_facts]',
          --
          @v_Message      AS NVARCHAR (2000), -- General information about the job
          @v_InfoText     AS NVARCHAR (4000), -- Detailed information about the job
          --
          @v_Load_Date    AS DATETIME,
          @v_Start_Date   AS DATETIME,
          @v_End_Date     AS DATETIME,
          --
          @v_before_count AS INT,
          @v_after_count  AS INT

  BEGIN TRY

    SET @v_Start_Date = GETDATE ();

   -- SET @p_Row_Count  = 0;

    SET @v_Message    = 'Refresh initiated on ' + CONVERT (NVARCHAR, @v_Start_Date);
    SET @v_InfoText   =   'This job refreshes the [data_mart].[t_fact_afe] table from various conformed'
                        + ' views pulling from different source systems...';

    --BEGIN TRANSACTION          
    
      DELETE
        FROM [data_mart].[t_fact_afe]
      WHERE
        [data_source] IN 
	                (
	                 'QByte',
                        'AFENavigator',
                        'WellView',
                        'SiteView'
                       );
    
    --COMMIT TRANSACTION

   -- BEGIN TRANSACTION

      SET @v_Load_Date = GETDATE ();
     

      IF OBJECT_ID('tempdb..#t_fact_afe_MERGE') IS NOT NULL
        DROP TABLE #t_fact_afe_MERGE	 

      CREATE TABLE #t_fact_afe_MERGE WITH (DISTRIBUTION = ROUND_ROBIN)
        AS
          SELECT
		    'NEW' Flag,
            src.[scenario_key]
            + '.' + src.[gross_net_indicator]
            + '.' + CONVERT (NVARCHAR, src.[activity_month_key])
            + '.' + CONVERT (NVARCHAR, src.[accounting_month_key])
            + '.' + CONVERT (NVARCHAR, src.[afe_id])
            + '.' + CONVERT (NVARCHAR, src.[entity_id])
            + '.' + src.[account_key] AS [transaction_pk],
            src.[afe_id],
            src.[afe_number],
            src.[activity_month_key] AS [activity_period_id],
            src.[accounting_month_key] AS [accounting_period_id],
            src.[entity_id],
            src.[cc_number],
            src.[uwi],
            src.[account_key] AS [gl_account],
            src.[afe_type],
            src.[afe_job_type_id] AS [afe_job_type],
            src.[afe_job_status_id] AS [afe_job_status],
            src.[organization_key] AS [org_ba_id],
            src.[vendor_key] AS [vendor_ba_id],
            src.[scenario_key] AS [scenario],
            'QByte' AS [data_source],
            src.[gross_net_indicator],
            src.[project_id],
            CAST (NULL AS float) AS [head_count],
            CAST (NULL AS float) AS [duration_of_work],
            CAST (NULL AS float) AS [number_of_reports],
            CAST (NULL AS float) AS [number_of_permits],
            src.[cad] AS [cdn_dollars],
            src.[usd] AS [us_dollars],
            src.[net_working_interest],
            'I' AS [etl_status]
          FROM
            [stage].[v_fact_source_cost_actuals_qbyte] src
          LEFT JOIN [data_mart].[t_fact_afe] trg
	        ON trg.afe_id = src.afe_id AND
               trg.entity_id             = src.entity_id AND
               trg.activity_period_id    = src.[activity_month_key] AND
               trg.accounting_period_id  = src.[accounting_month_key] AND
               trg.gl_account            = src.[account_key] AND
               trg.gross_net_indicator   = src.gross_net_indicator AND
               trg.scenario              = src.[scenario_key]
          WHERE
		    trg.afe_id IS NULL AND 
			trg.entity_id IS NULL AND           
			trg.activity_period_id IS NULL AND  
			trg.accounting_period_id IS NULL AND
			trg.gl_account IS NULL AND     
			trg.gross_net_indicator IS NULL AND
			trg.scenario IS NULL           
			
          UNION ALL

          SELECT
		    'UPDATE' Flag,
            src.[transaction_pk],
            src.[afe_id],
            src.[afe_number],
            src.[activity_period_id],
            src.[accounting_period_id],
            src.[entity_id],
            src.[cc_number],
            src.[uwi],
            src.[gl_account],
            src.[afe_type],
            src.[afe_job_type],
            src.[afe_job_status],
            src.[org_ba_id],
            src.[vendor_ba_id],
            src.[scenario],
            src.[data_source],
            src.[gross_net_indicator],
            src.[project_id],
            src.[head_count],
            src.[duration_of_work],
            src.[number_of_reports],
            src.[number_of_permits],
            src.[cdn_dollars],
            src.[us_dollars],
            src.[net_working_interest],
            src.[etl_status]
          FROM
            (
               SELECT
                  src.[scenario_key]
                  + '.' + src.[gross_net_indicator]
                  + '.' + CONVERT (NVARCHAR, src.[activity_month_key])
                  + '.' + CONVERT (NVARCHAR, src.[accounting_month_key])
                  + '.' + CONVERT (NVARCHAR, src.[afe_id])
                  + '.' + CONVERT (NVARCHAR, src.[entity_id])
                  + '.' + src.[account_key] AS [transaction_pk],
                  src.[afe_id],
                  src.[afe_number],
                  src.[activity_month_key] AS [activity_period_id],
                  src.[accounting_month_key] AS [accounting_period_id],
                  src.[entity_id],
                  src.[cc_number],
                  src.[uwi],
                  src.[account_key] AS [gl_account],
                  src.[afe_type],
                  src.[afe_job_type_id] AS [afe_job_type],
                  src.[afe_job_status_id] AS [afe_job_status],
                  src.[organization_key] AS [org_ba_id],
                  src.[vendor_key] AS [vendor_ba_id],
                  src.[scenario_key] AS [scenario],
                  'QByte' AS [data_source],
                  src.[gross_net_indicator],
                  src.[project_id],
                  CAST (NULL AS float) AS [head_count],
                  CAST (NULL AS float) AS [duration_of_work],
                  CAST (NULL AS float) AS [number_of_reports],
                  CAST (NULL AS float) AS [number_of_permits],
                  src.[cad] AS [cdn_dollars],
                  src.[usd] AS [us_dollars],
                  src.[net_working_interest],
                  'I' AS [etl_status]
                FROM
                  [stage].[v_fact_source_cost_actuals_qbyte] src
                INNER JOIN [data_mart].[t_fact_afe] trg
	              ON trg.afe_id = src.afe_id AND
                     trg.entity_id             = src.entity_id AND
                     trg.activity_period_id    = src.[activity_month_key] AND
                     trg.accounting_period_id  = src.[accounting_month_key] AND
                     trg.gl_account            = src.[account_key] AND
                     trg.gross_net_indicator   = src.gross_net_indicator AND
                     trg.scenario              = src.[scenario_key]

                EXCEPT

                SELECT
                  trg.[scenario]
                  + '.' + trg.[gross_net_indicator]
                  + '.' + CONVERT (NVARCHAR, trg.[activity_period_id])
                  + '.' + CONVERT (NVARCHAR, trg.[accounting_period_id])
                  + '.' + CONVERT (NVARCHAR, trg.[afe_id])
                  + '.' + CONVERT (NVARCHAR, trg.[entity_id])
                  + '.' + trg.[gl_account] AS [transaction_pk],
                  trg.[afe_id],
                  trg.[afe_number],
                  trg.[activity_period_id],
                  trg.[accounting_period_id],
                  trg.[entity_id],
                  trg.[cc_number],
                  trg.[uwi],
                  trg.[gl_account],
                  trg.[afe_type],
                  trg.[afe_job_type],
                  trg.[afe_job_status] ,
                  trg.[org_ba_id] AS [organization_key],
                  trg.[vendor_ba_id],
                  trg.[scenario],
                  'QByte' AS [data_source],
                  trg.[gross_net_indicator],
                  trg.[project_id],
                  CAST (NULL AS float) AS [head_count],
                  CAST (NULL AS float) AS [duration_of_work],
                  CAST (NULL AS float) AS [number_of_reports],
                  CAST (NULL AS float) AS [number_of_permits],
                  trg.[cdn_dollars],
                  trg.[us_dollars],
                  trg.[net_working_interest],
                  'I' AS [etl_status]
                FROM
                  [data_mart].[t_fact_afe] trg
			) src


      INSERT INTO [data_mart].[t_fact_afe]
	    (
           [transaction_pk],
           [afe_id],
           [afe_number],
           [activity_period_id],
           [accounting_period_id],
           [entity_id],
           [cc_number],
           [uwi],
           [gl_account],
           [afe_type],
           [afe_job_type],
           [afe_job_status],
           [org_ba_id],
           [vendor_ba_id],
           [scenario],
           [data_source],
           [gross_net_indicator],
           [project_id],
           [head_count],
           [duration_of_work],
           [number_of_reports],
           [number_of_permits],
           [cdn_dollars],
           [us_dollars],
           [net_working_interest],
           --[transaction_last_load_id],
           [transaction_last_load_date],
           [etl_status]
		)
        SELECT
          src.[transaction_pk],
          src.[afe_id],
          src.[afe_number],
          src.[activity_period_id],
          src.[accounting_period_id],
          src.[entity_id],
          src.[cc_number],
          src.[uwi],
          src.[gl_account],
          src.[afe_type],
          src.[afe_job_type],
          src.[afe_job_status],
          src.[org_ba_id],
          src.[vendor_ba_id],
          src.[scenario],
          src.[data_source],
          src.[gross_net_indicator],
          src.[project_id],
          src.[head_count],
          src.[duration_of_work],
          src.[number_of_reports],
          src.[number_of_permits],
          src.[cdn_dollars],
          src.[us_dollars],
          src.[net_working_interest],
		  GETDATE(), --[transaction_last_load_date]
          src.[etl_status]
		FROM
		  #t_fact_afe_MERGE src
		WHERE
		  Flag = 'NEW'

	  -------- ROW_COUNT
	  --DECLARE  @rowcnt INT
	  --EXEC [dbo].[LastRowCount] @rowcnt OUTPUT	

	  UPDATE [data_mart].[t_fact_afe]
      SET 
        [data_mart].[t_fact_afe].[afe_number]                 = UPD.[afe_number],
        [data_mart].[t_fact_afe].[cc_number]                  = UPD.[cc_number],
        [data_mart].[t_fact_afe].[uwi]                        = UPD.[uwi],
        [data_mart].[t_fact_afe].[afe_type]                   = UPD.[afe_type],
        [data_mart].[t_fact_afe].[afe_job_type]               = UPD.[afe_job_type],
        [data_mart].[t_fact_afe].[afe_job_status]             = UPD.[afe_job_status],
        [data_mart].[t_fact_afe].[org_ba_id]                  = UPD.[org_ba_id],
        [data_mart].[t_fact_afe].[vendor_ba_id]               = UPD.[vendor_ba_id],
        [data_mart].[t_fact_afe].[data_source]                = UPD.[data_source],
        [data_mart].[t_fact_afe].[project_id]                 = UPD.[project_id],
        [data_mart].[t_fact_afe].[head_count]                 = UPD.[head_count],
        [data_mart].[t_fact_afe].[duration_of_work]           = UPD.[duration_of_work],
        [data_mart].[t_fact_afe].[number_of_reports]          = UPD.[number_of_reports],
        [data_mart].[t_fact_afe].[number_of_permits]          = UPD.[number_of_permits],
        [data_mart].[t_fact_afe].[cdn_dollars]                = UPD.[cdn_dollars],
        [data_mart].[t_fact_afe].[us_dollars]                 = UPD.[us_dollars],
        [data_mart].[t_fact_afe].[net_working_interest]       = UPD.[net_working_interest],
        [data_mart].[t_fact_afe].[transaction_last_load_date] = GETDATE (), --src.[transaction_last_load_date]
        [data_mart].[t_fact_afe].[etl_status]                 = UPD.[etl_status]
      FROM #t_fact_afe_MERGE UPD
	  WHERE
	    [data_mart].[t_fact_afe].afe_id = UPD.afe_id AND
        [data_mart].[t_fact_afe].entity_id             = UPD.entity_id AND
        [data_mart].[t_fact_afe].activity_period_id    = UPD.activity_period_id AND
        [data_mart].[t_fact_afe].accounting_period_id  = UPD.accounting_period_id AND
        [data_mart].[t_fact_afe].gl_account            = UPD.gl_account AND
        [data_mart].[t_fact_afe].gross_net_indicator   = UPD.gross_net_indicator AND
        [data_mart].[t_fact_afe].scenario              = UPD.scenario AND
	    UPD.Flag = 'UPDATE'	

     --SET @p_Row_Count = @p_Row_Count + @@ROWCOUNT

   -- COMMIT TRANSACTION

    SET @v_Message  = 'Merge 1 of 5 complete.';
    SET @v_InfoText =   'Upsert of [data_mart].[v_fact_source_cost_actuals_qbyte] cost estimate transactions complete '
                       + '(Elapsed Time: '
                       + CONVERT (NVARCHAR, (FLOOR (DATEDIFF (hh, GETDATE (), @v_Load_Date)) % 24)) + ' hrs, '
                       + CONVERT (NVARCHAR, (FLOOR (DATEDIFF (mi, GETDATE (), @v_Load_Date)) % 60)) + ' min, '
                       + CONVERT (NVARCHAR, (FLOOR (DATEDIFF (ss, GETDATE (), @v_Load_Date)) % 60)) + ' sec)...';
     
    --BEGIN TRANSACTION

      SET @v_Load_Date = GETDATE ();     
	 
      IF OBJECT_ID('tempdb..#t_fact_afe_MERGE') IS NOT NULL
        DROP TABLE #t_fact_afe_MERGE	 

      CREATE TABLE #t_fact_afe_MERGE WITH (DISTRIBUTION = ROUND_ROBIN)
        AS
          SELECT
		    'NEW' Flag,
            src.[scenario]
            + '.' + src.[grs_net]
            + '.' + CONVERT (NVARCHAR, src.[actvy_per_id])
            + '.' + CONVERT (NVARCHAR, src.[afe_id])
            + '.' + CONVERT (NVARCHAR, src.[entity_id])
            + '.' + src.[gl_net_account] AS [transaction_pk],
            src.[afe_id],
            src.[afe_number],
            src.[actvy_per_id] AS [activity_period_id],
            src.[acct_per_id] AS [accounting_period_id],
            src.[entity_id],
            src.[cc_number],
            src.[uwi],
            src.[gl_net_account] AS [gl_account],
            src.[afe_type],
            src.[afe_job_type_id] AS [afe_job_type],
            src.[afe_job_status_id] AS [afe_job_status],
            src.[org_id] AS [org_ba_id],
            src.[scenario],
            'QByte' AS [data_source],
            src.[grs_net] AS [gross_net_indicator],
            src.[project_id],
            CAST (NULL AS float) AS [head_count],
            CAST (NULL AS float) AS [duration_of_work],
            CAST (NULL AS float) AS [number_of_reports],
            CAST (NULL AS float) AS [number_of_permits],
            src.[can_dollar_amt] AS [cdn_dollars],
            src.[us_dollar_amt] AS [us_dollars],
            src.[net_working_interest],
            'I' AS [etl_status]
          FROM
            [stage].[v_fact_source_cost_estimates_qbyte] src
          LEFT JOIN [data_mart].[t_fact_afe] AS trg
		    ON trg.afe_id              = src.afe_id AND
               trg.entity_id           = src.entity_id AND
               trg.activity_period_id  = src.[actvy_per_id] AND
               trg.gl_account          = src.[gl_net_account] AND
               trg.gross_net_indicator = src.[grs_net] AND
               trg.scenario            = src.scenario
          WHERE
		    trg.afe_id IS NULL AND 
			trg.entity_id IS NULL AND           
			trg.activity_period_id IS NULL AND  
			trg.gl_account IS NULL AND     
			trg.gross_net_indicator IS NULL AND
			trg.scenario IS NULL 
			
          UNION ALL

          SELECT
		    'UPDATE' Flag,
            src.[transaction_pk],
            src.[afe_id],
            src.[afe_number],
            src.[activity_period_id],
            src.[accounting_period_id],
            src.[entity_id],
            src.[cc_number],
            src.[uwi],
            src.[gl_account],
            src.[afe_type],
            src.[afe_job_type],
            src.[afe_job_status],
            src.[org_ba_id],
            src.[scenario],
            src.[data_source],
            src.[gross_net_indicator],
            src.[project_id],
            src.[head_count],
            src.[duration_of_work],
            src.[number_of_reports],
            src.[number_of_permits],
            src.[cdn_dollars],
            src.[us_dollars],
            src.[net_working_interest],
            src.[etl_status]
          FROM
		    (
               SELECT
                 src.[scenario]
                 + '.' + src.[grs_net]
                 + '.' + CONVERT (NVARCHAR, src.[actvy_per_id])
                 + '.' + CONVERT (NVARCHAR, src.[afe_id])
                 + '.' + CONVERT (NVARCHAR, src.[entity_id])
                 + '.' + src.[gl_net_account] AS [transaction_pk],
                 src.[afe_id],
                 src.[afe_number],
                 src.[actvy_per_id] AS [activity_period_id],
                 src.[acct_per_id] AS [accounting_period_id],
                 src.[entity_id],
                 src.[cc_number],
                 src.[uwi],
                 src.[gl_net_account] AS [gl_account],
                 src.[afe_type],
                 src.[afe_job_type_id] AS [afe_job_type],
                 src.[afe_job_status_id] AS [afe_job_status],
                 src.[org_id] AS [org_ba_id],
                 src.[scenario],
                 'QByte' AS [data_source],
                 src.[grs_net] AS [gross_net_indicator],
                 src.[project_id],
                 CAST (NULL AS float) AS [head_count],
                 CAST (NULL AS float) AS [duration_of_work],
                 CAST (NULL AS float) AS [number_of_reports],
                 CAST (NULL AS float) AS [number_of_permits],
                 src.[can_dollar_amt] AS [cdn_dollars],
                 src.[us_dollar_amt] AS [us_dollars],
                 src.[net_working_interest],
                 'I' AS [etl_status]
               FROM
                 [stage].[v_fact_source_cost_estimates_qbyte] src
               INNER JOIN [data_mart].[t_fact_afe] AS trg
		         ON trg.afe_id              = src.afe_id AND
                    trg.entity_id           = src.entity_id AND
                    trg.activity_period_id  = src.[actvy_per_id] AND
                    trg.gl_account          = src.[gl_net_account] AND
                    trg.gross_net_indicator = src.[grs_net] AND
                    trg.scenario            = src.scenario

               EXCEPT

               SELECT
                 trg.[scenario]
                 + '.' + trg.[gross_net_indicator]
                 + '.' + CONVERT (NVARCHAR, trg.[activity_period_id])
                 + '.' + CONVERT (NVARCHAR, trg.[afe_id])
                 + '.' + CONVERT (NVARCHAR, trg.[entity_id])
                 + '.' + trg.gl_account AS [transaction_pk],
                 trg.[afe_id],
                 trg.[afe_number],
                 trg.[activity_period_id],
                 trg.[accounting_period_id],
                 trg.[entity_id],
                 trg.[cc_number],
                 trg.[uwi],
                 trg.[gl_account],
                 trg.[afe_type],
                 trg.[afe_job_type],
                 trg.[afe_job_status],
                 trg.[org_ba_id],
                 trg.[scenario],
                 'QByte' AS [data_source],
                 trg.[gross_net_indicator],
                 trg.[project_id],
                 CAST (NULL AS float) AS [head_count],
                 CAST (NULL AS float) AS [duration_of_work],
                 CAST (NULL AS float) AS [number_of_reports],
                 CAST (NULL AS float) AS [number_of_permits],
                 trg.[cdn_dollars],
                 trg.[us_dollars],
                 trg.[net_working_interest],
                 'I' AS [etl_status]
               FROM
                 [data_mart].[t_fact_afe] AS trg
			) src
       
      INSERT INTO [data_mart].[t_fact_afe]
	    (
           [transaction_pk],
           [afe_id],
           [afe_number],
           [activity_period_id],
           [accounting_period_id],
           [entity_id],
           [cc_number],
           [uwi],
           [gl_account],
           [afe_type],
           [afe_job_type],
           [afe_job_status],
           [org_ba_id],
           [scenario],
           [data_source],
           [gross_net_indicator],
           [project_id],
           [head_count],
           [duration_of_work],
           [number_of_reports],
           [number_of_permits],
           [cdn_dollars],
           [us_dollars],
           [net_working_interest],
           [transaction_last_load_date],
           [etl_status]		
		)
		SELECT
          src.[transaction_pk],
          src.[afe_id],
          src.[afe_number],
          src.[activity_period_id],
          src.[accounting_period_id],
          src.[entity_id],
          src.[cc_number],
          src.[uwi],
          src.[gl_account],
          src.[afe_type],
          src.[afe_job_type],
          src.[afe_job_status],
          src.[org_ba_id],
          src.[scenario],
          src.[data_source],
          src.[gross_net_indicator],
          src.[project_id],
          src.[head_count],
          src.[duration_of_work],
          src.[number_of_reports],
          src.[number_of_permits],
          src.[cdn_dollars],
          src.[us_dollars],
          src.[net_working_interest],
		  GETDATE (), --[transaction_last_load_date]
          src.[etl_status]
        FROM
		  #t_fact_afe_MERGE src
        WHERE
		  Flag = 'NEW'

	  -------- ROW_COUNT
	  --DECLARE  @rowcnt INT
	  --EXEC [dbo].[LastRowCount] @rowcnt OUTPUT	

	  UPDATE [data_mart].[t_fact_afe]
      SET 
	    [data_mart].[t_fact_afe].[transaction_pk]             = UPD.[transaction_pk],
        [data_mart].[t_fact_afe].[afe_number]                 = UPD.[afe_number],
        [data_mart].[t_fact_afe].[cc_number]                  = UPD.[cc_number],
        [data_mart].[t_fact_afe].[uwi]                        = UPD.[uwi],
        [data_mart].[t_fact_afe].[afe_type]                   = UPD.[afe_type],
        [data_mart].[t_fact_afe].[afe_job_type]               = UPD.[afe_job_type],
        [data_mart].[t_fact_afe].[afe_job_status]             = UPD.[afe_job_status],
        [data_mart].[t_fact_afe].[org_ba_id]                  = UPD.[org_ba_id],
        [data_mart].[t_fact_afe].[data_source]                = UPD.[data_source],
        [data_mart].[t_fact_afe].[project_id]                 = UPD.[project_id],
        [data_mart].[t_fact_afe].[head_count]                 = UPD.[head_count],
        [data_mart].[t_fact_afe].[duration_of_work]           = UPD.[duration_of_work],
        [data_mart].[t_fact_afe].[number_of_reports]          = UPD.[number_of_reports],
        [data_mart].[t_fact_afe].[number_of_permits]          = UPD.[number_of_permits],
        [data_mart].[t_fact_afe].[cdn_dollars]                = UPD.[cdn_dollars],
        [data_mart].[t_fact_afe].[us_dollars]                 = UPD.[us_dollars],
        [data_mart].[t_fact_afe].[net_working_interest]       = UPD.[net_working_interest],
        [data_mart].[t_fact_afe].[transaction_last_load_date] = GETDATE (), --src.[transaction_last_load_date]
        [data_mart].[t_fact_afe].[etl_status]                 = UPD.[etl_status]
      FROM #t_fact_afe_MERGE UPD
	  WHERE
	    [data_mart].[t_fact_afe].afe_id = UPD.afe_id AND
        [data_mart].[t_fact_afe].entity_id             = UPD.entity_id AND
        [data_mart].[t_fact_afe].activity_period_id    = UPD.activity_period_id AND
        [data_mart].[t_fact_afe].gl_account            = UPD.gl_account AND
        [data_mart].[t_fact_afe].gross_net_indicator   = UPD.gross_net_indicator AND
        [data_mart].[t_fact_afe].scenario              = UPD.scenario AND
	    UPD.Flag = 'UPDATE'	

     --SET @p_Row_Count = @p_Row_Count + @@ROWCOUNT

   -- COMMIT TRANSACTION

    SET @v_Message  = 'Merge 2 of 5 complete.';
    SET @v_InfoText =   'Upsert of [data_mart].[v_fact_source_cost_estimates_qbyte] cost estimate transactions complete '
                       + '(Elapsed Time: '
                       + CONVERT (NVARCHAR, (FLOOR (DATEDIFF (hh, GETDATE (), @v_Load_Date)) % 24)) + ' hrs, '
                       + CONVERT (NVARCHAR, (FLOOR (DATEDIFF (mi, GETDATE (), @v_Load_Date)) % 60)) + ' min, '
                       + CONVERT (NVARCHAR, (FLOOR (DATEDIFF (ss, GETDATE (), @v_Load_Date)) % 60)) + ' sec)...';

   -- BEGIN TRANSACTION

      SET @v_Load_Date = GETDATE ();

      IF OBJECT_ID('tempdb..#t_fact_afe_MERGE') IS NOT NULL
        DROP TABLE #t_fact_afe_MERGE	 

      CREATE TABLE #t_fact_afe_MERGE WITH (DISTRIBUTION = ROUND_ROBIN)
        AS
          SELECT
		    'NEW' Flag,
            src.[scenario]
            + '.' + src.[grs_net]
            + '.' + CONVERT (NVARCHAR, src.[actvy_per_id])
            + '.' + CONVERT (NVARCHAR, src.[afe_id])
            + '.' + CONVERT (NVARCHAR, src.[entity_id])
            + '.' + src.[gl_net_account] AS [transaction_pk],
            src.[afe_id],
            src.[afe_number],
            src.[actvy_per_id] AS [activity_period_id],
            src.[acct_per_id] AS [accounting_period_id],
            src.[entity_id],
            src.[cc_number],
            src.[uwi],
            src.[gl_net_account] AS [gl_account],
            src.[afe_type],
            src.[afe_job_type_id] AS [afe_job_type],
            src.[afe_job_status_id] AS [afe_job_status],
            src.[org_id] AS [org_ba_id],
            src.[scenario],
            'AFENavigator' AS [data_source],
            src.[grs_net] AS [gross_net_indicator],
            src.[project_id],
            CAST (NULL AS float) AS [head_count],
            CAST (NULL AS float) AS [duration_of_work],
            CAST (NULL AS float) AS [number_of_reports],
            CAST (NULL AS float) AS [number_of_permits],
            src.[can_dollar_amt] AS [cdn_dollars],
            src.[us_dollar_amt] AS [us_dollars],
            src.[net_working_interest],
            'I' AS [etl_status]
          FROM
            [stage].[v_fact_source_cost_estimates_afenav] src
          LEFT JOIN [data_mart].[t_fact_afe] AS trg
            ON  trg.afe_id              = src.afe_id AND
                trg.entity_id           = src.entity_id AND
                trg.activity_period_id  = src.[actvy_per_id] AND
                trg.gl_account          = src.[gl_net_account] AND
                trg.gross_net_indicator = src.[grs_net] AND
                trg.scenario            = src.scenario
          WHERE
		    trg.afe_id  IS NULL AND             
			trg.entity_id IS NULL AND
			trg.activity_period_id IS NULL AND
			trg.gl_account IS NULL AND         
			trg.gross_net_indicator IS NULL AND
			trg.scenario IS NULL    
			
          UNION ALL

          SELECT
		    'UPDATE' Flag,
            src.[transaction_pk],
            src.[afe_id],
            src.[afe_number],
            src.[activity_period_id],
            src.[accounting_period_id],
            src.[entity_id],
            src.[cc_number],
            src.[uwi],
            src.[gl_account],
            src.[afe_type],
            src.[afe_job_type],
            src.[afe_job_status],
            src.[org_ba_id],
            src.[scenario],
            src.[data_source],
            src.[gross_net_indicator],
            src.[project_id],
            src.[head_count],
            src.[duration_of_work],
            src.[number_of_reports],
            src.[number_of_permits],
            src.[cdn_dollars],
            src.[us_dollars],
            src.[net_working_interest],
            src.[etl_status]
          FROM
		    (
               SELECT
                 src.[scenario]
                 + '.' + src.[grs_net]
                 + '.' + CONVERT (NVARCHAR, src.[actvy_per_id])
                 + '.' + CONVERT (NVARCHAR, src.[afe_id])
                 + '.' + CONVERT (NVARCHAR, src.[entity_id])
                 + '.' + src.[gl_net_account] AS [transaction_pk],
                 src.[afe_id],
                 src.[afe_number],
                 src.[actvy_per_id] AS [activity_period_id],
                 src.[acct_per_id] AS [accounting_period_id],
                 src.[entity_id],
                 src.[cc_number],
                 src.[uwi],
                 src.[gl_net_account] AS [gl_account],
                 src.[afe_type],
                 src.[afe_job_type_id] AS [afe_job_type],
                 src.[afe_job_status_id] AS [afe_job_status],
                 src.[org_id] AS [org_ba_id],
                 src.[scenario],
                 'AFENavigator' AS [data_source],
                 src.[grs_net] AS [gross_net_indicator],
                 src.[project_id],
                 CAST (NULL AS float) AS [head_count],
                 CAST (NULL AS float) AS [duration_of_work],
                 CAST (NULL AS float) AS [number_of_reports],
                 CAST (NULL AS float) AS [number_of_permits],
                 src.[can_dollar_amt] AS [cdn_dollars],
                 src.[us_dollar_amt] AS [us_dollars],
                 src.[net_working_interest],
                 'I' AS [etl_status]
               FROM
                 [stage].[v_fact_source_cost_estimates_afenav] src
               INNER JOIN [data_mart].[t_fact_afe] AS trg
                 ON  trg.afe_id              = src.afe_id AND
                     trg.entity_id           = src.entity_id AND
                     trg.activity_period_id  = src.[actvy_per_id] AND
                     trg.gl_account          = src.[gl_net_account] AND
                     trg.gross_net_indicator = src.[grs_net] AND
                     trg.scenario            = src.scenario	
					 
               EXCEPT

               SELECT
                 trg.[scenario]
                 + '.' + trg.[gross_net_indicator]
                 + '.' + CONVERT (NVARCHAR, trg.[activity_period_id])
                 + '.' + CONVERT (NVARCHAR, trg.[afe_id])
                 + '.' + CONVERT (NVARCHAR, trg.[entity_id])
                 + '.' + trg.gl_account AS [transaction_pk],
                 trg.[afe_id],
                 trg.[afe_number],
                 trg.[activity_period_id],
                 trg.[accounting_period_id],
                 trg.[entity_id],
                 trg.[cc_number],
                 trg.[uwi],
                 trg.[gl_account],
                 trg.[afe_type],
                 trg.[afe_job_type],
                 trg.[afe_job_status],
                 trg.[org_ba_id],
                 trg.[scenario],
                 'AFENavigator' AS [data_source],
                 trg.[gross_net_indicator],
                 trg.[project_id],
                 CAST (NULL AS float) AS [head_count],
                 CAST (NULL AS float) AS [duration_of_work],
                 CAST (NULL AS float) AS [number_of_reports],
                 CAST (NULL AS float) AS [number_of_permits],
                 trg.[cdn_dollars],
                 trg.[us_dollars],
                 trg.[net_working_interest],
                 'I' AS [etl_status]
               FROM
                 [data_mart].[t_fact_afe] AS trg
			) src

      INSERT INTO [data_mart].[t_fact_afe]
	    (
           [transaction_pk],
           [afe_id],
           [afe_number],
           [activity_period_id],
           [accounting_period_id],
           [entity_id],
           [cc_number],
           [uwi],
           [gl_account],
           [afe_type],
           [afe_job_type],
           [afe_job_status],
           [org_ba_id],
           [scenario],
           [data_source],
           [gross_net_indicator],
           [project_id],
           [head_count],
           [duration_of_work],
           [number_of_reports],
           [number_of_permits],
           [cdn_dollars],
           [us_dollars],
           [net_working_interest],
           --[transaction_last_load_id],
           [transaction_last_load_date],
           [etl_status]
		)
		SELECT
          src.[transaction_pk],
          src.[afe_id],
          src.[afe_number],
          src.[activity_period_id],
          src.[accounting_period_id],
          src.[entity_id],
          src.[cc_number],
          src.[uwi],
          src.[gl_account],
          src.[afe_type],
          src.[afe_job_type],
          src.[afe_job_status],
          src.[org_ba_id],
          src.[scenario],
          src.[data_source],
          src.[gross_net_indicator],
          src.[project_id],
          src.[head_count],
          src.[duration_of_work],
          src.[number_of_reports],
          src.[number_of_permits],
          src.[cdn_dollars],
          src.[us_dollars],
          src.[net_working_interest],
          GETDATE(), --[transaction_last_load_date],
          src.[etl_status]
        FROM
		  #t_fact_afe_MERGE src
        WHERE
		  Flag = 'NEW'	     
     
	  -------- ROW_COUNT
	  --DECLARE  @rowcnt INT
	  --EXEC [dbo].[LastRowCount] @rowcnt OUTPUT	

	  UPDATE [data_mart].[t_fact_afe]
      SET 
	    [data_mart].[t_fact_afe].[transaction_pk]             = UPD.[transaction_pk],
        [data_mart].[t_fact_afe].[afe_number]                 = UPD.[afe_number],
        [data_mart].[t_fact_afe].[cc_number]                  = UPD.[cc_number],
        [data_mart].[t_fact_afe].[uwi]                        = UPD.[uwi],
        [data_mart].[t_fact_afe].[afe_type]                   = UPD.[afe_type],
        [data_mart].[t_fact_afe].[afe_job_type]               = UPD.[afe_job_type],
        [data_mart].[t_fact_afe].[afe_job_status]             = UPD.[afe_job_status],
        [data_mart].[t_fact_afe].[org_ba_id]                  = UPD.[org_ba_id],
        [data_mart].[t_fact_afe].[data_source]                = UPD.[data_source],
        [data_mart].[t_fact_afe].[project_id]                 = UPD.[project_id],
        [data_mart].[t_fact_afe].[head_count]                 = UPD.[head_count],
        [data_mart].[t_fact_afe].[duration_of_work]           = UPD.[duration_of_work],
        [data_mart].[t_fact_afe].[number_of_reports]          = UPD.[number_of_reports],
        [data_mart].[t_fact_afe].[number_of_permits]          = UPD.[number_of_permits],
        [data_mart].[t_fact_afe].[cdn_dollars]                = UPD.[cdn_dollars],
        [data_mart].[t_fact_afe].[us_dollars]                 = UPD.[us_dollars],
        [data_mart].[t_fact_afe].[net_working_interest]       = UPD.[net_working_interest],
        [data_mart].[t_fact_afe].[transaction_last_load_date] = GETDATE (), --src.[transaction_last_load_date]
        [data_mart].[t_fact_afe].[etl_status]                 = UPD.[etl_status]
      FROM #t_fact_afe_MERGE UPD
	  WHERE
	    [data_mart].[t_fact_afe].afe_id = UPD.afe_id AND
        [data_mart].[t_fact_afe].entity_id             = UPD.entity_id AND
        [data_mart].[t_fact_afe].activity_period_id    = UPD.activity_period_id AND
        [data_mart].[t_fact_afe].gl_account            = UPD.gl_account AND
        [data_mart].[t_fact_afe].gross_net_indicator   = UPD.gross_net_indicator AND
        [data_mart].[t_fact_afe].scenario              = UPD.scenario AND
	    UPD.Flag = 'UPDATE'	

      --  SET @p_Row_Count = @p_Row_Count + @@ROWCOUNT

    --COMMIT TRANSACTION

    SET @v_Message  = 'Merge 3 of 5 complete.';
    SET @v_InfoText =   'Upsert of [data_mart].[v_fact_source_cost_estimates_afenav] cost estimate transactions complete '
                       + '(Elapsed Time: '
                       + CONVERT (NVARCHAR, (FLOOR (DATEDIFF (hh, GETDATE (), @v_Load_Date)) % 24)) + ' hrs, '
                       + CONVERT (NVARCHAR, (FLOOR (DATEDIFF (mi, GETDATE (), @v_Load_Date)) % 60)) + ' min, '
                       + CONVERT (NVARCHAR, (FLOOR (DATEDIFF (ss, GETDATE (), @v_Load_Date)) % 60)) + ' sec)...';

   -- BEGIN TRANSACTION

      SET @v_Load_Date = GETDATE ();

      IF OBJECT_ID('tempdb..#t_fact_afe_MERGE') IS NOT NULL
        DROP TABLE #t_fact_afe_MERGE	 

      CREATE TABLE #t_fact_afe_MERGE WITH (DISTRIBUTION = ROUND_ROBIN)
        AS
          SELECT
		    'NEW' Flag,
            'WellView' --[scenario]
            + '.' + src.[grs_net]
            + '.' + CONVERT (NVARCHAR, src.[actvy_per_id])
            + '.' + CONVERT (NVARCHAR, src.[afe_id])
            + '.' + CONVERT (NVARCHAR, src.[entity_id])
            + '.' + src.[gl_net_account] AS [transaction_pk],
            src.[afe_id],
            src.[afe_number],
            src.[actvy_per_id] AS [activity_period_id],
            src.[acct_per_id] AS [accounting_period_id],
            src.[entity_id],
            src.[cc_number],
            src.[uwi],
            src.[gl_net_account] AS [gl_account],
            src.[afe_type],
            src.[afe_job_type_id] AS [afe_job_type],
            src.[afe_job_status_id] AS [afe_job_status],
            src.[org_id] AS [org_ba_id],
            src.[scenario],
			src.[vendor_id] as [vendor_ba_id],
            'WellView' AS [data_source],
            src.[grs_net] AS [gross_net_indicator],
            src.[project_id],
            CAST (NULL AS float) AS [head_count],
            CAST (NULL AS float) AS [duration_of_work],
            CAST (NULL AS float) AS [number_of_reports],
            CAST (NULL AS float) AS [number_of_permits],
            src.[can_dollar_amt] AS [cdn_dollars],
            src.[us_dollar_amt] AS [us_dollars],
            src.[net_working_interest],
            'I' AS [etl_status]
          FROM
            [stage].[v_fact_source_cost_estimates_wellview] src
          LEFT JOIN [data_mart].[t_fact_afe] AS trg
             ON trg.afe_id              = src.afe_id AND
                trg.entity_id           = src.entity_id AND
                trg.activity_period_id  = src.[actvy_per_id] AND
                trg.gl_account          = src.[gl_net_account] AND
                trg.gross_net_indicator = src.[grs_net] AND
                trg.scenario            = src.scenario
          WHERE
			trg.afe_id IS NULL AND             
			trg.entity_id IS NULL AND             
			trg.activity_period_id IS NULL AND             
			trg.gl_account IS NULL AND                      
			trg.gross_net_indicator IS NULL AND             
			trg.scenario  IS NULL  
			
          UNION ALL

          SELECT
		    'UPDATE' Flag,
            src.[transaction_pk],
            src.[afe_id],
            src.[afe_number],
            src.[activity_period_id],
            src.[accounting_period_id],
            src.[entity_id],
            src.[cc_number],
            src.[uwi],
            src.[gl_account],
            src.[afe_type],
            src.[afe_job_type],
            src.[afe_job_status],
            src.[org_ba_id],
            src.[scenario],
			src.[vendor_ba_id],
            src.[data_source],
            src.[gross_net_indicator],
            src.[project_id],
            src.[head_count],
            src.[duration_of_work],
            src.[number_of_reports],
            src.[number_of_permits],
            src.[cdn_dollars],
            src.[us_dollars],
            src.[net_working_interest],
            src.[etl_status]
          FROM
            (
               SELECT
                 'WellView' --[scenario]
                 + '.' + src.[grs_net]
                 + '.' + CONVERT (NVARCHAR, src.[actvy_per_id])
                 + '.' + CONVERT (NVARCHAR, src.[afe_id])
                 + '.' + CONVERT (NVARCHAR, src.[entity_id])
                 + '.' + src.[gl_net_account] AS [transaction_pk],
                 src.[afe_id],
                 src.[afe_number],
                 src.[actvy_per_id] AS [activity_period_id],
                 src.[acct_per_id] AS [accounting_period_id],
                 src.[entity_id],
                 src.[cc_number],
                 src.[uwi],
                 src.[gl_net_account] AS [gl_account],
                 src.[afe_type],
                 src.[afe_job_type_id] AS [afe_job_type],
                 src.[afe_job_status_id] AS [afe_job_status],
                 src.[org_id] AS [org_ba_id],
                 src.[scenario],
			     src.[vendor_id] as [vendor_ba_id],
                 'WellView' AS [data_source],
                 src.[grs_net] AS [gross_net_indicator],
                 src.[project_id],
                 CAST (NULL AS float) AS [head_count],
                 CAST (NULL AS float) AS [duration_of_work],
                 CAST (NULL AS float) AS [number_of_reports],
                 CAST (NULL AS float) AS [number_of_permits],
                 src.[can_dollar_amt] AS [cdn_dollars],
                 src.[us_dollar_amt] AS [us_dollars],
                 src.[net_working_interest],
                 'I' AS [etl_status]
               FROM
                 [stage].[v_fact_source_cost_estimates_wellview] src
               INNER JOIN [data_mart].[t_fact_afe] AS trg
                  ON trg.afe_id              = src.afe_id AND
                     trg.entity_id           = src.entity_id AND
                     trg.activity_period_id  = src.[actvy_per_id] AND
                     trg.gl_account          = src.[gl_net_account] AND
                     trg.gross_net_indicator = src.[grs_net] AND
                     trg.scenario            = src.scenario

               EXCEPT

               SELECT
                 'WellView' --[scenario]
                 + '.' + trg.[gross_net_indicator]
                 + '.' + CONVERT (NVARCHAR, trg.[activity_period_id])
                 + '.' + CONVERT (NVARCHAR, trg.[afe_id])
                 + '.' + CONVERT (NVARCHAR, trg.[entity_id])
                 + '.' + trg.[gl_account] AS [transaction_pk],
                 trg.[afe_id],
                 trg.[afe_number],
                 trg.[activity_period_id],
                 trg.[accounting_period_id],
                 trg.[entity_id],
                 trg.[cc_number],
                 trg.[uwi],
                 trg.[gl_account],
                 trg.[afe_type],
                 trg.[afe_job_type],
                 trg.[afe_job_status],
                 trg.[org_ba_id],
                 trg.[scenario],
			     trg.[vendor_ba_id],
                 'WellView' AS [data_source],
                 trg.[gross_net_indicator],
                 trg.[project_id],
                 CAST (NULL AS float) AS [head_count],
                 CAST (NULL AS float) AS [duration_of_work],
                 CAST (NULL AS float) AS [number_of_reports],
                 CAST (NULL AS float) AS [number_of_permits],
                 trg.[cdn_dollars],
                 trg.[us_dollars],
                 trg.[net_working_interest],
                 'I' AS [etl_status]
               FROM
                 [data_mart].[t_fact_afe] AS trg
			) src

      INSERT INTO [data_mart].[t_fact_afe]
	    (
           [transaction_pk],
           [afe_id],
           [afe_number],
           [activity_period_id],
           [accounting_period_id],
           [entity_id],
           [cc_number],
           [uwi],
           [gl_account],
           [afe_type],
           [afe_job_type],
           [afe_job_status],
           [org_ba_id],
           [scenario],
		   [vendor_ba_id],
           [data_source],
           [gross_net_indicator],
           [project_id],
           [head_count],
           [duration_of_work],
           [number_of_reports],
           [number_of_permits],
           [cdn_dollars],
           [us_dollars],
           [net_working_interest],
           [transaction_last_load_date],
           [etl_status]
		)
		SELECT
          src.[transaction_pk],
          src.[afe_id],
          src.[afe_number],
          src.[activity_period_id],
          src.[accounting_period_id],
          src.[entity_id],
          src.[cc_number],
          src.[uwi],
          src.[gl_account],
          src.[afe_type],
          src.[afe_job_type],
          src.[afe_job_status],
          src.[org_ba_id],
          src.[scenario],
		  src.[vendor_ba_id],
          src.[data_source],
          src.[gross_net_indicator],
          src.[project_id],
          src.[head_count],
          src.[duration_of_work],
          src.[number_of_reports],
          src.[number_of_permits],
          src.[cdn_dollars],
          src.[us_dollars],
          src.[net_working_interest],
          GETDATE(), -- [transaction_last_load_date],
          src.[etl_status]
       FROM
         #t_fact_afe_MERGE src
	   WHERE
	     Flag = 'NEW'

	  -------- ROW_COUNT
	  --DECLARE  @rowcnt INT
	  --EXEC [dbo].[LastRowCount] @rowcnt OUTPUT	

	  UPDATE [data_mart].[t_fact_afe]
      SET 
	    [data_mart].[t_fact_afe].[transaction_pk]             = UPD.[transaction_pk],
        [data_mart].[t_fact_afe].[afe_number]                 = UPD.[afe_number],
        [data_mart].[t_fact_afe].[cc_number]                  = UPD.[cc_number],
        [data_mart].[t_fact_afe].[uwi]                        = UPD.[uwi],
        [data_mart].[t_fact_afe].[afe_type]                   = UPD.[afe_type],
        [data_mart].[t_fact_afe].[afe_job_type]               = UPD.[afe_job_type],
        [data_mart].[t_fact_afe].[afe_job_status]             = UPD.[afe_job_status],
        [data_mart].[t_fact_afe].[org_ba_id]                  = UPD.[org_ba_id],
		[data_mart].[t_fact_afe].[vendor_ba_id]			      = UPD.[vendor_ba_id],
        [data_mart].[t_fact_afe].[data_source]                = UPD.[data_source],
        [data_mart].[t_fact_afe].[project_id]                 = UPD.[project_id],
        [data_mart].[t_fact_afe].[head_count]                 = UPD.[head_count],
        [data_mart].[t_fact_afe].[duration_of_work]           = UPD.[duration_of_work],
        [data_mart].[t_fact_afe].[number_of_reports]          = UPD.[number_of_reports],
        [data_mart].[t_fact_afe].[number_of_permits]          = UPD.[number_of_permits],
        [data_mart].[t_fact_afe].[cdn_dollars]                = UPD.[cdn_dollars],
        [data_mart].[t_fact_afe].[us_dollars]                 = UPD.[us_dollars],
        [data_mart].[t_fact_afe].[net_working_interest]       = UPD.[net_working_interest],
        [data_mart].[t_fact_afe].[transaction_last_load_date] = GETDATE (), --src.[transaction_last_load_date]
        [data_mart].[t_fact_afe].[etl_status]                 = UPD.[etl_status]
      FROM #t_fact_afe_MERGE UPD
	  WHERE
	    [data_mart].[t_fact_afe].afe_id = UPD.afe_id AND
        [data_mart].[t_fact_afe].entity_id             = UPD.entity_id AND
        [data_mart].[t_fact_afe].activity_period_id    = UPD.activity_period_id AND
        [data_mart].[t_fact_afe].gl_account            = UPD.gl_account AND
        [data_mart].[t_fact_afe].gross_net_indicator   = UPD.gross_net_indicator AND
        [data_mart].[t_fact_afe].scenario              = UPD.scenario AND
	    UPD.Flag = 'UPDATE'	
     --
     --SET @p_Row_Count = @p_Row_Count + @@ROWCOUNT

    --COMMIT TRANSACTION

    SET @v_Message  = 'Merge 4 of 5 complete.';
    SET @v_InfoText =   'Upsert of [data_mart].[v_fact_source_cost_estimates_wellview] cost estimate transactions complete '
                       + '(Elapsed Time: '
                       + CONVERT (NVARCHAR, (FLOOR (DATEDIFF (hh, GETDATE (), @v_Load_Date)) % 24)) + ' hrs, '
                       + CONVERT (NVARCHAR, (FLOOR (DATEDIFF (mi, GETDATE (), @v_Load_Date)) % 60)) + ' min, '
                       + CONVERT (NVARCHAR, (FLOOR (DATEDIFF (ss, GETDATE (), @v_Load_Date)) % 60)) + ' sec)...';

   -- BEGIN TRANSACTION

      SET @v_Load_Date = GETDATE ();

      IF OBJECT_ID('tempdb..#t_fact_afe_MERGE') IS NOT NULL
        DROP TABLE #t_fact_afe_MERGE	 

      CREATE TABLE #t_fact_afe_MERGE WITH (DISTRIBUTION = ROUND_ROBIN)
        AS
          SELECT
		    'NEW' Flag,
              'SiteView' --[scenario]
            + '.' + src.[grs_net]
            + '.' + CONVERT (NVARCHAR, src.[actvy_per_id])
            + '.' + CONVERT (NVARCHAR, src.[afe_id])
            + '.' + CONVERT (NVARCHAR, src.[entity_id])
            + '.' + src.[gl_net_account] AS [transaction_pk],
            src.[afe_id],
            src.[afe_number],
            src.[actvy_per_id] AS [activity_period_id],
            src.[acct_per_id] AS [accounting_period_id],
            src.[entity_id],
            src.[cc_number],
            src.[uwi],
            src.[gl_net_account] AS [gl_account],
            src.[afe_type],
            src.[afe_job_type_id] AS [afe_job_type],
            src.[afe_job_status_id] AS [afe_job_status],
            src.[org_id] AS [org_ba_id],
            src.[scenario],
			src.[vendor_id] as [vendor_ba_id],
            'SiteView' AS [data_source],
            src.[grs_net] AS [gross_net_indicator],
            src.[project_id],
            CAST (NULL AS float) AS [head_count],
            CAST (NULL AS float) AS [duration_of_work],
            CAST (NULL AS float) AS [number_of_reports],
            CAST (NULL AS float) AS [number_of_permits],
            src.[can_dollar_amt] AS [cdn_dollars],
            src.[us_dollar_amt] AS [us_dollars],
            src.[net_working_interest],
            'I' AS [etl_status]
          FROM
            [stage].[v_fact_source_cost_estimates_siteview] src
          LEFT JOIN [data_mart].[t_fact_afe] AS trg
             ON trg.afe_id              = src.afe_id AND
                trg.entity_id           = src.entity_id AND
                trg.activity_period_id  = src.[actvy_per_id] AND
                trg.gl_account          = src.[gl_net_account] AND
                trg.gross_net_indicator = src.[grs_net] AND
                trg.scenario            = src.scenario
          WHERE
		    trg.afe_id IS NULL AND             
			trg.entity_id IS NULL AND          
			trg.activity_period_id IS NULL AND 
			trg.gl_account IS NULL AND         
			trg.gross_net_indicator IS NULL AND
			trg.scenario IS NULL      
			
          UNION ALL

          SELECT
		    'UPDATE' Flag,
            src.[transaction_pk],
            src.[afe_id],
            src.[afe_number],
            src.[activity_period_id],
            src.[accounting_period_id],
            src.[entity_id],
            src.[cc_number],
            src.[uwi],
            src.[gl_account],
            src.[afe_type],
            src.[afe_job_type],
            src.[afe_job_status],
            src.[org_ba_id],
            src.[scenario],
			src.[vendor_ba_id],
            src.[data_source],
            src.[gross_net_indicator],
            src.[project_id],
            src.[head_count],
            src.[duration_of_work],
            src.[number_of_reports],
            src.[number_of_permits],
            src.[cdn_dollars],
            src.[us_dollars],
            src.[net_working_interest],
            src.[etl_status]
          FROM
            (
               SELECT
                   'SiteView' --[scenario]
                 + '.' + src.[grs_net]
                 + '.' + CONVERT (NVARCHAR, src.[actvy_per_id])
                 + '.' + CONVERT (NVARCHAR, src.[afe_id])
                 + '.' + CONVERT (NVARCHAR, src.[entity_id])
                 + '.' + src.[gl_net_account] AS [transaction_pk],
                 src.[afe_id],
                 src.[afe_number],
                 src.[actvy_per_id] AS [activity_period_id],
                 src.[acct_per_id] AS [accounting_period_id],
                 src.[entity_id],
                 src.[cc_number],
                 src.[uwi],
                 src.[gl_net_account] AS [gl_account],
                 src.[afe_type],
                 src.[afe_job_type_id] AS [afe_job_type],
                 src.[afe_job_status_id] AS [afe_job_status],
                 src.[org_id] AS [org_ba_id],
                 src.[scenario],
			     src.[vendor_id] as [vendor_ba_id],
                 'SiteView' AS [data_source],
                 src.[grs_net] AS [gross_net_indicator],
                 src.[project_id],
                 CAST (NULL AS float) AS [head_count],
                 CAST (NULL AS float) AS [duration_of_work],
                 CAST (NULL AS float) AS [number_of_reports],
                 CAST (NULL AS float) AS [number_of_permits],
                 src.[can_dollar_amt] AS [cdn_dollars],
                 src.[us_dollar_amt] AS [us_dollars],
                 src.[net_working_interest],
                 'I' AS [etl_status]
               FROM
                 [stage].[v_fact_source_cost_estimates_siteview] src
               INNER JOIN [data_mart].[t_fact_afe] AS trg
                  ON trg.afe_id              = src.afe_id AND
                     trg.entity_id           = src.entity_id AND
                     trg.activity_period_id  = src.[actvy_per_id] AND
                     trg.gl_account          = src.[gl_net_account] AND
                     trg.gross_net_indicator = src.[grs_net] AND
                     trg.scenario            = src.scenario

               EXCEPT

               SELECT
                   'SiteView' --[scenario]
                 + '.' + trg.[gross_net_indicator]
                 + '.' + CONVERT (NVARCHAR, trg.[activity_period_id])
                 + '.' + CONVERT (NVARCHAR, trg.[afe_id])
                 + '.' + CONVERT (NVARCHAR, trg.[entity_id])
                 + '.' + trg.[gl_account] AS [transaction_pk],
                 trg.[afe_id],
                 trg.[afe_number],
                 trg.[activity_period_id],
                 trg.[accounting_period_id],
                 trg.[entity_id],
                 trg.[cc_number],
                 trg.[uwi],
                 trg.[gl_account],
                 trg.[afe_type],
                 trg.[afe_job_type],
                 trg.[afe_job_status],
                 trg.[org_ba_id],
                 trg.[scenario],
			     trg.[vendor_ba_id],
                 'SiteView' AS [data_source],
                 trg.[gross_net_indicator],
                 trg.[project_id],
                 CAST (NULL AS float) AS [head_count],
                 CAST (NULL AS float) AS [duration_of_work],
                 CAST (NULL AS float) AS [number_of_reports],
                 CAST (NULL AS float) AS [number_of_permits],
                 trg.[cdn_dollars],
                 trg.[us_dollars],
                 trg.[net_working_interest],
                 'I' AS [etl_status]
               FROM
                 [data_mart].[t_fact_afe] AS trg
			) src
     
	  INSERT INTO [data_mart].[t_fact_afe]
	    (
           [transaction_pk],
           [afe_id],
           [afe_number],
           [activity_period_id],
           [accounting_period_id],
           [entity_id],
           [cc_number],
           [uwi],
           [gl_account],
           [afe_type],
           [afe_job_type],
           [afe_job_status],
           [org_ba_id],
           [scenario],
		   [vendor_ba_id],
           [data_source],
           [gross_net_indicator],
           [project_id],
           [head_count],
           [duration_of_work],
           [number_of_reports],
           [number_of_permits],
           [cdn_dollars],
           [us_dollars],
           [net_working_interest],
           [transaction_last_load_date],
           [etl_status]
		)
		SELECT
          src.[transaction_pk],
          src.[afe_id],
          src.[afe_number],
          src.[activity_period_id],
          src.[accounting_period_id],
          src.[entity_id],
          src.[cc_number],
          src.[uwi],
          src.[gl_account],
          src.[afe_type],
          src.[afe_job_type],
          src.[afe_job_status],
          src.[org_ba_id],
          src.[scenario],
		  src.[vendor_ba_id],
          src.[data_source],
          src.[gross_net_indicator],
          src.[project_id],
          src.[head_count],
          src.[duration_of_work],
          src.[number_of_reports],
          src.[number_of_permits],
          src.[cdn_dollars],
          src.[us_dollars],
          src.[net_working_interest],
          GETDATE(), -- [transaction_last_load_date],
          src.[etl_status]
		FROM
		  #t_fact_afe_MERGE src
		WHERE
		  Flag = 'NEW'

	  -------- ROW_COUNT
	  --DECLARE  @rowcnt INT
	  --EXEC [dbo].[LastRowCount] @rowcnt OUTPUT	

	  UPDATE [data_mart].[t_fact_afe]
      SET 
	    [data_mart].[t_fact_afe].[transaction_pk]             = UPD.[transaction_pk],
        [data_mart].[t_fact_afe].[afe_number]                 = UPD.[afe_number],
        [data_mart].[t_fact_afe].[cc_number]                  = UPD.[cc_number],
        [data_mart].[t_fact_afe].[uwi]                        = UPD.[uwi],
        [data_mart].[t_fact_afe].[afe_type]                   = UPD.[afe_type],
        [data_mart].[t_fact_afe].[afe_job_type]               = UPD.[afe_job_type],
        [data_mart].[t_fact_afe].[afe_job_status]             = UPD.[afe_job_status],
        [data_mart].[t_fact_afe].[org_ba_id]                  = UPD.[org_ba_id],
		[data_mart].[t_fact_afe].[vendor_ba_id]			      = UPD.[vendor_ba_id],
        [data_mart].[t_fact_afe].[data_source]                = UPD.[data_source],
        [data_mart].[t_fact_afe].[project_id]                 = UPD.[project_id],
        [data_mart].[t_fact_afe].[head_count]                 = UPD.[head_count],
        [data_mart].[t_fact_afe].[duration_of_work]           = UPD.[duration_of_work],
        [data_mart].[t_fact_afe].[number_of_reports]          = UPD.[number_of_reports],
        [data_mart].[t_fact_afe].[number_of_permits]          = UPD.[number_of_permits],
        [data_mart].[t_fact_afe].[cdn_dollars]                = UPD.[cdn_dollars],
        [data_mart].[t_fact_afe].[us_dollars]                 = UPD.[us_dollars],
        [data_mart].[t_fact_afe].[net_working_interest]       = UPD.[net_working_interest],
        [data_mart].[t_fact_afe].[transaction_last_load_date] = GETDATE (), --src.[transaction_last_load_date]
        [data_mart].[t_fact_afe].[etl_status]                 = UPD.[etl_status]
      FROM #t_fact_afe_MERGE UPD
	  WHERE
	    [data_mart].[t_fact_afe].afe_id = UPD.afe_id AND
        [data_mart].[t_fact_afe].entity_id             = UPD.entity_id AND
        [data_mart].[t_fact_afe].activity_period_id    = UPD.activity_period_id AND
        [data_mart].[t_fact_afe].gl_account            = UPD.gl_account AND
        [data_mart].[t_fact_afe].gross_net_indicator   = UPD.gross_net_indicator AND
        [data_mart].[t_fact_afe].scenario              = UPD.scenario AND
	    UPD.Flag = 'UPDATE'	
     --
     --SET @p_Row_Count = @p_Row_Count + @@ROWCOUNT

    --COMMIT TRANSACTION

    SET @v_Message  = 'Merge 5 of 5 complete.';
    SET @v_InfoText =   'Upsert of [data_mart].[v_fact_source_cost_estimates_siteview] cost estimate transactions complete '
                       + '(Elapsed Time: '
                       + CONVERT (NVARCHAR, (FLOOR (DATEDIFF (hh, GETDATE (), @v_Load_Date)) % 24)) + ' hrs, '
                       + CONVERT (NVARCHAR, (FLOOR (DATEDIFF (mi, GETDATE (), @v_Load_Date)) % 60)) + ' min, '
                       + CONVERT (NVARCHAR, (FLOOR (DATEDIFF (ss, GETDATE (), @v_Load_Date)) % 60)) + ' sec)...';

    SET @v_End_Date = GETDATE ();
    --
    SET @v_Message  = 'Process completed successfully at ' + CONVERT (NVARCHAR, @v_End_Date);
    SET @v_InfoText =   'Procedure Completion Time: '
                       + CONVERT (NVARCHAR, (FLOOR (DATEDIFF (hh, @v_End_Date, @v_Start_Date)) % 24)) + ' hrs, '
                       + CONVERT (NVARCHAR, (FLOOR (DATEDIFF (mi, @v_End_Date, @v_Start_Date)) % 60)) + ' min, '
                       + CONVERT (NVARCHAR, (FLOOR (DATEDIFF (ss, @v_End_Date, @v_Start_Date)) % 60)) + ' sec)...';

  END TRY
 
  BEGIN CATCH
        
      /* Grab error information from SQL functions */

          DECLARE @ErrorSeverity INT             = ERROR_SEVERITY (),
                  @ErrorNumber   INT             = ERROR_NUMBER (),
                  @ErrorMessage  NVARCHAR (4000) = ERROR_MESSAGE (),
                  @ErrorState    INT             = ERROR_STATE (),
                --  @ErrorLine     INT             = ERROR_LINE (),
                  @ErrorProc     NVARCHAR (200)  = ERROR_PROCEDURE ()
                    
       /* If the error renders the transaction as uncommittable or we have open transactions, rollback */

          --IF @@TRANCOUNT > 0
          --BEGIN
          --     ROLLBACK TRANSACTION
          --END

          RAISERROR (@ErrorMessage , @ErrorSeverity, @ErrorState, @ErrorNumber)

  END CATCH
--RETURN @@ERROR
END