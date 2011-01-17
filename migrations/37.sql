drop trigger if exists farm.SynonymfirmcrInsert;
drop trigger if exists farm.SynonymfirmcrUpdate;

CREATE 
	DEFINER = RootDBMS@127.0.0.1
TRIGGER farm.SynonymfirmcrInsert
	AFTER INSERT
	ON farm.SynonymFirmCr
	FOR EACH ROW
BEGIN
  INSERT
  INTO `logs`.SynonymFirmCrLogs
  SET
    LogTime = NOW(), OperatorName = IFNULL(@INUser, SUBSTRING_INDEX(USER(), '@', 1)), OperatorHost = IFNULL(@INHost, SUBSTRING_INDEX(USER(), '@', -1)), Operation = 0, SynonymFirmCrCode = NEW.SynonymFirmCrCode, PriceCode = NEW.PriceCode, CodeFirmCr = NEW.CodeFirmCr, Synonym = NEW.Synonym;
END;

CREATE 
        DEFINER = RootDBMS@127.0.0.1
TRIGGER farm.SynonymfirmcrUpdate
	AFTER UPDATE
	ON farm.SynonymFirmCr
	FOR EACH ROW
BEGIN
	INSERT
  INTO `logs`.SynonymFirmCrLogs
  SET
    LogTime = NOW(), OperatorName = IFNULL(@INUser, SUBSTRING_INDEX(USER(), '@', 1)), OperatorHost = IFNULL(@INHost, SUBSTRING_INDEX(USER(), '@', -1)), Operation = 1, SynonymFirmCrCode = OLD.SynonymFirmCrCode, PriceCode = NULLIF(NEW.PriceCode, OLD.PriceCode), CodeFirmCr = NULLIF(NEW.CodeFirmCr, OLD.CodeFirmCr), Synonym = NULLIF(NEW.Synonym, OLD.Synonym);
END;