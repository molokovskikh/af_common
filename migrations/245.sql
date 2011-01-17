CREATE TABLE  `logs`.`MnnLogs` (
  `Id` int unsigned NOT NULL AUTO_INCREMENT,
  `LogTime` datetime NOT NULL,
  `OperatorName` varchar(50) NOT NULL,
  `OperatorHost` varchar(50) NOT NULL,
  `Operation` tinyint(3) unsigned NOT NULL,
  `MnnId` int(10) unsigned not null,
  `Mnn` varchar(255),
  `Description` mediumtext,
  `VitallyImportant` tinyint(1) unsigned,
  `MandatoryList` tinyint(1) unsigned,
  `RussianMnn` varchar(255),

  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;


CREATE DEFINER = RootDBMS@127.0.0.1 TRIGGER catalogs.MnnLogDelete AFTER DELETE ON catalogs.Mnn
FOR EACH ROW BEGIN
	INSERT 
	INTO `logs`.MnnLogs
	SET LogTime = now(),
		OperatorName = IFNULL(@INUser, SUBSTRING_INDEX(USER(),'@',1)),
		OperatorHost = IFNULL(@INHost, SUBSTRING_INDEX(USER(),'@',-1)),
		Operation = 2,
		MnnId = OLD.Id,
		Mnn = OLD.Mnn,
		Description = OLD.Description,
		VitallyImportant = OLD.VitallyImportant,
		MandatoryList = OLD.MandatoryList,
		RussianMnn = OLD.RussianMnn;
END;


CREATE DEFINER = RootDBMS@127.0.0.1 TRIGGER catalogs.MnnLogUpdate AFTER UPDATE ON catalogs.Mnn
FOR EACH ROW BEGIN
	INSERT 
	INTO `logs`.MnnLogs
	SET LogTime = now(),
		OperatorName = IFNULL(@INUser, SUBSTRING_INDEX(USER(),'@',1)),
		OperatorHost = IFNULL(@INHost, SUBSTRING_INDEX(USER(),'@',-1)),
		Operation = 1,
		MnnId = OLD.Id,
		Mnn = NULLIF(NEW.Mnn, OLD.Mnn),
		Description = NULLIF(NEW.Description, OLD.Description),
		VitallyImportant = NULLIF(NEW.VitallyImportant, OLD.VitallyImportant),
		MandatoryList = NULLIF(NEW.MandatoryList, OLD.MandatoryList),
		RussianMnn = NULLIF(NEW.RussianMnn, OLD.RussianMnn);
END;

CREATE DEFINER = RootDBMS@127.0.0.1 TRIGGER catalogs.MnnLogInsert AFTER INSERT ON catalogs.Mnn
FOR EACH ROW BEGIN
	INSERT 
	INTO `logs`.MnnLogs
	SET LogTime = now(),
		OperatorName = IFNULL(@INUser, SUBSTRING_INDEX(USER(),'@',1)),
		OperatorHost = IFNULL(@INHost, SUBSTRING_INDEX(USER(),'@',-1)),
		Operation = 0,
		MnnId = NEW.Id,
		Mnn = NEW.Mnn,
		Description = NEW.Description,
		VitallyImportant = NEW.VitallyImportant,
		MandatoryList = NEW.MandatoryList,
		RussianMnn = NEW.RussianMnn;
END;
