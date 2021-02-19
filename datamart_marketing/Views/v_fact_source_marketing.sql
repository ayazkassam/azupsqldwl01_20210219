CREATE VIEW [datamart_marketing].[v_fact_source_marketing]
AS SELECT srv.flownet_id,
	   srv.flownet_name,
	   srv.child_idrec,
	   srv.uwi_name,
	   srv.cc_num,
	   srv.flownet_name + ' - ' + srv.sales_disposition_point sales_disposition_point,
	   srv.sales_disposition_point meter_name,
	   srv.typ,
	   isnull(isnull(doi.ba_name, gdoi.ba_name),'Unknown Partner') partner_name,
	   cast(srv.activity_date as date) activity_date,
	   CAST(YEAR(srv.activity_date) AS VARCHAR)  + 
			 CAST ('_' AS VARCHAR) +
			 right(replicate('00',2) + CAST( MONTH(srv.activity_date) AS VARCHAR),2) activity_year_month,
	   srv.raw_volume * (isnull(isnull(doi.doi,gdoi.working_interest),100) /100) raw_volume,
	   srv.sales_volume * (isnull(isnull(doi.doi,gdoi.working_interest),100) /100) sales_volume,
	   srv.allocated_volume * (isnull(isnull(doi.doi,gdoi.working_interest),100) /100) allocated_volume
	   --gdoi.ba_name,
	   --gdoi.working_interest
	   --isnull(gdoi.working_interest,100) gwi
FROM [datamart_marketing].[v_fact_source_allocated_sales_raw_volumes]  srv
LEFT OUTER JOIN 
	 [datamart_marketing].t_stg_qbyte_cost_centre_doi doi
ON srv.cc_num = doi.cc_num
AND  (srv.activity_date >= doi.effective_date AND srv.activity_date < doi.termination_date)
LEFT OUTER JOIN [datamart_marketing].t_stg_prodview_group_point_doi gdoi
ON srv.flownet_id = gdoi.idflownet
AND srv.child_idrec = gdoi.idrecparent
AND  (srv.activity_date >= gdoi.dttmstart AND srv.activity_date < gdoi.dttmend);