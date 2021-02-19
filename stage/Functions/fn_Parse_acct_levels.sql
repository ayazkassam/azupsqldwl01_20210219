CREATE FUNCTION [stage].[fn_Parse_acct_levels] (@STR [VARCHAR](8000),@separator [VARCHAR](16),@position [int]) RETURNS Varchar(1000)
AS
BEGIN
/*DECLARE
   
    @TableArray TABLE 
	(
	 ik INT IDENTITY, 
	 Item VARCHAR(128)
	 )

	 */

/* Splits passed string into items based on the specified separator string
 Parameters:
	@str  - The string to split
	@separator - The separator string ( comma is default)
 Returns table variable with two columns:
   ik int - Item number 	
   Item varchar(128) - Item itself
*/
 

	DECLARE
    @Item VARCHAR(128),
	@pos INT,
	@res VARCHAR(8000)

	/*WHILE DATALENGTH(@STR) > 0
	BEGIN
		SET @pos = CHARINDEX(@separator, @STR)
		IF @pos = 0 
			SET @pos = DATALENGTH(@STR)+1
 
		SET @Item = LEFT(@STR, @pos -1 )
		SET @STR = SUBSTRING(@STR, @pos + DATALENGTH(@separator), 8000)
		INSERT INTO @TableArray (Item) VALUES(@Item)
	END
 
    SELECT @res = item
	FROM @TableArray
	WHERE ik = @position;*/

   --   SELECT
	  --  @res = value
	  --FROM
	  --  (
	  --    SELECT 
	  --      ROW_NUMBER() OVER (ORDER BY (SELECT 1)) rn ,
		 --   ltrim(rtrim(value)) value
	  --    FROM
	  --      (
	  --        SELECT value FROM STRING_SPLIT(@STR, '/')
	  --      ) rez
	  --    WHERE 
	  --      ltrim(rtrim(value)) <> ''
	  --  ) it
   --   WHERE it.rn = @position
    

	RETURN isnull(@res,null)
 
END