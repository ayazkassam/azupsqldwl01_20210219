CREATE VIEW [stage_ihs].[v_dim_accumap_operator]
AS select distinct operator
			, operator_abrev
			, operator_desc
		from [stage_ihs].[v_dim_accumap_wells];