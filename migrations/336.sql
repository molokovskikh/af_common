
# Event на очистку синонимов.
drop event if exists farm.ClearSynonym; 
CREATE 
	DEFINER = `RootDBMS`@`127.0.0.1`
EVENT farm.ClearSynonym
	ON SCHEDULE EVERY '1' DAY
	STARTS '2010-08-11 01:00:00'
	DO 
BEGIN
  CREATE TEMPORARY TABLE SynonymToDelete ENGINE = MEMORY
  SELECT
    U.synonymcode
  FROM
    UsedSynonymLogs U,
    SYNONYM S
  WHERE
    lastUsed < CURDATE() - INTERVAL 3 MONTH
    AND s.synonymcode = u.synonymcode
    AND s.pricecode NOT IN
    (SELECT
      pricecode
    FROM
      usersettings.PricesData P
    WHERE
      pricetype = 1

    UNION

    DISTINCT
    SELECT DISTINCT
      parentsynonym
    FROM
      usersettings.PricesData P
    WHERE
      pricetype = 1
      AND parentsynonym IS NOT NULL
    )

  UNION

  DISTINCT
  SELECT
    synonymcode
  FROM
    UsedSynonymLogs U
  WHERE
    lastUsed < CURDATE() - INTERVAL 1 YEAR;

  DELETE
  FROM
    s
  USING
    SYNONYM s,
    SynonymToDelete d
  WHERE
    s.synonymcode = d.synonymcode;
  DROP TEMPORARY TABLE SynonymToDelete;


  CREATE TEMPORARY TABLE SynonymCrToDelete ENGINE = MEMORY
  SELECT
    U.synonymfirmcrcode
  FROM
    UsedSynonymfirmcrLogs U,
    SYNONYMfirmcr S
  WHERE
    lastUsed < CURDATE() - INTERVAL 3 MONTH
    AND s.synonymfirmcrcode = u.synonymfirmcrcode
    AND s.pricecode NOT IN
    (SELECT
      pricecode
    FROM
      usersettings.PricesData P
    WHERE
      pricetype = 1

    UNION

    DISTINCT
    SELECT DISTINCT
      parentsynonym
    FROM
      usersettings.PricesData P
    WHERE
      pricetype = 1
      AND parentsynonym IS NOT NULL
    )

  UNION

  DISTINCT
  SELECT
    synonymfirmcrcode
  FROM
    UsedSynonymfirmcrLogs U
  WHERE
    lastUsed < CURDATE() - INTERVAL 1 YEAR;
  DELETE
  FROM
    s
  USING
    SYNONYMfirmcr s,
    SynonymCrToDelete d
  WHERE
    s.synonymfirmcrcode = d.synonymfirmcrcode;
  DROP TEMPORARY TABLE SynonymCrToDelete;

END;


# Неиспользуемая ХП с закомментированным кодом, в которой было создание синономов для прайс-листа 2647
drop procedure if exists catalogs.CreateGUPSynonymByProductId;


# Триггер с закомментированным кодом, в котором упоминался прайс-лист 2647
drop trigger if exists catalogs.CatalogAfterUpdate;


# Триггер с закомментированным кодом, в котором упоминался прайс-лист 2647
drop trigger if exists catalogs.ProductsPropertiesAfterInsert;


# Триггер с созданием синонимов производителей для прайс-листа 2647
drop trigger if exists farm.CatalogFirmCrInsert;
CREATE 
	DEFINER = `RootDBMS`@`127.0.0.1`
TRIGGER farm.CatalogFirmCrInsert
	AFTER INSERT
	ON farm.catalogfirmcr
	FOR EACH ROW
BEGIN

    INSERT
    INTO `logs`.Catalogfirmcr
    SET LogTime = now(),
                OperatorName = IFNULL(@INUser, SUBSTRING_INDEX(USER(),'@',1)),
                OperatorHost = IFNULL(@INHost, SUBSTRING_INDEX(USER(),'@',-1)),

                Operation = 0,
                CodeFirmCr = NEW.CodeFirmCr,
                FirmCr = NEW.FirmCr,
                Hidden = NEW.Hidden;

END;

# Триггер, в котором вызывалась ХП UpdateGUPPriceDate в случае удаления синонима для прайс-листа 2647
drop trigger if exists farm.SynonymBeforeDelete;


# Триггер, в котором вызывалась ХП UpdateGUPPriceDate в случае добавления синонима для прайс-листа 2647
drop trigger if exists farm.SynonymBeforeInsert;


# ХП, которая обновляет PriceDate для PriceItem прайс-листа 2647
drop procedure if exists farm.UpdateGUPPriceDate;


# Триггер, в котором изменялись настройки Intersection для прайс-листа 2647
drop trigger if exists usersettings.IntersectionBeforeUpdate;


# Триггер, в котором изменялись настройки Intersection для прайс-листа 2647
drop trigger if exists usersettings.RetClientsSetLogUpdate;
CREATE 
	DEFINER = `RootDBMS`@`127.0.0.1`
