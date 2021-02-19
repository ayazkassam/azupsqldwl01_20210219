CREATE VIEW [stage].[iv_vendor_invoices]
AS SELECT 
       i.invc_id, ba.id AS vendor_id, ba.name_1 AS vendor_name
  FROM [Stage].[t_qbyte_business_associates] ba,
       [Stage].[t_qbyte_invoices] i
 WHERE ba.id = ISNULL (i.client_id, 1);