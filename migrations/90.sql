DROP TRIGGER IF EXISTS usersettings.RegionalDataLogUpdate;

CREATE TRIGGER usersettings.RegionalDataLogUpdate AFTER UPDATE ON usersettings.RegionalData
FOR EACH ROW
BEGIN
INSERT INTO `logs`.regional_data_logs
SET LogTime = now() ,
OperatorName = IFNULL(@INUser, SUBSTRING_INDEX(USER(),'@',1)) ,
OperatorHost = IFNULL(@INHost, SUBSTRING_INDEX(USER(),'@',-1)) ,
Operation = 1,
RegionalDataID = OLD.RowId
,RegionCode = IFNULL(NEW.RegionCode, OLD.RegionCode)
,FirmCode = IFNULL(NEW.FirmCode, OLD.FirmCode)
,Enabled = NULLIF(NEW.Enabled, OLD.Enabled)
,UpCost = NULLIF(NEW.UpCost, OLD.UpCost)
,Storage = NULLIF(NEW.Storage, OLD.Storage)
,MinReq = NULLIF(NEW.MinReq, OLD.MinReq)
,SupportPhone = NULLIF(NEW.SupportPhone, OLD.SupportPhone)
,ContactInfo = NULLIF(NEW.ContactInfo, OLD.ContactInfo)
,OperativeInfo = NULLIF(NEW.OperativeInfo, OLD.OperativeInfo)
,ConfigOrderCode = NULLIF(NEW.ConfigOrderCode, OLD.ConfigOrderCode);
END