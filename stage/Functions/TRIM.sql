CREATE FUNCTION [stage].[TRIM] (@string [VARCHAR](MAX)) RETURNS VARCHAR(MAX)
WITH SCHEMABINDING
AS
BEGIN

	-- Return the result of the function
	RETURN LTRIM(RTRIM(@string))

END