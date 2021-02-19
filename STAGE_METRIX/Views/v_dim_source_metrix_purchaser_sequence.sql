CREATE VIEW [STAGE_METRIX].[v_dim_source_metrix_purchaser_sequence]
AS SELECT DISTINCT cast(PURCHASER_SEQUENCE as varchar(10)) purchaser_sequence
FROM [STAGE_METRIX_METRIX].MARKET_MASTER_PURCHASERS;