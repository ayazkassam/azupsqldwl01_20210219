CREATE VIEW [stage].[v_fact_source_finance_budgets]
AS SELECT cast(-1 as int) li_id
		, cast(-1 as int) voucher_id
		, cast('992995' as varchar(500)) as entity_key
		, cast([account_key] as varchar(1000)) [account_key]
		, cast([accounting_month_key] as int)  [accounting_month_key]
		, cast([activity_month_key] as int) [activity_month_key]
		, cast([gross_net_key] as int) [gross_net_key]
		, cast([vendor_key] as int) [vendor_key]
		, cast(replace(replace(cube_child_member,' Base',''), ' Incremental Program','') as varchar(1000)) scenario_key
		, cast(1 as int) organization_key
		, cast('-1' as varchar(10)) afe_key
		, cast(null as float) cad
		, sum([metric_volume])    			metric_volume
		, sum([imperial_volume])			imperial_volume
		, sum([boe_volume])					boe_volume
		, sum([mcfe_volume])				mcfe_volume
	FROM [stage].[t_fact_source_leaseops_valnav_volumes] facts
		join (	select variable_value, cube_child_member 
			from stage.t_ctrl_valnav_etl_variables 
			where variable_name = 'FINANCE_DATA_SCENARIO'
		) v on facts.scenario_key = v.cube_child_member
	group by account_key, accounting_month_key, activity_month_key, gross_net_key, vendor_key, cube_child_member

/*	union all

	/*-- Valnav Capital Budget*/
	SELECT cast(-1 as int) li_id
		, cast(-1 as int) voucher_id
		, cast('992995' as varchar(500)) as [entity_key]
		, cast([account_key] as varchar(1000)) [account_key]
		, cast([accounting_period_key] as int) [accounting_period_key]
		, cast([activity_date_key] as int) [activity_date_key]
		, cast([gross_net_key] as int) [gross_net_key]
		, cast([vendor_key] as int) [vendor_key]
		, cast(replace(replace(cube_child_member,' Base',''), ' Incremental Program','') as varchar(1000)) scenario_key
		, cast(1 as int) organization_key
		, cast('-1' as varchar(10)) afe_key
		, sum(cad) as CAD
		, cast(null as float) [metric_volume]
		, cast(null as float) [imperial_volume]
		, cast(null as float) [boe_volume]
		, cast(null as float) [mcfe_volume]
	from stage.v_fact_source_capital_valnav_budgets facts
		join (	select variable_value, cube_child_member 
			from stage.t_ctrl_valnav_etl_variables 
			where variable_name = 'FINANCE_DATA_SCENARIO'
		) v on facts.scenario_key = v.cube_child_member
	group by account_key, [accounting_period_key], [activity_date_key], gross_net_key, vendor_key, cube_child_member, afe_key

*/
--
UNION ALL
--
-- Finance budget input from User 
SELECT -1 li_id,
       -1 voucher_id,
       cast(entity_key as varchar(500)) entity_key,
	   cast(account_key as varchar(1000)) account_key,
	   CAST(accounting_month_key AS INT) AS accounting_month_key,
	   CAST(activity_month_key AS INT) AS activity_month_key,  
	   cast(gross_net_key as int) gross_net_key,
	   cast(vendor_key as int) vendor_key ,
	   cast(scenario_key as varchar(1000)) scenario_key,
	   cast (1 as int) organization_key,
	   cast (coalesce(afe.afe_num, '-1') as varchar(10)) afe_key,
	   cast(sum(cad) as float) cad,
	   cast(sum(metric_volume) as float) metric_volume,
	   cast(sum(imperial_volume) as float) imperial_volume,
	   cast(sum(boe_volume) as float) boe_volume,
	   cast(sum(mcfe_volume) as float) mcfe_volume

