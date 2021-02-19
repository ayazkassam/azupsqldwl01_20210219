﻿CREATE VIEW [dbo].[v_fact_ap_ar]
AS SELECT [invc_type_code]
      ,[ba_id]
	  ,[invc_id]
      ,[invc_num]
      ,[invoice_date]
      ,[org_id]
      ,[accounting_month]
      ,[due_date]
	  ,[voucher_id]
      ,[voucher_type_code]
      ,[voucher_num]
      ,[cad]
	  ,[invoice_amount]
FROM [data_mart].t_fact_ap_ar;