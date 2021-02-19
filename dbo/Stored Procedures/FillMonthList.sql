CREATE PROC [dbo].[FillMonthList] AS
begin
	SET NOCOUNT ON
	truncate table dbo.StrMonthList
	declare @cnt decimal(2,0)

	set @cnt = 1
	while @cnt <= 12
	begin
		insert into dbo.StrMonthList(month_num)
		select RIGHT(REPLICATE('0',2) + cast(@cnt as varchar(2)), 2)
		set @cnt = @cnt + 1

	end 

	SELECT 12

end