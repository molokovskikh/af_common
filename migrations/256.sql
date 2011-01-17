DROP TRIGGER IF EXISTS billing.AccountingLogInsert;
CREATE DEFINER = RootDBMS@127.0.0.1 TRIGGER billing.AccountingLogInsert AFTER INSERT ON billing.Accounting
FOR EACH ROW BEGIN
	INSERT 
	INTO `logs`.AccountingLogs
	SET LogTime = now(),
		OperatorName = IFNULL(@INUser, SUBSTRING_INDEX(USER(),'@',1)),
		OperatorHost = IFNULL(@INHost, SUBSTRING_INDEX(USER(),'@',-1)),
		Operation = 0,
		AccountingId = NEW.Id,
		WriteTime = NEW.WriteTime,
		Type = NEW.Type,
		AccountId = NEW.AccountId,
		Operator = NEW.Operator;
END;

DROP TRIGGER IF EXISTS billing.AccountingLogUpdate;
CREATE DEFINER = RootDBMS@127.0.0.1 TRIGGER billing.AccountingLogUpdate AFTER UPDATE ON billing.Accounting
FOR EACH ROW BEGIN
	INSERT 
	INTO `logs`.AccountingLogs
	SET LogTime = now(),
		OperatorName = IFNULL(@INUser, SUBSTRING_INDEX(USER(),'@',1)),
		OperatorHost = IFNULL(@INHost, SUBSTRING_INDEX(USER(),'@',-1)),
		Operation = 1,
		AccountingId = OLD.Id,
		WriteTime = NULLIF(NEW.WriteTime, OLD.WriteTime),
		Type = NULLIF(NEW.Type, OLD.Type),
		AccountId = NULLIF(NEW.AccountId, OLD.AccountId),
		Operator = NULLIF(NEW.Operator, OLD.Operator);
END;

DROP TRIGGER IF EXISTS billing.AccountingLogDelete;
CREATE DEFINER = RootDBMS@127.0.0.1 TRIGGER billing.AccountingLogDelete AFTER DELETE ON billing.Accounting
FOR EACH ROW BEGIN
	INSERT 
	INTO `logs`.AccountingLogs
	SET LogTime = now(),
		OperatorName = IFNULL(@INUser, SUBSTRING_INDEX(USER(),'@',1)),
		OperatorHost = IFNULL(@INHost, SUBSTRING_INDEX(USER(),'@',-1)),
		Operation = 2,
		AccountingId = OLD.Id,
		WriteTime = OLD.WriteTime,
		Type = OLD.Type,
		AccountId = OLD.AccountId,
		Operator = OLD.Operator;
END;
