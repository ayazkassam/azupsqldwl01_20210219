CREATE VIEW [dbo].[v_fact_volumes] AS select *
	/*determine normalized day counter for prodview*/
	, cast(case when data_type in ('SALES_EST','PRODUCTION') and normalized_month_key <> '-1' and on_production_date_key <> '-1'
					then day(eomonth(dateadd(mm, (convert(int, normalized_month_key)-1), eomonth(convert(date,left(on_production_date_key,6) + '01')))))
				when data_type in ('Valnav-Daily') and normalized_month_key <> '-1' and onstream_date is not null
					then day(eomonth(dateadd(mm, (convert(int, normalized_month_key)-1), eomonth(onstream_date))))

				when data_type in ('Valnav') and normalized_month_key <> '-1' and onstream_date is not null
					then day(eomonth(convert(date,cast(20170831 as varchar(20)))))

				when data_type = 'IHS' and normalized_month_key <> '-1' and on_production_date_key <> '-1'
				      then coalesce(hours_on,0) / 24

			else day_counter1
			end as int) as day_counter
	, case when data_type in ('Valnav','Valnav-Daily') then 'I' else 'A' end as etl_status
	, null as working_interest


	, cast (case when data_type in ('SALES_EST','PRODUCTION','Valnav-Daily') --and normalized_month_key <> '-1' and on_production_date_key <> '-1'
					then 
					  case when normalized_month_key = '-1' 
					       then 0
						   
						   else case when coalesce([total_boe_volume],0) = 0 then 0 else 1 end
					   end

				 when data_type in ('Valnav') 
				     then
					   case when normalized_month_key = '-1' 
					       then 0
						   else case when coalesce([total_boe_volume],0) = 0 
						             then 0
									 else 		
									    case when FORMAT(convert(date,cast(activity_date_key as varchar(20))) ,'yyyyMM') = FORMAT(onstream_date,'yyyyMM')	
										     then  datediff(day, onstream_date,eomonth(convert(date,cast(activity_date_key as varchar(20)))))  + 1 
					                         else day(eomonth(convert(date,cast(activity_date_key as varchar(20)))))
									    end
							    end
                      end

				 when data_type = 'IHS' and normalized_month_key <> '-1' and on_production_date_key <> '-1'
				      then coalesce(hours_on,0) / 24
				 
		         else day_counter1

      end as numeric(8,2)) prodmth_day_counter

