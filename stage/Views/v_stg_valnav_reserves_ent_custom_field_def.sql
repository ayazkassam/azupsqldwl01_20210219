CREATE VIEW [stage].[v_stg_valnav_reserves_ent_custom_field_def]
AS SELECT cf.parent_id,
       cd.NAME,
       cast (cf.string_value as varchar(100)) string_value,
       cf.date_value,
       cf.numeric_value
  FROM stage_valnav.t_reserves_ENT_CUSTOM_FIELD cf,
	   stage_valnav.t_reserves_CUSTOM_FIELD_DEF cd
 WHERE cf.user_field_id = cd.object_id;