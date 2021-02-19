CREATE VIEW [stage].[v_stg_on_prod_dates]
AS SELECT DISTINCT uwi
	, first_value(on_prod_date) over (partition by uwi order by win_order) on_prod_date
	, case first_value(win_order) over (partition by uwi order by win_order) 
		when 1 then 'Prodview Manual' 
		when 3 then 'PVR' 
		when 4 then 'Avocet' 
		when 5 then 'Prodview' 
		when 2 then 'IHS' end as Data_Source
FROM (

	select distinct uwi
		, convert(varchar(50),CAST(engineering_on_prod_date AS DATE)) on_prod_date
		, 1 as win_order
	from [stage].t_prodview_attributes 
	where engineering_on_prod_date is not null

	union all

	SELECT uwi
		, onstream_date
		, 3 win_order
	FROM [stage].t_pvr_uwi_onstream_dates
	--
	UNION ALL
	--
	SELECT DISTINCT uwi
		, min(onstream_date) over (partition by uwi) onstream_date
		, 4 win_order
	FROM [stage].t_avocet_ontream_dates
	--
	UNION ALL
	--
	SELECT DISTINCT uwi
		, min(onstream_date) over (partition by uwi) onstream_date
		, 5 win_order
	FROM [stage].[t_prodview_onstream_dates]

	union all

	select distinct uwi
		, on_production_date
		, 2 win_order
	from [stage].t_ihs_attributes
	where on_production_date is not null
) s;