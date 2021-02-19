CREATE TABLE [stage].[t_vendor_invoices] (
    [invc_id]     NUMERIC (10) NULL,
    [vendor_id]   NUMERIC (10) NULL,
    [vendor_name] VARCHAR (40) NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