TRIGGER usersettings.RetClientsSetLogUpdate
	AFTER UPDATE
	ON usersettings.RetClientsSet
	FOR EACH ROW
BEGIN

INSERT
INTO   `logs`.RetClientsSetLogs SET LogTime = now()
       ,
       OperatorName = IFNULL
       (
              @INUser,
              SUBSTRING_INDEX(USER(),'@',1)
       )
       ,
       OperatorHost = IFNULL
       (
              @INHost,
              SUBSTRING_INDEX(USER(),'@',-1)
       )
       ,
       Operation  = 1,
       ClientCode = IFNULL
       (
              NEW.ClientCode,
              OLD.ClientCode
       )
       ,
       InvisibleOnFirm = NULLIF
       (
              NEW.InvisibleOnFirm,
              OLD.InvisibleOnFirm
       )
       ,
       BaseFirmCategory = NULLIF
       (
              NEW.BaseFirmCategory,
              OLD.BaseFirmCategory
       )
       ,
       RetUpCost = NULLIF
       (
              NEW.RetUpCost,
              OLD.RetUpCost
       )
       ,
       OverCostPercent = NULLIF
       (
              NEW.OverCostPercent,
              OLD.OverCostPercent
       )
       ,
       DifferenceCalculation = NULLIF
       (
              NEW.DifferenceCalculation,
              OLD.DifferenceCalculation
       )
       ,
       AlowRegister = NULLIF
       (
              NEW.AlowRegister,
              OLD.AlowRegister
       )
       ,
       AlowRejection = NULLIF
       (
              NEW.AlowRejection,
              OLD.AlowRejection
       )
       ,
       AlowDocuments = NULLIF
       (
              NEW.AlowDocuments,
              OLD.AlowDocuments
       )
       ,
       MultiUserLevel = NULLIF
       (
              NEW.MultiUserLevel,
              OLD.MultiUserLevel
       )
       ,
       AdvertisingLevel = NULLIF
       (
              NEW.AdvertisingLevel,
              OLD.AdvertisingLevel
       )
       ,
       AlowWayBill = NULLIF
       (
              NEW.AlowWayBill,
              OLD.AlowWayBill
       )
       ,
       AllowDocuments = NULLIF
       (
              NEW.AllowDocuments,
              OLD.AllowDocuments
       )
       ,
       AlowChangeSegment = NULLIF
       (
              NEW.AlowChangeSegment,
              OLD.AlowChangeSegment
       )
       ,
       ShowPriceName = NULLIF
       (
              NEW.ShowPriceName,
              OLD.ShowPriceName
       )
       ,
       WorkRegionMask = NULLIF
       (
              NEW.WorkRegionMask,
              OLD.WorkRegionMask
       )
       ,
       OrderRegionMask = NULLIF
       (
              NEW.OrderRegionMask,
              OLD.OrderRegionMask
       )
       ,
      
       EnableUpdate = NULLIF
       (
              NEW.EnableUpdate,
              OLD.EnableUpdate
       )
       ,
       CheckCopyID = NULLIF
       (
              NEW.CheckCopyID,
              OLD.CheckCopyID
       )
       ,
       AlowCumulativeUpdate = NULLIF
       (
              NEW.AlowCumulativeUpdate,
              OLD.AlowCumulativeUpdate
       )
       ,
       CheckCumulativeUpdateStatus = NULLIF
       (
              NEW.CheckCumulativeUpdateStatus,
              OLD.CheckCumulativeUpdateStatus
       )
       ,
       ServiceClient = NULLIF
       (
              NEW.ServiceClient,
              OLD.ServiceClient
       )
       ,
       SubmitOrders = NULLIF
       (
              NEW.SubmitOrders,
              OLD.SubmitOrders
       )
       ,
       AllowSubmitOrders = NULLIF
       (
              NEW.AllowSubmitOrders,
              OLD.AllowSubmitOrders
       )
       ,
       BasecostPassword = NULLIF
       (
              NEW.BasecostPassword,
              OLD.BasecostPassword
       )
       ,
       OrdersVisualizationMode = NULLIF
       (
              NEW.OrdersVisualizationMode,
              OLD.OrdersVisualizationMode
       )
       ,
       CalculateLeader = NULLIF
       (
              NEW.CalculateLeader,
              OLD.CalculateLeader
       )
       ,
       AllowPreparatInfo = NULLIF
       (
              NEW.AllowPreparatInfo,
              OLD.AllowPreparatInfo
       )
       ,
       AllowPreparatDesc = NULLIF
       (
              NEW.AllowPreparatDesc,
              OLD.AllowPreparatDesc
       )
       ,
       SmartOrderRuleId = NULLIF
       (
              NEW.SmartOrderRuleId,
              OLD.SmartOrderRuleId
       )
       ,
       FirmCodeOnly = NULLIF
       (
              NEW.FirmCodeOnly,
              OLD.FirmCodeOnly
       )
       ,
       MaxWeeklyOrdersSum = NULLIF
       (
              NEW.MaxWeeklyOrdersSum,
              OLD.MaxWeeklyOrdersSum
       )
       ,
       CheckWeeklyOrdersSum = NULLIF
       (
              NEW.CheckWeeklyOrdersSum,
              OLD.CheckWeeklyOrdersSum
       )
       ,
       AllowDelayOfPayment = NULLIF
       (
              NEW.AllowDelayOfPayment,
              OLD.AllowDelayOfPayment
       )
       ,
       Spy = NULLIF
       (
              NEW.Spy,
              OLD.Spy
       )
       ,
       SpyAccount = NULLIF
       (
              NEW.SpyAccount,
              OLD.SpyAccount
       )
       ,
       ShowNewDefecture = NULLIF
       (
              NEW.ShowNewDefecture,
              OLD.ShowNewDefecture
       )
       ,
       MigrateToPrgDataService = NULLIF
       (
              NEW.MigrateToPrgDataService,
              OLD.MigrateToPrgDataService
       )
       ,
       ManualComparison = NULLIF
       (
              NEW.ManualComparison,
              OLD.ManualComparison
       )
       ,
       ParseWaybills = NULLIF
       (
              NEW.ParseWaybills,
              OLD.ParseWaybills
       )
       ,
       SendRetailMarkup = NULLIF
       (
              NEW.SendRetailMarkup,
              OLD.SendRetailMarkup
       )
       ,
       ShowAdvertising = NULLIF
       (
              NEW.ShowAdvertising,
              OLD.ShowAdvertising
       )
       ,
       IgnoreNewPrices = NULLIF
       (
              NEW.IgnoreNewPrices,
              OLD.IgnoreNewPrices
       )
       ,
       SendWaybillsFromClient = NULLIF
       (
              NEW.SendWaybillsFromClient,
              OLD.SendWaybillsFromClient
       )
       ,
       OnlyParseWaybills = NULLIF
       (
              NEW.OnlyParseWaybills,
              OLD.OnlyParseWaybills
       )
       ,
       UpdateToTestBuild = NULLIF
       (
              NEW.UpdateToTestBuild,
              OLD.UpdateToTestBuild
       )
       ,
       EnableSmartOrder = NULLIF
       (
              NEW.EnableSmartOrder,
              OLD.EnableSmartOrder
       )
       ,
       BuyingMatrixPriceId = NULLIF
       (
              NEW.BuyingMatrixPriceId,
              OLD.BuyingMatrixPriceId
       )
       ,
       BuyingMatrixType = NULLIF
       (
              NEW.BuyingMatrixType,
              OLD.BuyingMatrixType
       )
       ,
       WarningOnBuyingMatrix = NULLIF
       (
              NEW.WarningOnBuyingMatrix,
              OLD.WarningOnBuyingMatrix
       )
       ,
       EnableImpersonalPrice = NULLIF
       (
              NEW.EnableImpersonalPrice,
              OLD.EnableImpersonalPrice
       )
       ;

