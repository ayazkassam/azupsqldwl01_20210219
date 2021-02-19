CREATE PROC [stage].[sp_update_wellview_vendor_id] AS
BEGIN
  SET NOCOUNT ON

	/*update missing vendorcode based on matching vendor name in datamart*/ 
     IF OBJECT_ID('tempdb..#vnd') IS NOT NULL
       DROP TABLE #vnd	 

     CREATE TABLE #vnd WITH (DISTRIBUTION = ROUND_ROBIN)
     AS
       select distinct 
	     vendor_key, 
		 vendor_id
	   from 
	     [data_mart].[t_dim_vendor]

	update stage.t_wellview_wvt_wvjobreportcostgen
	set vendorcode = #vnd.vendor_key
	from #vnd
	where #vnd.vendor_id = stage.t_wellview_wvt_wvjobreportcostgen.vendor
	and stage.t_wellview_wvt_wvjobreportcostgen.vendorcode is null


	/*update missing vendorcode based on matching vendorname in wellview vendor library -- static table provided by Gillian Aug 2015*/
     IF OBJECT_ID('tempdb..#vnd') IS NOT NULL
       DROP TABLE #vnd	 

     CREATE TABLE #vnd WITH (DISTRIBUTION = ROUND_ROBIN)
     AS
       SELECT distinct 
	     vendorcode, 
		 vendor
	   FROM 
	     [stage].t_wellview_vendor_library

	update stage.t_wellview_wvt_wvjobreportcostgen
	set vendorcode = #vnd.vendorcode
	from #vnd
	where #vnd.vendor = stage.t_wellview_wvt_wvjobreportcostgen.vendor
	and stage.t_wellview_wvt_wvjobreportcostgen.vendorcode is null

	/*update missing vendorcode based on matching vendorname to siteview vendors (ie those that already have codes assoicated with them)*/
     IF OBJECT_ID('tempdb..#vnd') IS NOT NULL
       DROP TABLE #vnd	 

     CREATE TABLE #vnd WITH (DISTRIBUTION = ROUND_ROBIN)
     AS
	    SELECT distinct 
			vendorcode, 
			vendor
		FROM 
			stage.t_wellview_wvt_wvjobreportcostgen
		WHERE 
			vendorcode IS not null

	update stage.t_wellview_wvt_wvjobreportcostgen
	set vendorcode = #vnd.vendorcode
	from #vnd
	where #vnd.vendor = stage.t_wellview_wvt_wvjobreportcostgen.vendor
	and stage.t_wellview_wvt_wvjobreportcostgen.vendorcode is null
END