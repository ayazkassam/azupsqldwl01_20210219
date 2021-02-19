CREATE VIEW [stage].[v_fact_source_opex_accrual_voucher_upload_header]
AS SELECT CAST (acct_period AS NCHAR (10)) acct_period,
          CAST (org_id AS NCHAR (2)) org_id,
          CAST (source_code AS NCHAR (10)) source_code,
          CAST (voucher_type AS NCHAR (10)) voucher_type,
          CAST (currency_code AS NCHAR (10)) currency_code,
          CAST (remarks AS NCHAR (100)) remarks
     FROM (SELECT t.acct_period,
                  org_id,
                  'FIN' source_code,
                  'ACCRU' voucher_type,
                  'CAD' currency_code,
                  'Field Opex Accrual for ' + t.acct_period  remarks
             FROM (SELECT DISTINCT org_id FROM [stage].v_fact_source_opex_accrual_voucher_upload_detail) v,
			      (SELECT concat(year(time_period),
				                 RIGHT(CONCAT('0',month(time_period)),2),
				                 day(time_period)
								 ) acct_period
					from
					(SELECT EOMONTH(DATEADD(MONTH,-1,CURRENT_TIMESTAMP)) time_period) t
				  ) t
			) s;