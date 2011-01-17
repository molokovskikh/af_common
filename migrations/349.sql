drop trigger `future`.`IntersectionAfterInsert`;

CREATE
DEFINER=`RootDBMS`@`127.0.0.1`
TRIGGER `future`.`IntersectionAfterInsert`
AFTER INSERT ON `future`.`intersection`
FOR EACH ROW
BEGIN
  IF @Skip IS NULL OR @Skip <> 1 THEN

    INSERT
    INTO Future.AddressIntersection (IntersectionId, AddressId)
    SELECT
      NEW.Id, a.Id
    FROM
      Future.Clients c
      JOIN Future.Addresses a ON a.ClientId = c.Id
    WHERE
      c.Id = NEW.ClientId and a.LegalEntityId = NEW.LegalEntityId;

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
	LegalEntityId = NEW.LegalEntityId,
	CostId = NEW.CostId,
	AvailableForClient = NEW.AvailableForClient,
	AgencyEnabled = NEW.AgencyEnabled,
	PriceMarkup = NEW.PriceMarkup,
	SupplierClientId = NEW.SupplierClientId,
	SupplierPaymentId = NEW.SupplierPaymentId;

END;
