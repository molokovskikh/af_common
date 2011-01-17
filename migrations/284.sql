drop trigger if exists usersettings.RegionalDataLogDelete;
CREATE DEFINER = 'RootDBMS'@'127.0.0.1' TRIGGER usersettings.RegionalDataLogDelete AFTER DELETE ON usersettings.RegionalData FOR EACH ROW
BEGIN
INSERT INTO `logs`.regional_data_logs
SET LogTime = now() ,
OperatorName = IFNULL(@INUser, SUBSTRING_INDEX(USER(),'@',1)) ,
OperatorHost = IFNULL(@INHost, SUBSTRING_INDEX(USER(),'@',-1)) ,
Operation = 2,
RegionalDataID = OLD.RowId,
RegionCode = OLD.RegionCode,
FirmCode = OLD.FirmCode,
Enabled = OLD.Enabled,
UpCost = OLD.UpCost,
Storage = OLD.Storage,
MinReq = OLD.MinReq,
SupportPhone = OLD.SupportPhone,
ContactInfo = OLD.ContactInfo,
OperativeInfo = OLD.OperativeInfo,
ConfigOrderCode = OLD.ConfigOrderCode;
END;

drop trigger if exists usersettings.RegionalDataLogUpdate;
CREATE DEFINER = 'RootDBMS'@'127.0.0.1' TRIGGER usersettings.RegionalDataLogUpdate AFTER UPDATE ON usersettings.RegionalData FOR EACH ROW
BEGIN
INSERT INTO `logs`.regional_data_logs
SET LogTime = now() ,
OperatorName = IFNULL(@INUser, SUBSTRING_INDEX(USER(),'@',1)) ,
OperatorHost = IFNULL(@INHost, SUBSTRING_INDEX(USER(),'@',-1)) ,
Operation = 1,
RegionalDataID = OLD.RowId,
RegionCode = IFNULL(NEW.RegionCode, OLD.RegionCode),
FirmCode = IFNULL(NEW.FirmCode, OLD.FirmCode),
Enabled = NULLIF(NEW.Enabled, OLD.Enabled),
UpCost = NULLIF(NEW.UpCost, OLD.UpCost),
Storage = NULLIF(NEW.Storage, OLD.Storage),
MinReq = NULLIF(NEW.MinReq, OLD.MinReq),
SupportPhone = NULLIF(NEW.SupportPhone, OLD.SupportPhone),
ContactInfo = NULLIF(NEW.ContactInfo, OLD.ContactInfo),
OperativeInfo = NULLIF(NEW.OperativeInfo, OLD.OperativeInfo),
ConfigOrderCode = NULLIF(NEW.ConfigOrderCode, OLD.ConfigOrderCode);
END;

drop trigger if exists usersettings.RegionalDataLogInsert;
CREATE DEFINER = 'RootDBMS'@'127.0.0.1' TRIGGER usersettings.RegionalDataLogInsert AFTER INSERT ON usersettings.RegionalData FOR EACH ROW
BEGIN
INSERT INTO logs.regional_data_logs
SET LogTime = now() ,
OperatorName = IFNULL(@INUser, SUBSTRING_INDEX(USER(),'@',1)) ,
OperatorHost = IFNULL(@INHost, SUBSTRING_INDEX(USER(),'@',-1)) ,
Operation = 0,
RegionalDataID = NEW.RowId,
RegionCode = NEW.RegionCode,
FirmCode = NEW.FirmCode,
Enabled = NEW.Enabled,
UpCost = NEW.UpCost,
Storage = NEW.Storage,
MinReq = NEW.MinReq,
SupportPhone = NEW.SupportPhone,
ContactInfo = NEW.ContactInfo,
OperativeInfo = NEW.OperativeInfo,
ConfigOrderCode = NEW.ConfigOrderCode;
END