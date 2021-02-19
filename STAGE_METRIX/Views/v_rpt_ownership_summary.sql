CREATE VIEW [STAGE_METRIX].[v_rpt_ownership_summary] AS select f.OWNER_ID 
		+ ' (' + replace(replace(replace(o.Owner_Name,'.',''),',',''),'&','and') + ') ' 
		+ replace(convert(varchar(20),getdate(),106),' ','') as FileName
	, convert(varchar(20),f.OWNER_ID) OWNER_ID
	, '\\bonavista.local\dfs\groups\Accounting\Shared Accounting\Shared Projects\Production Accounting\Fees\Monthly Fee Backup\' + convert(varchar(6),ACCOUNTING_DATE) as FilePath
	, convert(varchar(6),ACCOUNTING_DATE) ACCOUNTING_DATE
from (
	select fc.OWNER_ID, fc.ACCOUNTING_DATE, sum(fc.net_value + fc.net_volume) as PresentValues
	from stage_metrix_metrix.fc_expense_income_reports fc
	where fc.ACCOUNTING_DATE = (select max(closed_accounting_date) 
								from stage_metrix_metrix.control_group_amendment_hist)
	and report_title = 'Expense Owner'
	group by fc.OWNER_ID, fc.ACCOUNTING_DATE
	having sum(fc.net_value + fc.net_volume) <> 0
) f
left outer join data_mart_metrix.t_dim_owner o on f.OWNER_ID = o.Owner_ID;