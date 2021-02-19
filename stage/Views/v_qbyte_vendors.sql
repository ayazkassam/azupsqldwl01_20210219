CREATE VIEW [stage].[v_qbyte_vendors]
AS select distinct ba.ID AS vendor_key
	, ba.NAME_1 AS vendor_name
	, SUBSTRING(ba.NAME_1, 1,  1) + ' Vendors' AS vendor_alpha_group
	, ba.ba_type_code
	, fa.payment_code
	, coalesce(ba.BA_UDF_1_CODE, 'NA') encana_ba_number
	, coalesce(ba.BA_UDF_2_CODE, 'NA') ba_credit_status
	, coalesce(ba.BA_UDF_3_CODE, 'NA') govt_entity
	, coalesce(ba.BA_UDF_4_CODE, 'NA') govt_parent
	, coalesce(ba.BA_UDF_5_CODE, 'NA') aboriginal
	, ba.BA_UDF_6_CODE parent_id
	, CONVERT (VARCHAR (10), fa.hold_date, 120) as hold_date
	, coalesce(convert(varchar(10),c.ap_credit_days), 'NA')	  ap_credit_days
	, coalesce(convert(varchar(10),c.ar_credit_days), 'NA')	  ar_credit_days
	, ba.inactive_date
 from (	
		select t_qbyte_invoices.CLIENT_ID 
		from [stage].t_qbyte_invoices
	) as inv 
inner join [stage].t_qbyte_business_associates ba on ba.ID = inv.CLIENT_ID
join [stage].t_qbyte_fa_ba_properties fa on ba.id = fa.BA_ID
join [stage].t_qbyte_clients c on ba.id = c.client_id;