from (

SELECT facts.[entity_key]
      ,[activity_date_key]
      ,[scenario_key]
      ,[gross_net_key]
	  , isnull(case when data_type IN ('IHS','QBYTE','Valnav') then 1  
					when data_type IN ('Valnav-Daily') then 

					case when datediff(DAY, vs.onstream_date, cast(cast([activity_date_key] as varchar) as datetime))+1 <= 0 
			   or datediff(month,vs.onstream_date, cast(cast([activity_date_key] as varchar) as datetime))+1 >= cev.production_months_on_cutoff then '-1'
					else datediff(DAY, vs.onstream_date, cast(cast([activity_date_key] as varchar) as datetime)) + 1 end

					else 
			case when datediff(DAY, uwi.on_production_date, cast(cast([activity_date_key] as varchar) as datetime))+1 <= 0 
			   or datediff(month,uwi.on_production_date, cast(cast([activity_date_key] as varchar) as datetime))+1 >= cev.production_months_on_cutoff then '-1'
					else datediff(DAY, uwi.on_production_date, cast(cast([activity_date_key] as varchar) as datetime)) + 1
						end end,-1) as normalized_day_key

	  , case when data_type IN ('Valnav-Daily') 
			then isnull(case when datediff(DAY, vs.onstream_date, cast(cast([activity_date_key] as varchar) as datetime))+1 <= 0 
				or datediff(month,vs.onstream_date, cast(cast([activity_date_key] as varchar) as datetime))+1 >= cev.production_months_on_cutoff then '-1'
					else datediff(MONTH,vs.onstream_date, cast(cast([activity_date_key] as varchar) as datetime))+1
						end,-1)
			else isnull(case when datediff(DAY, uwi.on_production_date, cast(cast([activity_date_key] as varchar) as datetime))+1 <= 0 
				or datediff(month,uwi.on_production_date, cast(cast([activity_date_key] as varchar) as datetime))+1 >= cev.production_months_on_cutoff then '-1'
					else datediff(MONTH,uwi.on_production_date, cast(cast([activity_date_key] as varchar) as datetime))+1
			end,-1) end as normalized_month_key

	  , CASE WHEN  uwi.spud_date IS NULL  or uwi.spud_date < dts.rig_spud_prod_date_start THEN -1
		   ELSE  CAST(CAST(YEAR(uwi.spud_date) AS VARCHAR) + right(replicate('00',2) + CAST( MONTH(uwi.spud_date) AS VARCHAR),2)
						+ right(replicate('00',2) + CAST( DAY(uwi.spud_date) AS VARCHAR),2) AS INT)
	  END spud_date_key,
	  CASE WHEN  uwi.rig_release_date IS NULL  or uwi.spud_date < dts.rig_spud_prod_date_start  THEN -1
		   ELSE  CAST(CAST(YEAR(uwi.rig_release_date) AS VARCHAR) + right(replicate('00',2) + CAST( MONTH(uwi.rig_release_date) AS VARCHAR),2)
						+ right(replicate('00',2) + CAST( DAY(uwi.rig_release_date) AS VARCHAR),2) AS INT)
	  END rig_release_date_key
	   , CASE WHEN  uwi.on_production_date IS NULL  or uwi.spud_date < dts.rig_spud_prod_date_start  THEN -1
		   ELSE  CAST(CAST(YEAR(uwi.on_production_date) AS VARCHAR) + right(replicate('00',2) + CAST( MONTH(uwi.on_production_date) AS VARCHAR),2)
						+ right(replicate('00',2) + CAST( DAY(uwi.on_production_date) AS VARCHAR),2) AS INT)
	  END on_production_date_key

	  , CASE WHEN  uwi.last_production_date IS NULL  or uwi.spud_date < dts.rig_spud_prod_date_start  THEN -1
		   ELSE  cast(convert(varchar(8),convert(datetime,last_production_date),112) as int)
	  END last_production_date_key,

	  CASE WHEN  uwi.cc_create_date IS NULL  or uwi.spud_date < dts.rig_spud_prod_date_start  THEN -1
		   ELSE  CAST(CAST(YEAR(uwi.cc_create_date) AS VARCHAR) + right(replicate('00',2) + CAST( MONTH(uwi.cc_create_date) AS VARCHAR),2)
						+ right(replicate('00',2) + CAST( DAY(uwi.cc_create_date) AS VARCHAR),2) AS INT)
	  END cc_create_date_key,
	  CASE WHEN  uwi.cc_termination_date IS NULL   or uwi.spud_date < dts.rig_spud_prod_date_start THEN -1
		   ELSE  CAST(CAST(YEAR(uwi.cc_termination_date) AS VARCHAR) + right(replicate('00',2) + CAST( MONTH(uwi.cc_termination_date) AS VARCHAR),2)
						+ right(replicate('00',2) + CAST( DAY(uwi.cc_termination_date) AS VARCHAR),2) AS INT)
	  END cc_termination_date_key

      ,[gas_metric_volume]
      ,[gas_imperial_volume]
      ,[gas_boe_volume]
      ,[gas_mcfe_volume]
      ,[oil_metric_volume]
      ,[oil_imperial_volume]
      ,[oil_boe_volume]
      ,[oil_mcfe_volume]
      ,[ethane_metric_volume]
      ,[ethane_imperial_volume]
      ,[ethane_boe_volume]
      ,[ethane_mcfe_volume]
      ,[propane_metric_volume]
      ,[propane_imperial_volume]
      ,[propane_boe_volume]
      ,[propane_mcfe_volume]
      ,[butane_metric_volume]
      ,[butane_imperial_volume]
      ,[butane_boe_volume]
      ,[butane_mcfe_volume]
      ,[pentane_metric_volume]
      ,[pentane_imperial_volume]
      ,[pentane_boe_volume]
      ,[pentane_mcfe_volume]
      ,[condensate_metric_volume]
      ,[condensate_imperial_volume]
      ,[condensate_boe_volume]
      ,[condensate_mcfe_volume]
      ,[total_ngl_metric_volume]
      ,[total_ngl_imperial_volume]
      ,[total_ngl_boe_volume]
      ,[total_ngl_mcfe_volume]
      ,[total_liquid_metric_volume]
      ,[total_liquid_imperial_volume]
      ,[total_liquid_boe_volume]
      ,[total_liquid_mcfe_volume]
      ,[total_boe_volume]
      ,[water_metric_volume]
      ,[water_imperial_volume]
      ,[water_boe_volume]
      ,[water_mcfe_volume]
      ,[hours_on]
      ,[hours_down]
      ,[casing_pressure]
      ,[tubing_pressure]
	  ,injected_produced_water
	  ,injected_source_water
	  ,injected_pressure_kpag
	  ,injected_gas_C02
	  ,joints_to_fluid
	  ,strokes_per_minute
	  ,bsw
	  , data_type
		/*the aggregate in the cube on DAY_COUNTER is MIN*/
	  , CASE WHEN scenario_key in ('Accumap','Sales_Actual') and activity_date_key not in ('-1','-2')
				then day(cast(cast(activity_date_key as varchar(8)) as datetime))	
		else 1 END as day_counter1
	, vs.onstream_date
  FROM 
  (SELECT int_value production_months_on_cutoff
   FROM [stage].[t_ctrl_etl_variables]
   WHERE variable_name='PRODUCTION_MONTHS_ON_CUTOFF'
   ) cev,
  (SELECT date_value rig_spud_prod_date_start
   FROM [stage].[t_ctrl_etl_variables]
   WHERE variable_name='RIG_SPUD_ON_PROD_DATE_START_YEAR'
   ) dts,
   (SELECT *
    FROM [data_mart].[t_fact_fdc] facts
    WHERE substring(CAST(activity_date_key AS varchar(10)),1,4) BETWEEN
      (SELECT int_value start_year
		FROM [stage].t_ctrl_etl_variables
		WHERE variable_name='VOLUMES_ACTIVITY_DATE_START_YEAR'
	   ) 
   AND
	(SELECT int_value end_year
	FROM [stage].t_ctrl_etl_variables
	WHERE variable_name='VOLUMES_ACTIVITY_DATE_END_YEAR')



	) facts
  LEFT OUTER JOIN 
	   ( 
	   SELECT entity_key, 
	        cast(spud_date as datetime) spud_date, 
	        cast(rig_release_date as datetime) rig_release_date,
			cast(on_production_date as datetime) on_production_date, 
			cast(last_production_date as datetime) last_production_date, 
			case when isdate(create_date) = 0 then null else cast(create_date as datetime) end cc_create_date,
			case when isdate(cc_term_date) = 0 then null else cast(cc_term_date as datetime) end cc_termination_date
		  FROM [data_mart].[t_dim_entity]
       ) uwi
  ON facts.entity_key = uwi.entity_key
  left outer join (
		select distinct os.unique_id uwi
			, first_value(os.first_step_date) over (partition by unique_id order by os.first_step_date) onstream_date
		from stage.t_valnav_onstream_date_budget os
		where unique_id is not null
	) vs on facts.entity_key = vs.uwi
) sq;