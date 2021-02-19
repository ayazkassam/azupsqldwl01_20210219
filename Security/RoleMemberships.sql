EXECUTE sp_addrolemember @rolename = N'db_owner', @membername = N'statsupdate';


GO
EXECUTE sp_addrolemember @rolename = N'db_owner', @membername = N'svc_ssrs';


GO
EXECUTE sp_addrolemember @rolename = N'db_datareader', @membername = N'ssrs_readonly';

