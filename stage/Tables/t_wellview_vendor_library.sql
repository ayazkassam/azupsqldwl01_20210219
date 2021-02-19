CREATE TABLE [stage].[t_wellview_vendor_library] (
    [Vendor]     VARCHAR (255) NULL,
    [VendorCode] VARCHAR (50)  NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

