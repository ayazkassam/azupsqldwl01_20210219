CREATE VIEW [dbo].[v_dim_ITTest_Run]
AS select cast('RunDate' as varchar(100)) run_key,
       CONVERT(VARCHAR(19),  GETDATE(), 120)  AS RunDate;