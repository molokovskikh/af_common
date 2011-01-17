DROP TRIGGER IF EXISTS future.IntersectionLogDelete; 
CREATE DEFINER = RootDBMS@127.0.0.1 TRIGGER future.IntersectionLogDelete AFTER DELETE ON future.intersection
FOR EACH ROW BEGIN
	INSERT 
	INTO `logs`.IntersectionLogs
	SET LogTime = now(),
		OperatorName = IFNULL(@INUser, SUBSTRING_INDEX(USER(),'@',1)),
		OperatorHost = IFNULL(@INHost, SUBSTRING_INDEX(USER(),'@',-1)),
		Operation = 2,
		IntersectionId = OLD.Id,
		ClientId = OLD.ClientId,
		RegionId = OLD.RegionId,
		PriceId = OLD.PriceId,
		CostId = OLD.CostId,
		AvailableForClient = OLD.AvailableForClient,
		AgencyEnabled = OLD.AgencyEnabled,
		PriceMarkup = OLD.PriceMarkup,
		SupplierClientId = OLD.SupplierClientId,
		SupplierPaymentId = OLD.SupplierPaymentId,
		ControlMinReq = OLD.ControlMinReq,
		MinReq = OLD.MinReq;
END;
DROP TRIGGER IF EXISTS future.IntersectionLogUpdate; 
CREATE DEFINER = RootDBMS@127.0.0.1 TRIGGER future.IntersectionLogUpdate AFTER UPDATE ON future.intersection
FOR EACH ROW BEGIN
	INSERT 
	INTO `logs`.IntersectionLogs
	SET LogTime = now(),
		OperatorName = IFNULL(@INUser, SUBSTRING_INDEX(USER(),'@',1)),
		OperatorHost = IFNULL(@INHost, SUBSTRING_INDEX(USER(),'@',-1)),
		Operation = 1,
		IntersectionId = OLD.Id,
		ClientId = NULLIF(NEW.ClientId, OLD.ClientId),
		RegionId = NULLIF(NEW.RegionId, OLD.RegionId),
		PriceId = NULLIF(NEW.PriceId, OLD.PriceId),
		CostId = NULLIF(NEW.CostId, OLD.CostId),
		AvailableForClient = NULLIF(NEW.AvailableForClient, OLD.AvailableForClient),
		AgencyEnabled = NULLIF(NEW.AgencyEnabled, OLD.AgencyEnabled),
		PriceMarkup = NULLIF(NEW.PriceMarkup, OLD.PriceMarkup),
		SupplierClientId = NULLIF(NEW.SupplierClientId, OLD.SupplierClientId),
		SupplierPaymentId = NULLIF(NEW.SupplierPaymentId, OLD.SupplierPaymentId),
		ControlMinReq = NULLIF(NEW.ControlMinReq, OLD.ControlMinReq),
		MinReq = NULLIF(NEW.MinReq, OLD.MinReq);
END;
DROP TRIGGER IF EXISTS future.IntersectionAfterInsert;
CREATE DEFINER = RootDBMS@127.0.0.1 TRIGGER future.IntersectionAfterInsert AFTER INSERT ON future.Intersection
FOR EACH ROW BEGIN
  IF @Skip IS NULL OR @Skip <> 1 THEN

    INSERT
    INTO Future.AddressIntersection (IntersectionId, AddressId)
    SELECT
      NEW.Id, a.Id
    FROM
      Future.Clients c
      JOIN Future.Addresses a ON a.ClientId = c.Id
    WHERE
      c.Id = NEW.ClientId;

    INSERT
    INTO Future.UserPrices (UserId, PriceId, RegionId)
    SELECT
      u.Id, NEW.PriceId, NEW.RegionId
    FROM
      Future.Clients c
      JOIN Future.Users u ON u.ClientId = c.Id
      LEFT JOIN Future.UserPrices up ON up.PriceId = NEW.PriceId AND up.RegionId = NEW.RegionId AND up.UserId = u.Id
    WHERE
      c.Id = NEW.ClientId AND up.UserId IS NULL;

    INSERT
    INTO Usersettings.SupplierIntersection (SupplierId, ClientId)
    SELECT
      pd.FirmCode, NEW.ClientId
    FROM
      Usersettings.PricesData pd
      LEFT JOIN Usersettings.SupplierIntersection si ON si.SupplierId = pd.FirmCode AND si.ClientId = NEW.ClientId
    WHERE
      pd.PriceCode = NEW.PriceId AND si.Id IS NULL
    GROUP BY
      pd.FirmCode;

  END IF;

  INSERT
  INTO `logs`.IntersectionLogs
  SET
    LogTime = NOW(),
	OperatorName = IFNULL(@INUser, SUBSTRING_INDEX(USER(), '@', 1)),
	OperatorHost = IFNULL(@INHost, SUBSTRING_INDEX(USER(), '@', -1)),
	Operation = 0,
	IntersectionId = NEW.Id,
	ClientId = NEW.ClientId,
	RegionId = NEW.RegionId,
	PriceId = NEW.PriceId,
	CostId = NEW.CostId,
	AvailableForClient = NEW.AvailableForClient,
	AgencyEnabled = NEW.AgencyEnabled,
	PriceMarkup = NEW.PriceMarkup,
	SupplierClientId = NEW.SupplierClientId,
	SupplierPaymentId = NEW.SupplierPaymentId,
	ControlMinReq = NEW.ControlMinReq,
	MinReq = NEW.MinReq;

END;