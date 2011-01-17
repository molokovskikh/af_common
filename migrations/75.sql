-- Добавление столбца ArchivePassword (Пароль для архива) в таблицу farm.sources

ALTER TABLE `farm`.`sources` ADD COLUMN `ArchivePassword` VARCHAR(100) CHARACTER SET cp1251 COLLATE cp1251_general_ci DEFAULT NULL AFTER `ExtrMask`;


-- Добавление столбца ArchivePassword (Пароль для архива) в таблицу farm.sources

ALTER TABLE `logs`.`sources_logs` ADD COLUMN `ArchivePassword` VARCHAR(100) CHARACTER SET cp1251 COLLATE cp1251_general_ci DEFAULT NULL AFTER `ExtrMask`;


-- триггер farm.sourcesLogInsert

DROP TRIGGER IF EXISTS farm.sourcesLogInsert;

CREATE DEFINER = RootDBMS@127.0.0.1 TRIGGER farm.sourcesLogInsert AFTER INSERT
ON farm.sources
FOR EACH ROW BEGIN
  INSERT
  INTO `logs`.sources_logs
  SET
    LogTime = now() ,
    OperatorName = IFNULL(@INUser, SUBSTRING_INDEX(USER(),'@',1)) ,
    OperatorHost = IFNULL(@INHost, SUBSTRING_INDEX(USER(),'@',-1)) ,
    Operation = 0,
    sourcesID = NEW.Id
    ,SourceTypeId = NEW.SourceTypeId
    ,PricePath = NEW.PricePath
    ,EMailTo = NEW.EMailTo
    ,EMailFrom = NEW.EMailFrom
    ,FTPDir = NEW.FTPDir
    ,FTPLogin = NEW.FTPLogin
    ,FTPPassword = NEW.FTPPassword
    ,FTPPassiveMode = NEW.FTPPassiveMode
    ,PriceMask = NEW.PriceMask
    ,ExtrMask = NEW.ExtrMask
    ,ArchivePassword = NEW.ArchivePassword
    ,HTTPLogin = NEW.HTTPLogin
    ,HTTPPassword = NEW.HTTPPassword
  ;
END;


-- триггер farm.sourcesLogUpdate

DROP TRIGGER IF EXISTS farm.sourcesLogUpdate;

CREATE DEFINER = RootDBMS@127.0.0.1 TRIGGER farm.sourcesLogUpdate AFTER UPDATE
ON farm.sources
FOR EACH ROW BEGIN
  INSERT INTO `logs`.sources_logs
  SET 
    LogTime = now() ,
    OperatorName = IFNULL(@INUser, SUBSTRING_INDEX(USER(),'@',1)) ,
    OperatorHost = IFNULL(@INHost, SUBSTRING_INDEX(USER(),'@',-1)) ,
    Operation = 1,
    sourcesID = OLD.Id
    ,SourceTypeId = IFNULL(NEW.SourceTypeId, OLD.SourceTypeId)
    ,PricePath = NULLIF(NEW.PricePath, OLD.PricePath)
    ,EMailTo = NULLIF(NEW.EMailTo, OLD.EMailTo)
    ,EMailFrom = NULLIF(NEW.EMailFrom, OLD.EMailFrom)
    ,FTPDir = NULLIF(NEW.FTPDir, OLD.FTPDir)
    ,FTPLogin = NULLIF(NEW.FTPLogin, OLD.FTPLogin)
    ,FTPPassword = NULLIF(NEW.FTPPassword, OLD.FTPPassword)
    ,FTPPassiveMode = NULLIF(NEW.FTPPassiveMode, OLD.FTPPassiveMode)
    ,PriceMask = NULLIF(NEW.PriceMask, OLD.PriceMask)
    ,ExtrMask = NULLIF(NEW.ExtrMask, OLD.ExtrMask)
    ,ArchivePassword = NULLIF(NEW.ArchivePassword, OLD.ArchivePassword)
    ,HTTPLogin = NULLIF(NEW.HTTPLogin, OLD.HTTPLogin)
    ,HTTPPassword = NULLIF(NEW.HTTPPassword, OLD.HTTPPassword)
  ;
END;


-- триггер farm.sourcesLogDelete

DROP TRIGGER IF EXISTS farm.sourcesLogDelete;

CREATE DEFINER = RootDBMS@127.0.0.1 TRIGGER farm.sourcesLogDelete AFTER DELETE
ON farm.sources
FOR EACH ROW BEGIN
  INSERT INTO `logs`.sources_logs
  SET 
    LogTime = now() ,
    OperatorName = IFNULL(@INUser, SUBSTRING_INDEX(USER(),'@',1)) ,
    OperatorHost = IFNULL(@INHost, SUBSTRING_INDEX(USER(),'@',-1)) ,
    Operation = 2,
    sourcesID = OLD.Id
    ,SourceTypeId = OLD.SourceTypeId
    ,PricePath = OLD.PricePath
    ,EMailTo = OLD.EMailTo
    ,EMailFrom = OLD.EMailFrom
    ,FTPDir = OLD.FTPDir
    ,FTPLogin = OLD.FTPLogin
    ,FTPPassword = OLD.FTPPassword
    ,FTPPassiveMode = OLD.FTPPassiveMode
    ,PriceMask = OLD.PriceMask
    ,ExtrMask = OLD.ExtrMask
    ,ArchivePassword = OLD.ArchivePassword
    ,HTTPLogin = OLD.HTTPLogin
    ,HTTPPassword = OLD.HTTPPassword
  ;
END;