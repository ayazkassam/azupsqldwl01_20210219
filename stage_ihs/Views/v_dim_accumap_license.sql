CREATE VIEW [stage_ihs].[v_dim_accumap_license]
AS select distinct Current_Licensee
	, License_Number
	, License_Date
from [stage_ihs].[v_dim_accumap_wells];