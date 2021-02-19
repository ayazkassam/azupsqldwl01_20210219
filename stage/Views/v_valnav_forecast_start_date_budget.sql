CREATE VIEW [stage].[v_valnav_forecast_start_date_budget]
AS SELECT formatted_id,
		    object_id,
			unique_id,
			manual_date,
			input_forecast_date,
			segment_start_date,
			-- minimun of 3 dates: manual_date, input_forecast_date, segment_start_date
			CASE WHEN
				(CASE WHEN ISNULL(manual_date, '12/31/2999') < ISNULL(input_forecast_date, '12/31/2999')
					THEN ISNULL(manual_date, '12/31/2999')
					ELSE ISNULL(input_forecast_date, '12/31/2999')
				 END)
				 >    segment_start_date
				 THEN segment_start_date
				 ELSE 
				 (CASE WHEN ISNULL(manual_date, '12/31/2999') < ISNULL(input_forecast_date, '12/31/2999')
					THEN ISNULL(manual_date, '12/31/2999')
					ELSE ISNULL(input_forecast_date, '12/31/2999')
				 END)
		   END forecast_start_date
	 FROM
	 (
	 SELECT DISTINCT e.formatted_id,
				     e.object_id,
					 e.unique_id,
					 --s.start_date,
	
		   --mfu.*,
					MIN(mfu.manual_date) OVER (PARTITION BY e.object_id) manual_date,
					MIN(eof.forecast_date) OVER (PARTITION By e.object_id) input_forecast_date,
					MIN(s.start_date) OVER (PARTITION BY e.object_id) segment_start_date
	 FROM stage_valnav.t_budget_ENTITY e
	 --
	 LEFT OUTER JOIN stage_valnav.t_budget_ENT_FORECAST_INPUTS fis 
	 ON e.object_id = fis.entity_id
	 --
	 LEFT OUTER JOIN stage_valnav.t_budget_ENT_FORECAST_INPUT fi
	 ON fis.object_id = fi.parent_id
	 --
	 LEFT OUTER JOIN stage_valnav.t_budget_ENT_MANUAL_FORECAST mf
	 ON fi.object_id = mf.parent_id
	 --
	 LEFT OUTER JOIN stage_valnav.t_budget_ENT_MANUAL_FORECAST_VALUE mfu
	 ON mf.object_id = mfu.parent_id 
	 --
	 LEFT OUTER JOIN stage_valnav.t_budget_ENT_OTHER_FORECAST eof
	 ON fis.OBJECT_ID = eof.parent_id
	 --
	 JOIN stage_valnav.t_budget_ENT_RESERVES_CATEGORY rc
	 ON rc.object_id = fis.parent_id
	 --
	 --
	 --------
	  LEFT OUTER JOIN stage_valnav.t_budget_ENT_DECLINE d
	 ON fi.object_id = d.parent_id
	 --
	 LEFT OUTER JOIN stage_valnav.t_budget_ENT_SEGMENT s
	 ON d.object_id = s.parent_id 
	 --
	JOIN 
	     ( SELECT DISTINCT parent_id,
		    --min(start_date) over (partition by parent_id) min_start_date,
	         min(segment_index) over(partition by parent_id) min_segment_index
			FROM stage_valnav.t_budget_ENT_SEGMENT 
		 ) ms
	 ON s.parent_id = ms.parent_id
	 AND s.segment_index = ms.min_segment_index
	 --------
	 WHERE 
	 rc.PLAN_DEFINITION_ID=0
	 and rc.RESERVE_CATEGORY_ID='1311'
	 ) SRC;