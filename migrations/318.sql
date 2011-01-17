CREATE TABLE  `logs`.`ExcludesLogs` (
  `Id` int unsigned NOT NULL AUTO_INCREMENT,
  `LogTime` datetime NOT NULL,
  `OperatorName` varchar(50) NOT NULL,
  `OperatorHost` varchar(50) NOT NULL,
  `Operation` tinyint(3) unsigned NOT NULL,
  `ExcludId` int(10) unsigned not null,
  `OriginalSynonymId` int(10) unsigned,
  `CatalogId` int(10) unsigned,
  `PriceCode` int(10) unsigned,
  `ProducerSynonymId` int(10) unsigned,
  `DoNotShow` tinyint(1),
  `CreatedOn` timestamp,
  `LastUsedOn` datetime,

  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE DEFINER = RootDBMS@127.0.0.1 TRIGGER Farm.ExcludesLogInsert AFTER INSERT ON farm.excludes
FOR EACH ROW BEGIN
	INSERT 
	INTO `logs`.ExcludesLogs
	SET LogTime = now(),
		OperatorName = IFNULL(@INUser, SUBSTRING_INDEX(USER(),'@',1)),
		OperatorHost = IFNULL(@INHost, SUBSTRING_INDEX(USER(),'@',-1)),
		Operation = 0,
		ExcludId = NEW.Id,
		OriginalSynonymId = NEW.OriginalSynonymId,
		CatalogId = NEW.CatalogId,
		PriceCode = NEW.PriceCode,
		ProducerSynonymId = NEW.ProducerSynonymId,
		DoNotShow = NEW.DoNotShow,
		CreatedOn = NEW.CreatedOn,
		LastUsedOn = NEW.LastUsedOn;
END;

CREATE DEFINER = RootDBMS@127.0.0.1 TRIGGER Farm.ExcludesLogUpdate AFTER UPDATE ON farm.excludes
FOR EACH ROW BEGIN
	INSERT 
	INTO `logs`.ExcludesLogs
	SET LogTime = now(),
		OperatorName = IFNULL(@INUser, SUBSTRING_INDEX(USER(),'@',1)),
		OperatorHost = IFNULL(@INHost, SUBSTRING_INDEX(USER(),'@',-1)),
		Operation = 1,
		ExcludId = OLD.Id,
		OriginalSynonymId = NULLIF(NEW.OriginalSynonymId, OLD.OriginalSynonymId),
		CatalogId = NULLIF(NEW.CatalogId, OLD.CatalogId),
		PriceCode = NULLIF(NEW.PriceCode, OLD.PriceCode),
		ProducerSynonymId = NULLIF(NEW.ProducerSynonymId, OLD.ProducerSynonymId),
		DoNotShow = NULLIF(NEW.DoNotShow, OLD.DoNotShow),
		CreatedOn = NULLIF(NEW.CreatedOn, OLD.CreatedOn),
		LastUsedOn = NULLIF(NEW.LastUsedOn, OLD.LastUsedOn);
END;

CREATE DEFINER = RootDBMS@127.0.0.1 TRIGGER Farm.ExcludesLogDelete AFTER DELETE ON farm.excludes
FOR EACH ROW BEGIN
	INSERT 
	INTO `logs`.ExcludesLogs
	SET LogTime = now(),
		OperatorName = IFNULL(@INUser, SUBSTRING_INDEX(USER(),'@',1)),
		OperatorHost = IFNULL(@INHost, SUBSTRING_INDEX(USER(),'@',-1)),
		Operation = 2,
		ExcludId = OLD.Id,
		OriginalSynonymId = OLD.OriginalSynonymId,
		CatalogId = OLD.CatalogId,
		PriceCode = OLD.PriceCode,
		ProducerSynonymId = OLD.ProducerSynonymId,
		DoNotShow = OLD.DoNotShow,
		CreatedOn = OLD.CreatedOn,
		LastUsedOn = OLD.LastUsedOn;
END;