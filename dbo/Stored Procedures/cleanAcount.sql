CREATE PROC [dbo].[cleanAcount] AS
begin
	truncate table [dbo].[t_dim_account_capital_clean]
end