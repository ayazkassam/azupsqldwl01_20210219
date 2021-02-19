CREATE VIEW [stage].[v_valnav_typecurves_price_deck]
AS SELECT DISTINCT vevby.cube_child_member,
                isnull(fpd.name,'NO_Price_Deck') as price_deck
FROM
 	stage_valnav.t_typecurves_RESULTS_LOOKUP rl
    INNER JOIN 
	 (SELECT variable_value, cube_child_member
             FROM STAGE.T_CTRL_VALNAV_ETL_VARIABLES
            WHERE variable_name = 'TYPE_CURVES_RESERVE_CATEGORY_ID') vevrc
	 ON rl.reserve_category_id = vevrc.variable_value
    INNER JOIN
	   (SELECT fsp.plan_id, fs.*
             FROM stage_valnav.t_typecurves_FISC_SCENARIO fs
                  LEFT OUTER JOIN stage_valnav.t_typecurves_FISC_SCENARIO_PARAMS fsp
                     ON (fs.object_id = fsp.parent_id)
          WHERE fs.name = '<Current Options>' ) sn
     ON rl.scenario_id = sn.object_id
     INNER JOIN
		(SELECT *
			FROM [stage].t_stg_valnav_typecurves_ent_custom_field_def
			WHERE upper(name)='BUDGET YEAR') cfd
	 ON rl.entity_id = cfd.parent_id
	 INNER JOIN 
	    (SELECT variable_value, cube_child_member, sign_flip_flag
             FROM stage.T_CTRL_VALNAV_ETL_VARIABLES
            WHERE variable_name = 'TYPE_CURVES_BUDGET_YEAR') vevby
	 ON  ltrim(rtrim(cfd.string_value)) = vevby.variable_value
	 LEFT OUTER JOIN 
	      stage_valnav.t_typecurves_RESULTS_SUMMARY rs
	  ON rl.result_id = rs.result_id
	 LEFT OUTER JOIN
	      stage_valnav.t_typecurves_FISC_PRICE_DECK fpd
	 ON rs.price_deck_id = fpd.object_id
where rl.plan_definition_id = 0;