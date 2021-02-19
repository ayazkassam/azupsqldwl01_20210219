CREATE FUNCTION [stage].[Translate] (@sourceString [VARCHAR](8000),@searchMap [VARCHAR](8000),@replacementMap [VARCHAR](8000)) RETURNS VARCHAR (8000)
AS
BEGIN

DECLARE @cPos int, @maxCPos int

SET @maxCPos = Len(@searchMap)
SET @cPos = 1

WHILE @cpos <= @maxCPos
BEGIN
  SET @sourceString = REPLACE (@sourceString, SUBSTRING (@searchMap, @cpos, 1), SUBSTRING (@replacementMap, @cpos, 1))
  SET @cPos = @cPos + 1
END

RETURN @sourceString

END