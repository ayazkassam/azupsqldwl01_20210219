CREATE FUNCTION [Stage].[LPAD] (@string [varchar](max),@pad_length [int],@pad_with [varchar](5000) = ' ') RETURNS VARCHAR(MAX)
AS
BEGIN

		Declare @padrepeated varchar(max)

		if(len(@string) > @pad_length)
		BEGIN
		 RETURN LEFT(@string,@pad_length)
		END
		

		return right(replicate(@pad_with,@pad_length)+''+@string,@pad_length)


END