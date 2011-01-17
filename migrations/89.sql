DROP TRIGGER IF EXISTS usersettings.RegionalDataLogInsert;

CREATE TRIGGER usersettings.RegionalDataLogInsert AFTER INSERT ON usersettings.RegionalData
FOR EACH ROW
BEGIN
INSERT INTO logs.regional_data_logs
SET LogTime = now() ,
OperatorName = IFNULL(@INUser, SUBSTRING_INDEX(USER(),'@',1)) ,
OperatorHost = IFNULL(@INHost, SUBSTRING_INDEX(USER(),'@',-1)) ,
Operation = 0,
RegionalDataID = NEW.RowId
,RegionCode = NEW.RegionCode
,FirmCode = NEW.FirmCode
,Enabled = NEW.Enabled
,UpCost = NEW.UpCost
,Storage = NEW.Storage
,MinReq = NEW.MinReq
,SupportPhone = NEW.SupportPhone
,ContactInfo = NEW.ContactInfo
,OperativeInfo = NEW.OperativeInfo
,ConfigOrderCode = NEW.ConfigOrderCode;
END;