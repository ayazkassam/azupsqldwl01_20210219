CREATE VIEW [stage_ihs].[v_dim_accumap_wells]
AS select wd.uwi as Bottom_Hole_Location
			, wd.surf_location as Surface_Location
			, substring(wd.uwi, len(wd.uwi)-1, 2) as Current_Event_Sequence
			, wd.Well_Name Well_Name
			, coalesce(wd.licensee_desc,'Unknown') as Current_Licensee
			, wd.license_no as License_Number
			, convert(date,wd.License_Date) License_Date
			, wd.crstatus_desc as Current_Status
			, wd.zone_desc as Zone
			, wd.pool_desc as Pool
			, wd.class_desc as Lahee
			, wd.field_desc as Field
			, convert(date,wd.Spud_Date) Spud_Date
			, convert(date,wd.Rig_Release) Rig_Release
			, coalesce(wd.unit_desc,'Unknown') as Unit
			, concat(w.confidential_type,' ',convert(date,w.confidential_date)) as Confidential_Indicator
			, convert(date,w.current_status_date) as Last_Status_Update
			, convert(date,pd.On_Production_Date) as On_Production_Date
			, wp.long_name as Well_Type
			, wd.province_state Province
			, wd.location
			, wd.well_id
			, wd.tvd_depth
			, wd.total_depth
			, case when wd.uwi is not null 
				then case left(wd.uwi,1)  /*1=DLS, 2=NTS*/
						when 1 then substring(wd.uwi,13,2)
						when 2 then substring(wd.uwi,9,2)
						else ' na_meridian' end end Meridian /*--uwi_level_1*/
			, case when wd.uwi is not null
				then case left(wd.uwi,1)
						when 1 then concat(substring (wd.uwi,11,2), substring (wd.uwi,13,2))
						when 2 then concat(substring (wd.uwi,12,1), substring (wd.uwi,9,2)) 
						else ' na_range' end end Range /*--uwi_level_2*/
			, case when wd.uwi is not null
				then case left(wd.uwi,1)
						when 1 then concat(substring(wd.uwi,8,3), '-', substring(wd.uwi,11,2), substring(wd.uwi,13,2))
						when 2 then concat(substring(wd.uwi,9,2) , '-', substring(wd.uwi,12,1), substring(wd.uwi,13,2)) 
						else ' na_township' end end Township  /*--uwi_level_3*/
			, case when wd.uwi is not null
				then case left(wd.uwi,1)
						when 1 then concat(substring(wd.uwi,6,2), '-', substring(wd.uwi,8,3), '-', substring(wd.uwi,11,2), substring(wd.uwi,13,2))
						when 2 then concat(substring(wd.uwi,4,1), '-', substring(wd.uwi,9,2), '-', substring(wd.uwi,12,1), substring(wd.uwi,13,2)) 
						else ' na_section' end end Section /*uwi_level_4*/
			, coalesce(wd.operator,'Unknown') operator
			, coalesce(wd.operator_abrev,'Unknown') operator_abrev
			, coalesce(wd.operator_desc,'Unknown') operator_desc
			, 1 as well_row_count
			, w.bottom_hole_latitude
			, w.bottom_hole_longitude
			, w.surface_latitude
			, w.surface_longitude
		from [stage_ihs].t_ihs_well_description wd 
		join [stage_ihs].t_ihs_well w on wd.uwi = w.uwi
		left outer join [stage_ihs].t_ihs_pden pd on wd.uwi = pd.pden_id
		left outer join [stage_ihs].t_ihs_r_well_profile_type wp on w.profile_type = wp.well_profile_type;