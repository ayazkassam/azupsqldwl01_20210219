CREATE VIEW [data_mart_metrix].[v_dim_sales_tik]
AS select 'ADJINV' Sales_and_TIK, 'Adjustment Inventory' as Sales_and_tik_name union all
select '-1', 'Unknown' union all
select 'BNP', 'Bonavista Marketing Sales' union all
select 'FTIK', 'Fail to Take in Kind' union all
select 'EXCH', 'Error' union all
select 'FHTIK', 'Freehold Take in Kind' union all
select 'INJ', 'Load Oil Injection Sale' union all
select 'INV', 'Inventory' union all
select 'NOOP', 'Non Op' union all
select 'TIK', 'Take in Kind' union all
select 'TSF', 'Transfer';