CREATE VIEW [stage].[v_fact_source_powervision]
AS SELECT pwv.*,
       CASE
           WHEN maj.net_major_acct IS NULL 
           THEN pwv.major_acct + '_' + pwv.minor_acct
           ELSE maj.net_major_acct + '_' + pwv.minor_acct
       END net_acct
FROM
(SELECT d.org_id,
d.afe_num,
d.afe_desc,
d.cc_num,
d.cc_desc,
d.account,
CASE WHEN SUBSTRING(h.document,1,2) = 'CR'
     THEN d.reporting_curr_amt * -1
	 ELSE d.reporting_curr_amt
END reporting_curr_amt,
h.pwr_ba_info,
h.invc_num,
h.invc_date,
d.actvy_per_date,
h.pwr_create_date,
h.document,
d.account_desc,
h.pwr_wf_path,
h.create_user,
h.pwr_last_approver,
h.invc_amt,
substring(d.account,1,4) major_acct,
substring(d.account,6,3) minor_acct,
h.voucher_type_code,
h.ba_id
FROM [stage].[t_pwv_ap_detail_tbl] d
INNER JOIN
     (SELECT * 
	 FROM [stage].[t_pwv_ap_header_tbl] h
	 WHERE (( h.pwr_status < 998 AND h.pwr_status > -100 ) OR h.pwr_status is null)
	 ) h 
ON d.pwr_id = h.pwr_id
WHERE d.reporting_curr_amt <> 0
) pwv
--
LEFT OUTER JOIN [stage].[t_qbyte_major_accounts] maj
  ON pwv.major_acct = maj.major_acct;