FROM
(
-- Finance budget $
 SELECT CASE WHEN substring(sd.budget_group,1,2) = 'CC'
             THEN replace(sd.budget_group,'CC_','')
		     ELSE coalesce(fac.entity_key,area.entity_key,-1)
		END entity_key,
        CASE WHEN acct.account_id IS NULL THEN '-1'
			       WHEN account IS NULL THEN '-2'
				   ELSE account
		END account_key, 

		coalesce(replace(cast(period as varchar(20)),'-',''),'-1') accounting_month_key,
		coalesce(replace(cast(period as varchar(20)),'-',''),'-1') activity_month_key,   
		CASE WHEN LTRIM(RTRIM(sd.grs_net_flag)) = 'NET' THEN 2 ELSE 1 END gross_net_key,
		-1 as vendor_key,
		--ISNULL(sc.scenario_key,-1) scenario_key,
		coalesce(scenario,'-1') scenario_key,
        --round(cad * coalesce(acct.rev_multiplier,1),2)  AS cad,
		round(cad,2)  AS cad,
	    CAST (NULL AS NUMERIC) AS usd,
		CAST (NULL AS NUMERIC) AS metric_volume,
		CAST (NULL AS NUMERIC) AS imperial_volume,
		CAST (NULL AS NUMERIC) AS boe_volume,
		CAST (NULL AS NUMERIC) AS mcfe_volume
 FROM
   (
   --SD
   SELECT [DATA_SOURCE]
      ,[SCENARIO]
      ,bf.[BUDGET_GROUP]
      ,[MAJOR_ACCT]
      ,[MINOR_ACCT]
      ,[MEASURE]
      ,[GRS_NET_FLAG]
      ,bf.[BUDGET_YEAR]
      ,[JANUARY]
      ,[FEBRUARY]
      ,[MARCH]
      ,[APRIL]
      ,[MAY]
      ,[JUNE]
      ,[JULY]
      ,[AUGUST]
      ,[SEPTEMBER]
      ,[OCTOBER]
      ,[NOVEMBER]
      ,[DECEMBER]
	  ,
	  eomonth(CAST(bf.budget_year + mx.month_num + '01' AS DATE)) period,
	  CONCAT(LTRIM(RTRIM(bf.major_acct)), '_', LTRIM(RTRIM(bf.minor_acct))) account,
	  CASE mx.month_num 
		  WHEN '01' THEN JANUARY
		  WHEN '02' THEN FEBRUARY
		  WHEN '03'	THEN MARCH
		  WHEN '04'	THEN APRIL
		  WHEN '05' THEN MAY
		  WHEN '06' THEN JUNE
		  WHEN '07' THEN JULY
		  WHEN '08' THEN AUGUST
		  WHEN '09' THEN SEPTEMBER
		  WHEN '10' THEN OCTOBER
		  WHEN '11' THEN NOVEMBER
		  WHEN '12' THEN DECEMBER
		  ELSE NULL
	  END cad
   FROM 
       (SELECT *
	    FROM[stage].[t_stg_finance_budget_facts]
		 WHERE (coalesce(JANUARY,0)+coalesce(FEBRUARY,0)+coalesce(MARCH,0)+coalesce(APRIL,0)+coalesce(MAY,0)+coalesce(JUNE,0)+
         coalesce(JULY,0)+coalesce(AUGUST,0)+coalesce(SEPTEMBER,0)+coalesce(OCTOBER,0)+coalesce(NOVEMBER,0)+coalesce(DECEMBER,0)) <> 0
		 
		) bf,
		(
		-- Cartesian join/product to pivot monthly columns into rows...12 months rows generated to do that!
		SELECT month_num
		from dbo.StrMonthList
		) mx
   ) SD
   LEFT OUTER JOIN
	(SELECT   DISTINCT
		 FIRST_VALUE (entity_key) over (partition by facility ORDER BY entity_key) entity_key,
		 facility
		FROM      [data_mart].[t_dim_entity]  
		WHERE facility is not null
		AND is_cc_dim = 1
    ) fac
   ON UPPER(sd.budget_group) = fac.facility
   --
   LEFT OUTER JOIN
   --
	 (SELECT   DISTINCT
		 FIRST_VALUE (entity_key) over (partition by area ORDER BY entity_key) entity_key,
		 area
		FROM      [data_mart].[t_dim_entity]  
		WHERE area is not null
		AND is_cc_dim = 1
		 AND UPPER(cc_type) like 'ACCRUAL%'
      ) area
  --
  ON UPPER(sd.budget_group) = area.area
  --
  LEFT OUTER JOIN 
  --
  [data_mart].[t_dim_entity] ent
  --
  ON isnull(fac.entity_key,area.entity_key) = ent.entity_key
  --
  --LEFT OUTER JOIN [dbo].[t_ctrl_fixed_var_opex] fv
  --ON sd.account = fv.qbyte_net_major_minor
  LEFT OUTER JOIN 
  --
/* (SELECT ac.*, CASE WHEN ac.class_code_description = 'REVENUE' THEN 1 ELSE 1 END rev_multiplier
 FROM [data_mart].t_dim_account_hierarchy ac 
 ) acct 
 */
 [data_mart].t_dim_account_finance acct
 --
 ON sd.account = acct.account_id
 --
 )  SSD
 --
 LEFT OUTER JOIN
 --
 (
   SELECT DISTINCT cost_centre, 
        first_value(afe_num) over (partition by cost_centre ORDER BY cost_centre ) afe_num
  FROM [data_mart].[t_dim_authorization_for_expenditure]
  ) afe
--
ON ssd.entity_key = afe.cost_centre
--
GROUP BY entity_key,
	   account_key,
	   accounting_month_key,
	   activity_month_key,  
	   gross_net_key,
	   vendor_key,
	   scenario_key,
	   afe.afe_num;