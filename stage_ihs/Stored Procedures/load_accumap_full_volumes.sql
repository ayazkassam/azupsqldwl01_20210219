CREATE PROC [stage_ihs].[load_accumap_full_volumes] AS
BEGIN
	SET NOCOUNT ON

	declare @cutoffYear int
	set @cutoffYear = (select int_value start_year from stage.t_ctrl_etl_variables where variable_name='VOLUMES_ACTIVITY_DATE_START_YEAR') 

	----------------------------------------------------------------
	/*pull production volumes for the specified products and years*/
	----------------------------------------------------------------
	truncate table stage_ihs.t_stg_accumap_volumes_by_month
	insert into stage_ihs.t_stg_accumap_volumes_by_month

	select pden.pden_id uwi
		, replace(product_type,'p-','') product_type
		, year
		, jan_volume jan
		, feb_volume feb
		, mar_volume mar
		, apr_volume apr
		, may_volume may
		, jun_volume jun
		, jul_volume jul
		, aug_volume aug
		, sep_volume sep
		, oct_volume oct
		, nov_volume nov
		, dec_volume dec
	from stage_ihs.[t_ihs_pden_vol_by_month] pden
	where pden.activity_type='production'
	and pden.product_type in ('p-oil','p-gas','p-water','p-cond','p-hour')
	and year >= @cutoffYear

	--SET @rowcnt = @@ROWCOUNT

	-----------------------------------------------
	/* unpivot the production months per product */
	-----------------------------------------------

	truncate table stage_ihs.t_fact_source_accumap_volumes

	insert into stage_ihs.t_fact_source_accumap_volumes
	select uwi
		, amount as oil
		, cast(null as float) gas
		, cast(null as float) water
		, cast(null as float) cond
		, cast(null as float) p_hour
		, eomonth(convert(date,concat(convert(varchar(4),year),'-',month,'-1'))) as Date
	from stage_ihs.t_stg_accumap_volumes_by_month
	unpivot (amount for month in (jan, feb, mar, apr, may, jun, jul, aug, sep, oct, nov, dec)) as amt
	where product_type = 'oil'
	
	--SET @rowcnt = @rowcnt + @@ROWCOUNT

	insert into stage_ihs.t_fact_source_accumap_volumes
	select uwi
		, cast(null as float) oil
		, amount as gas
		, cast(null as float) water
		, cast(null as float) cond
		, cast(null as float) p_hour
		, eomonth(convert(date,concat(convert(varchar(4),year),'-',month,'-1'))) as Date
	from stage_ihs.t_stg_accumap_volumes_by_month
	unpivot (amount for month in (jan, feb, mar, apr, may, jun, jul, aug, sep, oct, nov, dec)) as amt
	where product_type = 'gas'

	--SET @rowcnt = @rowcnt + @@ROWCOUNT

	insert into stage_ihs.t_fact_source_accumap_volumes
	select uwi
		, cast(null as float) oil
		, cast(null as float) gas
		, amount as water
		, cast(null as float) cond
		, cast(null as float) p_hour
		, eomonth(convert(date,concat(convert(varchar(4),year),'-',month,'-1'))) as Date
	from stage_ihs.t_stg_accumap_volumes_by_month
	unpivot (amount for month in (jan, feb, mar, apr, may, jun, jul, aug, sep, oct, nov, dec)) as amt
	where product_type = 'water'
	
	--SET @rowcnt = @rowcnt + @@ROWCOUNT

	insert into stage_ihs.t_fact_source_accumap_volumes
	select uwi
		, cast(null as float) oil
		, cast(null as float) gas
		, cast(null as float) water
		, cast(null as float) cond
		, amount p_hour
		, eomonth(convert(date,concat(convert(varchar(4),year),'-',month,'-1'))) as Date
	from stage_ihs.t_stg_accumap_volumes_by_month
	unpivot (amount for month in (jan, feb, mar, apr, may, jun, jul, aug, sep, oct, nov, dec)) as amt
	where product_type = 'hour'

	--SET @rowcnt = @rowcnt + @@ROWCOUNT

	insert into stage_ihs.t_fact_source_accumap_volumes
	select uwi
		, cast(null as float) oil
		, cast(null as float) gas
		, cast(null as float) water
		, amount as cond
		, cast(null as float) p_hour
		, eomonth(convert(date,concat(convert(varchar(4),year),'-',month,'-1'))) as Date
	from stage_ihs.t_stg_accumap_volumes_by_month
	unpivot (amount for month in (jan, feb, mar, apr, may, jun, jul, aug, sep, oct, nov, dec)) as amt
	where product_type = 'cond'

	--SET @rowcnt = @rowcnt + @@ROWCOUNT

	insert into stage_ihs.t_fact_source_accumap_volumes
	/*roll up prior period volumes*/
	select pden.pden_id uwi
		, sum(case when replace(product_type,'p-','') = 'oil' 
				then jan_volume + feb_volume + mar_volume + apr_volume + may_volume + jun_volume + jul_volume 
					+ aug_volume + sep_volume + oct_volume + nov_volume + dec_volume end) oil
		, sum(case when replace(product_type,'p-','') = 'gas' 
				then jan_volume + feb_volume + mar_volume + apr_volume + may_volume + jun_volume + jul_volume 
					+ aug_volume + sep_volume + oct_volume + nov_volume + dec_volume end)
		, sum(case when replace(product_type,'p-','') = 'water' 
				then jan_volume + feb_volume + mar_volume + apr_volume + may_volume + jun_volume + jul_volume 
					+ aug_volume + sep_volume + oct_volume + nov_volume + dec_volume end)
		, sum(case when replace(product_type,'p-','') = 'cond' 
				then jan_volume + feb_volume + mar_volume + apr_volume + may_volume + jun_volume + jul_volume 
					+ aug_volume + sep_volume + oct_volume + nov_volume + dec_volume end)
		, sum(case when replace(product_type,'p-','') = 'hour' 
				then jan_volume + feb_volume + mar_volume + apr_volume + may_volume + jun_volume + jul_volume 
					+ aug_volume + sep_volume + oct_volume + nov_volume + dec_volume end)
		, convert(date,concat(convert(varchar(4),@cutoffYear-1),'1231')) as Date
	from stage_ihs.[t_ihs_pden_vol_by_month] pden
	where pden.activity_type='production'
	and pden.product_type in ('p-oil','p-gas','p-water','p-cond','p-hour')
	and year < @cutoffYear
	group by pden.pden_id


	--SET @rowcnt = @rowcnt + @@ROWCOUNT
	SELECT 1
END