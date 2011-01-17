alter table Logs.UserLogs
  add column `EnableUpdate` tinyint(1) unsigned;

DROP TRIGGER IF EXISTS future.UserLogDelete; 
CREATE DEFINER = RootDBMS@127.0.0.1 TRIGGER future.UserLogDelete AFTER DELETE ON future.Users
FOR EACH ROW BEGIN
	INSERT 
	INTO `logs`.UserLogs
	SET LogTime = now(),
		OperatorName = IFNULL(@INUser, SUBSTRING_INDEX(USER(),'@',1)),
		OperatorHost = IFNULL(@INHost, SUBSTRING_INDEX(USER(),'@',-1)),
		Operation = 2,
		UserId = OLD.Id,
		ClientId = OLD.ClientId,
		Enabled = OLD.Enabled,
		Login = OLD.Login,
		Name = OLD.Name,
		SendRejects = OLD.SendRejects,
		SendWaybills = OLD.SendWaybills,
		SubmitOrders = OLD.SubmitOrders,
		Auditor = OLD.Auditor,
		InheritPricesFrom = OLD.InheritPricesFrom,
		Registrant = OLD.Registrant,
		ContactGroupId = OLD.ContactGroupId,
		RegistrationDate = OLD.RegistrationDate,
		WorkRegionMask = OLD.WorkRegionMask,
		OrderRegionMask = OLD.OrderRegionMask,
		Free = OLD.Free,
                EnableUpdate = OLD.EnableUpdate;
END;
DROP TRIGGER IF EXISTS future.UserLogUpdate; 
CREATE DEFINER = RootDBMS@127.0.0.1 TRIGGER future.UserLogUpdate AFTER UPDATE ON future.Users
FOR EACH ROW BEGIN
	INSERT 
	INTO `logs`.UserLogs
	SET LogTime = now(),
		OperatorName = IFNULL(@INUser, SUBSTRING_INDEX(USER(),'@',1)),
		OperatorHost = IFNULL(@INHost, SUBSTRING_INDEX(USER(),'@',-1)),
		Operation = 1,
		UserId = OLD.Id,
		ClientId = NULLIF(NEW.ClientId, OLD.ClientId),
		Enabled = NULLIF(NEW.Enabled, OLD.Enabled),
		Login = NULLIF(NEW.Login, OLD.Login),
		Name = NULLIF(NEW.Name, OLD.Name),
		SendRejects = NULLIF(NEW.SendRejects, OLD.SendRejects),
		SendWaybills = NULLIF(NEW.SendWaybills, OLD.SendWaybills),
		SubmitOrders = NULLIF(NEW.SubmitOrders, OLD.SubmitOrders),
		Auditor = NULLIF(NEW.Auditor, OLD.Auditor),
		InheritPricesFrom = NULLIF(NEW.InheritPricesFrom, OLD.InheritPricesFrom),
		Registrant = NULLIF(NEW.Registrant, OLD.Registrant),
		ContactGroupId = NULLIF(NEW.ContactGroupId, OLD.ContactGroupId),
		RegistrationDate = NULLIF(NEW.RegistrationDate, OLD.RegistrationDate),
		WorkRegionMask = NULLIF(NEW.WorkRegionMask, OLD.WorkRegionMask),
		OrderRegionMask = NULLIF(NEW.OrderRegionMask, OLD.OrderRegionMask),
		Free = NULLIF(NEW.Free, OLD.Free),
                EnableUpdate = NULLIF(NEW.EnableUpdate, OLD.EnableUpdate);
END;
DROP TRIGGER IF EXISTS future.UserLogInsert; 
CREATE DEFINER = RootDBMS@127.0.0.1 TRIGGER future.UserLogInsert AFTER INSERT ON future.Users
FOR EACH ROW BEGIN
	INSERT 
	INTO `logs`.UserLogs
	SET LogTime = now(),
		OperatorName = IFNULL(@INUser, SUBSTRING_INDEX(USER(),'@',1)),
		OperatorHost = IFNULL(@INHost, SUBSTRING_INDEX(USER(),'@',-1)),
		Operation = 0,
		UserId = NEW.Id,
		ClientId = NEW.ClientId,
		Enabled = NEW.Enabled,
		Login = NEW.Login,
		Name = NEW.Name,
		SendRejects = NEW.SendRejects,
		SendWaybills = NEW.SendWaybills,
		SubmitOrders = NEW.SubmitOrders,
		Auditor = NEW.Auditor,
		InheritPricesFrom = NEW.InheritPricesFrom,
		Registrant = NEW.Registrant,
		ContactGroupId = NEW.ContactGroupId,
		RegistrationDate = NEW.RegistrationDate,
		WorkRegionMask = NEW.WorkRegionMask,
		OrderRegionMask = NEW.OrderRegionMask,
		Free = NEW.Free,
                EnableUpdate = NEW.EnableUpdate;
END;