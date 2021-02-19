CREATE VIEW [stage_export].[v_export_to_oplynxv6]
AS with cte_cats as (
	SELECT CAST (da.cost_centre AS VARCHAR (100)) AS cost_center,
	       cast (da.cost_centre_name as varchar(100)) as costcentrename,
		   da.cc_type_code, 
--		   CAST (da.entity_key AS VARCHAR (50)) uwi,

--		   CAST (wd.LOCATION AS VARCHAR (50)) formatted_uwi,
		   da.surface_latitude,
		   da.surface_longitude,
--		   da.facility, 
		   da.facility_name, 
--		   da.area, 
		   da.area_name, 
--		   da.district, 
		   da.district_name, 
--		   da.cc_type_code, 
		   da.flownet_name,
		   [working_interest_pct]		   
	FROM (
			SELECT * --DISTINCT entity_key uwi
			  FROM [data_mart].t_dim_entity
			  WHERE is_uwi=1
			  AND entity_key > '0'
			  AND SUBSTRING(entity_key,1,1) <> 'W'
	) da
	INNER JOIN [stage].t_ihs_well_description wd
	   ON da.entity_key = wd.uwi
	INNER JOIN [stage].t_ihs_well iw2
	   ON da.entity_key = iw2.uwi
	LEFT OUTER JOIN [stage].t_ihs_pden pd
	   ON da.uwi = pd.pden_id
	LEFT OUTER JOIN [stage].t_ihs_r_well_profile_type wp
	   ON iw2.profile_type = wp.well_profile_type
),

v_oplynx4_event_sequence_info as

(

select * from cte_cats


UNION

select distinct   cast(cost_centre as varchar(100)) as cost_center
				 ,cast(cost_centre_name as varchar(100)) as costcentrename
				 , cc_type_code
				--, cast(entity_key as varchar(50)) uwi

--				, cast(formatted_uwi as varchar(50)) formatted_uwi
				,surface_latitude
				,surface_longitude
--				,facility
				, facility_name
--				, area
				, area_name
--				, district
				, district_name				
				, flownet_name
				,[working_interest_pct]
from data_mart.t_dim_entity
where is_cc_dim=1
and entity_key not in (select distinct cost_center from cte_cats)
and entity_key not in ('-1','-2')
),

v_oplynx5_event_sequence_info as

(
SELECT [cost_center]
      ,[costcentrename]
      ,[cc_type_code]
      ,[surface_latitude]
      ,[surface_longitude]
      ,[facility_name]
      ,[area_name]
      ,[district_name]
      ,[flownet_name]
      ,[working_interest_pct]
      ,oplynx_tag = 
			case 
				when [district_name] = 'District: CORP' and cc_type_code <> 'SLD' then 1
				when [district_name] = 'District: CA' and cc_type_code <> 'SLD' then 1
				when [district_name] = 'District: NCA' and cc_type_code <> 'SLD' then 1
				when [district_name] = 'District: SCA' and cc_type_code <> 'SLD' then 1
				when [district_name] = 'District: EA' and cc_type_code <> 'SLD' then 1
			else 0
	        end
  FROM v_oplynx4_event_sequence_info
  where cc_type_code  not in ('ACQ', 'DIS', 'ACC', 'ADM', 'AGG', 'GCA', 'CRY', 'CNV') and ( [costcentrename]  not like '% Use%' or [costcentrename]  not like '% use%')

  ),

export_cte as
 (
	select ROW_NUMBER() over
	(Partition by [cost_center]
	order by [cost_center] ASC,[flownet_name] DESC  )
	as     RowNumber
	      ,[cost_center] 
	      ,[costcentrename]
	      ,[cc_type_code]
	      ,[surface_latitude]
	      ,[surface_longitude]
	      ,[facility_name]
	      ,[area_name]
	      ,[district_name]
	      ,[flownet_name]
	      ,[working_interest_pct]
	      ,oplynx_tag 
	from v_oplynx5_event_sequence_info
) 

select CAST ([cost_center]				 AS VARCHAR(255)) [cost_center]
      , CAST([costcentrename]			 AS VARCHAR(255)) [costcentrename]
      , CAST([cc_type_code]				 AS VARCHAR(255)) [cc_type_code]
      , CAST([surface_latitude]			 AS VARCHAR(255)) [surface_latitude]
      , CAST([surface_longitude]		 AS VARCHAR(255)) [surface_longitude]
      , CAST([facility_name]			 AS VARCHAR(255)) [facility_name]
      , CAST([area_name]				 AS VARCHAR(255)) [area_name]
      , CAST([district_name]			 AS VARCHAR(255)) [district_name]
      , CAST([flownet_name]				 AS VARCHAR(255)) [flownet_name]
      , CAST([working_interest_pct]		 AS VARCHAR(255)) [working_interest_pct]
      , CAST(oplynx_tag 				 AS VARCHAR(255)) oplynx_tag
from export_cte where RowNumber = 1;