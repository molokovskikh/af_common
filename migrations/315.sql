alter table Logs.AddressLogs
add column LegalEntityId int(10) unsigned,
add column BeAccounted tinyint(1) unsigned
;
DROP TRIGGER IF EXISTS future.AddressLogDelete; 
CREATE DEFINER = RootDBMS@127.0.0.1 TRIGGER future.AddressLogDelete AFTER DELETE ON future.Addresses
FOR EACH ROW BEGIN
	INSERT 
	INTO `logs`.AddressLogs
	SET LogTime = now(),
		OperatorName = IFNULL(@INUser, SUBSTRING_INDEX(USER(),'@',1)),
		OperatorHost = IFNULL(@INHost, SUBSTRING_INDEX(USER(),'@',-1)),
		Operation = 2,
		AddressId = OLD.Id,
		LegacyId = OLD.LegacyId,
		ClientId = OLD.ClientId,
		LegalEntityId = OLD.LegalEntityId,
		Enabled = OLD.Enabled,
		Free = OLD.Free,
		Address = OLD.Address,
		ContactGroupId = OLD.ContactGroupId,
		BeAccounted = OLD.BeAccounted;
END;
DROP TRIGGER IF EXISTS future.AddressLogUpdate; 
CREATE DEFINER = RootDBMS@127.0.0.1 TRIGGER future.AddressLogUpdate AFTER UPDATE ON future.Addresses
FOR EACH ROW BEGIN
	INSERT 
	INTO `logs`.AddressLogs
	SET LogTime = now(),
		OperatorName = IFNULL(@INUser, SUBSTRING_INDEX(USER(),'@',1)),
		OperatorHost = IFNULL(@INHost, SUBSTRING_INDEX(USER(),'@',-1)),
		Operation = 1,
		AddressId = OLD.Id,
		LegacyId = NULLIF(NEW.LegacyId, OLD.LegacyId),
		ClientId = NULLIF(NEW.ClientId, OLD.ClientId),
		LegalEntityId = NULLIF(NEW.LegalEntityId, OLD.LegalEntityId),
		Enabled = NULLIF(NEW.Enabled, OLD.Enabled),
		Free = NULLIF(NEW.Free, OLD.Free),
		Address = NULLIF(NEW.Address, OLD.Address),
		ContactGroupId = NULLIF(NEW.ContactGroupId, OLD.ContactGroupId),
		BeAccounted = NULLIF(NEW.BeAccounted, OLD.BeAccounted);
END;
DROP TRIGGER IF EXISTS future.AddressLogInsert; 
CREATE DEFINER = RootDBMS@127.0.0.1 TRIGGER future.AddressLogInsert AFTER INSERT ON future.Addresses
FOR EACH ROW BEGIN
	INSERT 
	INTO `logs`.AddressLogs
	SET LogTime = now(),
		OperatorName = IFNULL(@INUser, SUBSTRING_INDEX(USER(),'@',1)),
		OperatorHost = IFNULL(@INHost, SUBSTRING_INDEX(USER(),'@',-1)),
		Operation = 0,
		AddressId = NEW.Id,
		LegacyId = NEW.LegacyId,
		ClientId = NEW.ClientId,
		LegalEntityId = NEW.LegalEntityId,
		Enabled = NEW.Enabled,
		Free = NEW.Free,
		Address = NEW.Address,
		ContactGroupId = NEW.ContactGroupId,
		BeAccounted = NEW.BeAccounted;
END;