END;


# Триггер, в котором изменялись настройки Intersection для прайс-листа 2647
# Есть код, который надо прокомметрировать: опреденные настройки для определенных BillingCode
drop trigger if exists usersettings.IntersectionBeforeInsert;
CREATE 
	DEFINER = `RootDBMS`@`127.0.0.1`
TRIGGER usersettings.IntersectionBeforeInsert
	BEFORE INSERT
	ON usersettings.Intersection
	FOR EACH ROW
BEGIN

  if exists (select FirmCode from clientsdata where firmcode=new.clientcode and billingcode in (2401,2821,2527,100,106)) then
    set new.disabledbyclient=1;
    set new.invisibleonclient=1;
  end if;

  if exists (select FirmCode from clientsdata where firmcode=new.clientcode and billingcode in (2520,2497)) then
    set new.disabledbyclient=1;
  end if;

 if exists (select FirmCode from clientsdata where firmcode=new.clientcode and billingcode in (2381)) and new.RegionCode=8192 then
    set new.disabledbyclient=1;
    set new.invisibleonclient=1;
  end if;

  if exists (SELECT FirmCode FROM ClientsData where BillingCode not in (2502,1546,2345,100,2501,2411,2622,2805,2381,2401,2471,2823,2472,2821,2527)
            and  FirmCode = new.clientcode) 
     and new.PriceCode=2355 
  then
    set new.invisibleonclient=1;
  end if;

  if not exists (select Id from PricesData pd join SupplierIntersection sint ON
                  sint.ClientId = new.ClientCode AND sint.SupplierId = pd.FirmCode
                 where pd.PriceCode = new.PriceCode) and exists(select FirmCode from PricesData where PriceCode = new.PriceCode) 
  then
    insert into SupplierIntersection (ClientId, SupplierId)
      values (new.ClientCode, (select FirmCode from PricesData where PriceCode = new.PriceCode));
  end if;

end;


# Удаление синонимов наименований для прайса 2647
delete from farm.Synonym where PriceCode = 2647;

# Удаление синонимов производителей для прайса 2647
delete from farm.SynonymFirmCr where PriceCode = 2647;
