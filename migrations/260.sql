CREATE TABLE  `logs`.`DescriptionLogs` (
  `Id` int unsigned NOT NULL AUTO_INCREMENT,
  `LogTime` datetime NOT NULL,
  `OperatorName` varchar(50) NOT NULL,
  `OperatorHost` varchar(50) NOT NULL,
  `Operation` tinyint(3) unsigned NOT NULL,
  `DescriptionId` int(10) unsigned not null,
  `Name` varchar(255),
  `EnglishName` varchar(255),
  `Description` mediumtext,
  `Interaction` mediumtext,
  `SideEffect` mediumtext,
  `IndicationsForUse` mediumtext,
  `Dosing` mediumtext,
  `Warnings` mediumtext,
  `ProductForm` mediumtext,
  `PharmacologicalAction` mediumtext,
  `Storage` mediumtext,
  `Expiration` mediumtext,
  `Composition` mediumtext,
  `NeedCorrect` tinyint(1) unsigned,

  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;


CREATE DEFINER = RootDBMS@127.0.0.1 TRIGGER catalogs.DescriptionLogDelete AFTER DELETE ON catalogs.Descriptions
FOR EACH ROW BEGIN
	INSERT 
	INTO `logs`.DescriptionLogs
	SET LogTime = now(),
		OperatorName = IFNULL(@INUser, SUBSTRING_INDEX(USER(),'@',1)),
		OperatorHost = IFNULL(@INHost, SUBSTRING_INDEX(USER(),'@',-1)),
		Operation = 2,
		DescriptionId = OLD.Id,
		Name = OLD.Name,
		EnglishName = OLD.EnglishName,
		Description = OLD.Description,
		Interaction = OLD.Interaction,
		SideEffect = OLD.SideEffect,
		IndicationsForUse = OLD.IndicationsForUse,
		Dosing = OLD.Dosing,
		Warnings = OLD.Warnings,
		ProductForm = OLD.ProductForm,
		PharmacologicalAction = OLD.PharmacologicalAction,
		Storage = OLD.Storage,
		Expiration = OLD.Expiration,
		Composition = OLD.Composition,
		NeedCorrect = OLD.NeedCorrect;
END;


CREATE DEFINER = RootDBMS@127.0.0.1 TRIGGER catalogs.DescriptionLogUpdate AFTER UPDATE ON catalogs.Descriptions
FOR EACH ROW BEGIN
	INSERT 
	INTO `logs`.DescriptionLogs
	SET LogTime = now(),
		OperatorName = IFNULL(@INUser, SUBSTRING_INDEX(USER(),'@',1)),
		OperatorHost = IFNULL(@INHost, SUBSTRING_INDEX(USER(),'@',-1)),
		Operation = 1,
		DescriptionId = OLD.Id,
		Name = NULLIF(NEW.Name, OLD.Name),
		EnglishName = NULLIF(NEW.EnglishName, OLD.EnglishName),
		Description = NULLIF(NEW.Description, OLD.Description),
		Interaction = NULLIF(NEW.Interaction, OLD.Interaction),
		SideEffect = NULLIF(NEW.SideEffect, OLD.SideEffect),
		IndicationsForUse = NULLIF(NEW.IndicationsForUse, OLD.IndicationsForUse),
		Dosing = NULLIF(NEW.Dosing, OLD.Dosing),
		Warnings = NULLIF(NEW.Warnings, OLD.Warnings),
		ProductForm = NULLIF(NEW.ProductForm, OLD.ProductForm),
		PharmacologicalAction = NULLIF(NEW.PharmacologicalAction, OLD.PharmacologicalAction),
		Storage = NULLIF(NEW.Storage, OLD.Storage),
		Expiration = NULLIF(NEW.Expiration, OLD.Expiration),
		Composition = NULLIF(NEW.Composition, OLD.Composition),
		NeedCorrect = NULLIF(NEW.NeedCorrect, OLD.NeedCorrect);
END;


CREATE DEFINER = RootDBMS@127.0.0.1 TRIGGER catalogs.DescriptionLogInsert AFTER INSERT ON catalogs.Descriptions
FOR EACH ROW BEGIN
	INSERT 
	INTO `logs`.DescriptionLogs
	SET LogTime = now(),
		OperatorName = IFNULL(@INUser, SUBSTRING_INDEX(USER(),'@',1)),
		OperatorHost = IFNULL(@INHost, SUBSTRING_INDEX(USER(),'@',-1)),
		Operation = 0,
		DescriptionId = NEW.Id,
		Name = NEW.Name,
		EnglishName = NEW.EnglishName,
		Description = NEW.Description,
		Interaction = NEW.Interaction,
		SideEffect = NEW.SideEffect,
		IndicationsForUse = NEW.IndicationsForUse,
		Dosing = NEW.Dosing,
		Warnings = NEW.Warnings,
		ProductForm = NEW.ProductForm,
		PharmacologicalAction = NEW.PharmacologicalAction,
		Storage = NEW.Storage,
		Expiration = NEW.Expiration,
		Composition = NEW.Composition,
		NeedCorrect = NEW.NeedCorrect;
END;