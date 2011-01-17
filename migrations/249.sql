DROP TRIGGER IF EXISTS future.AddressintersectionLogInsert; 
CREATE DEFINER = RootDBMS@127.0.0.1 TRIGGER future.AddressintersectionLogInsert AFTER INSERT ON future.addressintersection
FOR EACH ROW BEGIN
	INSERT 
	INTO `logs`.AddressintersectionLogs
	SET LogTime = now(),
		OperatorName = IFNULL(@INUser, SUBSTRING_INDEX(USER(),'@',1)),
		OperatorHost = IFNULL(@INHost, SUBSTRING_INDEX(USER(),'@',-1)),
		Operation = 0,
		AddressintersectionId = NEW.Id,
		AddressId = NEW.AddressId,
		IntersectionId = NEW.IntersectionId,
		SupplierDeliveryId = NEW.SupplierDeliveryId,
		ControlMinReq = NEW.ControlMinReq,
		MinReq = NEW.MinReq;
END;
DROP TRIGGER IF EXISTS future.AddressintersectionLogUpdate; 
CREATE DEFINER = RootDBMS@127.0.0.1 TRIGGER future.AddressintersectionLogUpdate AFTER UPDATE ON future.addressintersection
FOR EACH ROW BEGIN
	INSERT 
	INTO `logs`.AddressintersectionLogs
	SET LogTime = now(),
		OperatorName = IFNULL(@INUser, SUBSTRING_INDEX(USER(),'@',1)),
		OperatorHost = IFNULL(@INHost, SUBSTRING_INDEX(USER(),'@',-1)),
		Operation = 1,
		AddressintersectionId = OLD.Id,
		AddressId = NULLIF(NEW.AddressId, OLD.AddressId),
		IntersectionId = NULLIF(NEW.IntersectionId, OLD.IntersectionId),
		SupplierDeliveryId = NULLIF(NEW.SupplierDeliveryId, OLD.SupplierDeliveryId),
		ControlMinReq = NULLIF(NEW.ControlMinReq, OLD.ControlMinReq),
		MinReq = NULLIF(NEW.MinReq, OLD.MinReq);
END;
DROP TRIGGER IF EXISTS future.AddressintersectionLogDelete; 
CREATE DEFINER = RootDBMS@127.0.0.1 TRIGGER future.AddressintersectionLogDelete AFTER DELETE ON future.addressintersection
FOR EACH ROW BEGIN
	INSERT 
	INTO `logs`.AddressintersectionLogs
	SET LogTime = now(),
		OperatorName = IFNULL(@INUser, SUBSTRING_INDEX(USER(),'@',1)),
		OperatorHost = IFNULL(@INHost, SUBSTRING_INDEX(USER(),'@',-1)),
		Operation = 2,
		AddressintersectionId = OLD.Id,
		AddressId = OLD.AddressId,
		IntersectionId = OLD.IntersectionId,
		SupplierDeliveryId = OLD.SupplierDeliveryId,
		ControlMinReq = OLD.ControlMinReq,
		MinReq = OLD.MinReq;
END;