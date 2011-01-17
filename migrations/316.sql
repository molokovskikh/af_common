CREATE TABLE  `logs`.`LegalEntityLogs` (
  `Id` int unsigned NOT NULL AUTO_INCREMENT,
  `LogTime` datetime NOT NULL,
  `OperatorName` varchar(50) NOT NULL,
  `OperatorHost` varchar(50) NOT NULL,
  `Operation` tinyint(3) unsigned NOT NULL,
  `LegalEntityId` int(10) unsigned not null,
  `PayerId` int(10) unsigned,
  `Name` varchar(100),
  `FullName` varchar(255),
  `Address` varchar(255),
  `ReceiverAddress` varchar(255),
  `INN` varchar(12),
  `KPP` varchar(9),

  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

DROP TRIGGER IF EXISTS Billing.LegalEntityLogInsert;
CREATE DEFINER = RootDBMS@127.0.0.1 TRIGGER Billing.LegalEntityLogInsert AFTER INSERT ON Billing.LegalEntities
FOR EACH ROW BEGIN
	INSERT 
	INTO `logs`.LegalEntityLogs
	SET LogTime = now(),
		OperatorName = IFNULL(@INUser, SUBSTRING_INDEX(USER(),'@',1)),
		OperatorHost = IFNULL(@INHost, SUBSTRING_INDEX(USER(),'@',-1)),
		Operation = 0,
		LegalEntityId = NEW.Id,
		PayerId = NEW.PayerId,
		Name = NEW.Name,
		FullName = NEW.FullName,
		Address = NEW.Address,
		ReceiverAddress = NEW.ReceiverAddress,
		INN = NEW.INN,
		KPP = NEW.KPP;
END;

DROP TRIGGER IF EXISTS Billing.LegalEntityLogUpdate;
CREATE DEFINER = RootDBMS@127.0.0.1 TRIGGER Billing.LegalEntityLogUpdate AFTER UPDATE ON Billing.LegalEntities
FOR EACH ROW BEGIN
	INSERT 
	INTO `logs`.LegalEntityLogs
	SET LogTime = now(),
		OperatorName = IFNULL(@INUser, SUBSTRING_INDEX(USER(),'@',1)),
		OperatorHost = IFNULL(@INHost, SUBSTRING_INDEX(USER(),'@',-1)),
		Operation = 1,
		LegalEntityId = OLD.Id,
		PayerId = NULLIF(NEW.PayerId, OLD.PayerId),
		Name = NULLIF(NEW.Name, OLD.Name),
		FullName = NULLIF(NEW.FullName, OLD.FullName),
		Address = NULLIF(NEW.Address, OLD.Address),
		ReceiverAddress = NULLIF(NEW.ReceiverAddress, OLD.ReceiverAddress),
		INN = NULLIF(NEW.INN, OLD.INN),
		KPP = NULLIF(NEW.KPP, OLD.KPP);
END;

DROP TRIGGER IF EXISTS Billing.LegalEntityLogDelete;
CREATE DEFINER = RootDBMS@127.0.0.1 TRIGGER Billing.LegalEntityLogDelete AFTER DELETE ON Billing.LegalEntities
FOR EACH ROW BEGIN
	INSERT 
	INTO `logs`.LegalEntityLogs
	SET LogTime = now(),
		OperatorName = IFNULL(@INUser, SUBSTRING_INDEX(USER(),'@',1)),
		OperatorHost = IFNULL(@INHost, SUBSTRING_INDEX(USER(),'@',-1)),
		Operation = 2,
		LegalEntityId = OLD.Id,
		PayerId = OLD.PayerId,
		Name = OLD.Name,
		FullName = OLD.FullName,
		Address = OLD.Address,
		ReceiverAddress = OLD.ReceiverAddress,
		INN = OLD.INN,
		KPP = OLD.KPP;
END;
