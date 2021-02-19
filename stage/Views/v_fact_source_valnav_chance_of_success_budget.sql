CREATE VIEW [stage].[v_fact_source_valnav_chance_of_success_budget]
AS SELECT erc.entity_id entity_key,
	   erc.reserve_category_id,
	   'COS' accounts,
	   'Budget' scenario_type,
	   vev2.cube_child_member scenario,
	   'WI' grs_net,
	   CASE WHEN  rrd.booked_date IS NULL  THEN -1
						 ELSE  CAST(CAST(YEAR(rrd.booked_date) AS VARCHAR) + right(replicate('00',2) + CAST( MONTH(rrd.booked_date) AS VARCHAR),2)
						+ right(replicate('00',2) + CAST( DAY(rrd.booked_date) AS VARCHAR),2) AS INT)
	   END activity_date_key,
	   '-1' normalized_time_key,
	   isnull(erc.chance_of_success,1) * 100 chance_of_success
FROM 
       (SELECT variable_value AS reserve_book_date
             FROM [stage].T_CTRL_VALNAV_ETL_VARIABLES
            WHERE variable_name = 'RESERVE_BOOK_DATE') rbd,
		stage_valnav.t_budget_ent_reserves_category erc
		INNER JOIN 
			(SELECT variable_value
				FROM [stage].T_CTRL_VALNAV_ETL_VARIABLES
				WHERE variable_name = 'RESERVE_CATEGORY_ID') vev
		ON erc.reserve_category_id = vev.variable_value

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
		) vev2 on erc.entity_id = vev2.parent_id

		/*
		INNER JOIN
		select * from (SELECT *
			FROM [stage].dbo.t_stg_valnav_budget_ent_custom_field_def
			WHERE ltrim(rtrim(name)) in ('Budget Year', 'DISTRICT', 'CAPITAL GROUP')) cfd
		--ON erc.entity_id = cfd.parent_id
		INNER JOIN 
	    (SELECT variable_value, cube_child_member, sign_flip_flag
             FROM T_CTRL_VALNAV_ETL_VARIABLES
            WHERE variable_name = 'BUDGET_BUDGET_YEAR') vev2
		ON  ltrim(rtrim(cfd.string_value)) = vev2.variable_value
		*/

		LEFT OUTER JOIN
		(SELECT rrd.parent_id, ISNULL (rrd.date_value, CAST (rbd.reserve_book_date AS datetime)) AS booked_date
		 FROM
		     (SELECT variable_value AS reserve_book_date
             FROM [stage].T_CTRL_VALNAV_ETL_VARIABLES
            WHERE variable_name = 'RESERVE_BOOK_DATE')  rbd,
			(SELECT *
			FROM [stage].t_stg_valnav_budget_ent_custom_field_def
			WHERE ltrim(rtrim(name))='Reserves Realized Date') rrd
		 ) rrd
		ON erc.entity_id = rrd.parent_id
WHERE plan_definition_id=0;