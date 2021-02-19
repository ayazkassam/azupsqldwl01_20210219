CREATE VIEW [stage].[v_stg_ihs_volumes]
AS SELECT uwi,
       sum(oil) oil,
	   sum(cond) cond,
	   sum(gas) gas,
	   sum(water) water,
	   month,
	   year,
	   cc_num
FROM
(
SELECT uwi,
       --product_type,
	   OIL as oil,
	   COND as cond,
	   GAS as gas,
	   WATER as water,
	   month,
	   year,
	   cc_num,
	   --amount,
	   row_changed_date
--INTO t_stg_ihs_volumes
FROM
(SELECT pden.pden_id uwi,
       case product_type
			when 'P-OIL' then 'OIL'
			when 'P-COND' then 'COND'
			when 'P-GAS' then 'GAS'
			when 'P-WATER' then 'WATER'
	   end product_type,
	   ums.cc_num,
	   year,
	   jan_volume jan,
	   feb_volume feb,
	   mar_volume mar,
	   apr_volume apr,
	   may_volume may,
	   jun_volume jun,
	   jul_volume jul,
	   aug_volume aug,
	   sep_volume sep,
	   oct_volume oct,
	   nov_volume nov,
	   dec_volume dec,
	   row_changed_date
FROM 
    (
	SELECT variable_value ihs_data_start_year
		FROM [stage].[t_ctrl_etl_variables]
		WHERE VARIABLE_NAME='IHS_DATA_START_YEAR'
	) sy,
	(
	SELECT variable_value ihs_data_end_year
	FROM [stage].[t_ctrl_etl_variables]
	WHERE VARIABLE_NAME='IHS_DATA_END_YEAR'
	) ey,
	[stage].[t_ihs_pden_vol_by_month] pden
INNER JOIN 
     (SELECT ums.*
	   FROM [stage].[t_cc_uwi_master_source] ums
	   INNER JOIN [stage].t_cost_centre_hierarchy cc
	   ON ums.cc_num = cc.cost_centre_id
	   ) ums
ON pden.pden_id = ums.uwi
WHERE pden.activity_type='PRODUCTION'
AND   pden.product_type IN ('P-OIL','P-COND','P-GAS','P-WATER')
AND   (pden.year between sy.ihs_data_start_year AND ey.ihs_data_end_year)
) s
UNPIVOT (amount FOR month IN
          (jan, feb, mar, apr, may, jun, jul, aug, sep, oct, nov, dec)
		  ) as amt

PIVOT (min(amount) for product_type in  (OIL,COND,GAS,WATER)
       ) as product
) sd
GROUP BY uwi,month, year, cc_num;