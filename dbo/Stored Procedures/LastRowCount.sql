CREATE PROC [dbo].[LastRowCount] @Count [int] OUT AS
BEGIN
SET @Count =
(SELECT
TOP 1 row_count
FROM sys.dm_pdw_request_steps
WHERE row_count >= 0
AND request_id IN (SELECT TOP 1 request_id
FROM sys.dm_pdw_exec_requests
WHERE session_id = SESSION_ID()
AND resource_class IS NOT NULL
ORDER BY end_time DESC) 
)
END;