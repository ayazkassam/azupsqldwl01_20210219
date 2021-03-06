﻿CREATE VIEW [dbo].[v_dim_vendor]
AS SELECT [vendor_key]
      ,[vendor_id]
      ,[vendor_grouping]
      ,[vendor_alias]
      ,[vendor_sort]
      ,[invoice_id]
	  ,[ba_type_code]
	  ,[payment_code]
	  ,[encana_ba_number]
	  ,[ba_credit_status]
	  ,[govt_entity]
	  ,[govt_parent]
	  ,[aboriginal]
	  ,[hold_date]
	  ,[ap_credit_days]
	  ,[ar_credit_days]
	  ,LEFT(CONVERT(VARCHAR, [inactive_date], 120), 10) as [inactive_date]
  FROM [data_mart].[t_dim_vendor];