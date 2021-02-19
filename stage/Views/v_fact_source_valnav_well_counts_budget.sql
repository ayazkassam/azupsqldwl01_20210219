CREATE VIEW [stage].[v_fact_source_valnav_well_counts_budget]
AS SELECT cfd.parent_id AS entity_key,
          CAST (be.unique_id AS VARCHAR (100)) AS uwi,
          wcd.date_value AS actvy_date,
		   CASE WHEN  wcd.date_value IS NULL  THEN -1
						 ELSE  CAST(CAST(YEAR(wcd.date_value) AS VARCHAR) + right(replicate('00',2) + CAST( MONTH(wcd.date_value) AS VARCHAR),2)
						+ right(replicate('00',2) + CAST( DAY(wcd.date_value) AS VARCHAR),2) AS INT)
		  END activity_date_key,
          CAST ('Well_Counts' AS VARCHAR (30)) AS accounts,
          rc.rescat AS reserve_category_id,
          cev.cube_child_member AS scenario,
          CAST ('Budget' AS VARCHAR (10)) AS scenario_type,
          CAST (gn.grs_net AS VARCHAR (10)) AS grs_net,
          CAST (
             CASE
                WHEN gn.grs_net = 'GRS'
                THEN
                   cfd.numeric_value / ISNULL (uwi.tract_record_count, 1)
                ELSE
                     cfd.numeric_value
                   * (ISNULL (uwi.tract_working_interest,
                           ISNULL (ed.working_interest_pct, 100) / 100))
             END AS float)
             AS cad,
          CAST (
             CASE
                WHEN gn.grs_net = 'GRS'
                THEN
                   cfd.numeric_value / ISNULL (uwi.tract_record_count, 1)
                ELSE
                     cfd.numeric_value
                   * (ISNULL (uwi.tract_working_interest,
                           ISNULL(ed.working_interest_pct, 100) / 100))
             END AS float)
             AS k_cad,
			 ct.capital_type
FROM (SELECT 'GRS' AS grs_net
           UNION ALL
           SELECT 'WI' ) gn,
     (SELECT 2311 AS rescat 
           UNION ALL
           SELECT 1311 AS rescat) rc,
[stage].t_stg_valnav_budget_ent_custom_field_def cfd
INNER JOIN stage_valnav.t_budget_ENTITY be
ON be.object_id = cfd.parent_id
inner join (
	select cfd.parent_id
		, ltrim(rtrim(cfd.string_value)) as variable_value
		, cfd.cube_child_member
		, cfd.sign_flip_flag
	from (
			select c.*
				, v.cube_child_member, v.sign_flip_flag
				, row_number() over (	partition by parent_id 
										order by case ltrim(rtrim(c.name)) 
												when 'Budget Year' then 3 
												when 'DISTRICT' then 2 
												when 'CAPITAL GROUP' then 1 end) rnk
			FROM [stage].t_stg_valnav_budget_ent_custom_field_def c
			join [stage].t_ctrl_valnav_etl_variables v on ltrim(rtrim(c.string_value)) = v.variable_value
			WHERE ltrim(rtrim(name)) in ('Budget Year', 'DISTRICT', 'CAPITAL GROUP')
			and v.variable_name = 'BUDGET_BUDGET_YEAR'
	) cfd 
	where rnk = 1	
) cev on be.object_id = cev.parent_id
/*
INNER JOIN 
    select * from   (SELECT *
			FROM [stage].dbo.t_stg_valnav_budget_ent_custom_field_def
			WHERE ltrim(rtrim(name)) in ('Budget Year', 'DISTRICT', 'CAPITAL GROUP')) cby
--ON be.object_id = cby.parent_id
INNER JOIN 
			(SELECT variable_value, cube_child_member
             FROM T_CTRL_VALNAV_ETL_VARIABLES
            WHERE variable_name = 'BUDGET_BUDGET_YEAR') cev
ON cby.string_value = cev.variable_value
*/
INNER JOIN
           (SELECT DISTINCT
                  parent_id,
                  FIRST_VALUE (date_value) OVER (PARTITION BY parent_id ORDER BY parent_id)
                     AS date_value
             FROM [stage].t_stg_valnav_budget_ent_custom_field_def
            WHERE name = 'Budget Well Count Qtr') wcd
ON be.object_id = wcd.parent_id
INNER JOIN
		  (SELECT *
			FROM [data_mart].t_dim_entity e
			WHERE is_valnav=1
		  ) ed
ON be.object_id = ed.entity_key
LEFT OUTER JOIN
      (SELECT wi.*,
                  COUNT (
                     working_interest)
                  OVER (
                     PARTITION BY wi.entity_object_id,
                                  wi.effective_date,
								  wi.next_effective_date
                                  ---wi.is_reserves_realized_wi
								  )
                     AS tract_record_count
             FROM [stage].v_valnav_uwi_working_interest wi
            --WHERE wi.is_reserves_realized_wi = 'Y'
			) uwi
ON be.object_id = uwi.entity_object_id
AND (wcd.date_value >= uwi.effective_date AND wcd.date_value < uwi.next_effective_date)
LEFT OUTER JOIN
     (SELECT parent_id,
             name,
             string_value AS capital_type
      FROM [stage].t_stg_valnav_budget_ent_custom_field_def
      WHERE UPPER (LTRIM(RTRIM(NAME))) = 'CAPITAL TYPE') ct
ON be.object_id = ct.parent_id
WHERE cfd.name = 'Well Count'
AND UPPER(RTRIM(LTRIM(ct.capital_type))) = 'DRILLING';