DROP TRIGGER IF EXISTS usersettings.RegionalDataLogDelete;

CREATE TRIGGER usersettings.RegionalDataLogDelete AFTER DELETE ON usersettings.RegionalData
FOR EACH ROW
BEGIN
INSERT INTO `logs`.regional_data_logs
SET LogTime = now() ,
OperatorName = IFNULL(@INUser, SUBSTRING_INDEX(USER(),'@',1)) ,
OperatorHost = IFNULL(@INHost, SUBSTRING_INDEX(USER(),'@',-1)) ,
Operation = 2,
RegionalDataID = OLD.RowId
,RegionCode = OLD.RegionCode
,FirmCode = OLD.FirmCode
,Enabled = OLD.Enabled
,UpCost = OLD.UpCost
,Storage = OLD.Storage
,MinReq = OLD.MinReq
,SupportPhone = OLD.SupportPhone
,ContactInfo = OLD.ContactInfo
,OperativeInfo = OLD.OperativeInfo
,ConfigOrderCode = OLD.ConfigOrderCode;
END;