CREATE VIEW [STAGE_METRIX].[v_dim_source_metrix_ar_contract]
AS SELECT ar.ar_contract,
	   '111_' + ar.ar_contract sort_key
FROM 
(
SELECT 
        DISTINCT USER_DEFINED1 ar_contract
		
FROM [STAGE_METRIX_METRIX].MARKET_MASTER_PURCH_PRICES
WHERE USER_DEFINED1 is not null
--
UNION
--
SELECT 
        DISTINCT USER_DEFINED1 ar_contract
FROM [STAGE_METRIX_METRIX].PARTNER_OP_BATTERY_PRICES
WHERE USER_DEFINED1 is not null
) ar
-- 
UNION ALL
SELECT 'No Contract' ar_contract,
       '999_NA' sort_key;