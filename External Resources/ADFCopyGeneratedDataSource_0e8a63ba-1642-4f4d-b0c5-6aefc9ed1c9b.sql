CREATE EXTERNAL DATA SOURCE [ADFCopyGeneratedDataSource_0e8a63ba-1642-4f4d-b0c5-6aefc9ed1c9b]
    WITH (
    TYPE = HADOOP,
    LOCATION = N'wasbs://adfstagedpolybasetempdata@bnpwu2prdbiblob01.blob.core.windows.net/',
    CREDENTIAL = [ADFCopyGeneratedCredential_961e73ce-19f0-472c-a479-e8ea1b1499eb]
    );

