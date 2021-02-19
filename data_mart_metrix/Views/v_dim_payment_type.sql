CREATE VIEW [data_mart_metrix].[v_dim_payment_type]
AS select 'INCOME' as Payment_Type, 'Income' as Payment_Type_Name union all
select 'OTHER', 'Other' union all
select 'SELF', 'Paid By Self' union all
select 'TIK', 'Take in Kind';