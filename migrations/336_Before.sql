
# Event на очистку синонимов. Раньше был создан под Definer = 'EMK'@'EmkWork.adc.analit.net'
# Может быть прописать Definer = RootDBMS?
# В списке кодов прайс-листов добавлялся код 2647
# А при удалении синонимов был такой код:
#  DELETE
#  FROM
#    s
#  USING
#    SYNONYM s,
#    SynonymToDelete d
#  WHERE
#    s.synonymcode = d.synonymcode
#    AND s.PriceCode != 2647;
# Зачем здесь исключался 2647? 

CREATE 
	DEFINER = 'EMK'@'EmkWork.adc.analit.net'
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

    UNION

    DISTINCT
    SELECT
      2647
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
    s.synonymcode = d.synonymcode
    AND s.PriceCode != 2647;
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

    UNION

    DISTINCT
    SELECT
      2647
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
    s.synonymfirmcrcode = d.synonymfirmcrcode
    AND s.PriceCode != 2647;
  DROP TEMPORARY TABLE SynonymCrToDelete;

END;



# Неиспользуемая ХП с закомментированным кодом, в которой было создание синономов для прайс-листа 2647
CREATE PROCEDURE catalogs.CreateGUPSynonymByProductId(IN pPriductId INT UNSIGNED)
  SQL SECURITY INVOKER
BEGIN
-- INSERT
-- INTO    farm.SYNONYM
--         (
--         PriceCode,
--         SYNONYM  ,
--         ProductId
--         )
-- SELECT  2647                                                                                          ,
--         trim(concat(c.name,'  ', group_concat(ifnull(pv.`value`,'') order by pv.Value SEPARATOR ' '))),
--         P.id
-- FROM    Catalogs.Catalog C      ,
--         Catalogs.Products P
--         LEFT JOIN Catalogs.ProductProperties PP
--         ON      pp.productid = p.id
--         LEFT JOIN Catalogs.PropertyValues Pv
--         ON      pv.id = pp.propertyvalueid
--         LEFT JOIN farm.synonym s
--         ON      s.pricecode=2647
--             AND s.ProductId=p.Id
-- WHERE  P.CatalogId        =C.id
--     AND s.synonymcode     IS NULL
--     AND P.id               =pPriductId
-- GROUP BY p.id;
END;


# Триггер с закомментированным кодом, в котором упоминался прайс-лист 2647
CREATE 
	DEFINER = 'Morozov'@'prg1.adc.analit.net'
TRIGGER catalogs.CatalogAfterUpdate
	AFTER UPDATE
	ON catalogs.Catalog
	FOR EACH ROW
BEGIN
-- 
--   DECLARE done       INT DEFAULT 0;
--   DECLARE pProductId INT UNSIGNED;
--   DECLARE ProdCur CURSOR FOR
-- 
--   SELECT
--     Id
--   FROM
--     Products
--   WHERE
--     CatalogId = old.id;
--   DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
-- 
-- 
-- 
--   IF new.name != old.Name THEN
--     DELETE
--     FROM
--       farm.s
--     USING
--       farm.synonym s,
--       products p
--     WHERE
--       s.ProductId = p.id
--       AND p.CatalogId = old.id
--       AND s.pricecode = 2647;
--   
--     OPEN ProdCur;
--   
--     REPEAT
-- 
--       FETCH ProdCur INTO pProductId;
--       CALL CreateGUPSynonymByProductId(pProductId);
--     
--     UNTIL done
--     END REPEAT;
--   END IF;
-- 
-- 
-- 
END;


# Триггер с закомментированным кодом, в котором упоминался прайс-лист 2647
CREATE 
	DEFINER = 'Morozov'@'prg1.adc.analit.net'
TRIGGER catalogs.ProductsPropertiesAfterInsert
	AFTER INSERT
	ON catalogs.ProductProperties
	FOR EACH ROW
BEGIN
-- Delete from farm.synonym
-- where PriceCode=2647
-- and ProductId=NEW.ProductId;
-- INSERT
-- INTO    farm.SYNONYM
--         (
--         PriceCode,
--         SYNONYM  ,
--         ProductId
--         )
-- SELECT  2647                                                                                          ,
--         trim(concat(cn.name,'  ', concat(cf.form, ' ', ifnull(group_concat(pv.`value` SEPARATOR ' '), '')))),
--         P.id
-- FROM    Catalogs.CatalogNames Cn,
--         Catalogs.CatalogForms Cf,
--         Catalogs.Catalog C      ,
--         Catalogs.Products P
--         LEFT JOIN Catalogs.ProductProperties PP
--         ON      pp.productid = p.id
--         LEFT JOIN Catalogs.PropertyValues Pv
--         ON      pv.id = pp.propertyvalueid
--         LEFT JOIN farm.synonym s
--         ON      s.pricecode=2647
--             AND s.ProductId=p.Id
-- WHERE   C.NameId           =Cn.Id
--     AND C.FormId           =Cf.id
--     AND P.CatalogId        =C.id
--     AND s.synonymcode     IS NULL
--     AND P.id               =NEW.ProductId
-- GROUP BY p.id;
END;


# Триггер с созданием синонимов производителей для прайс-листа 2647
CREATE 
	DEFINER = 'Morozov'@'prg1.adc.analit.net'
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

    INSERT INTO synonymfirmcr(PriceCode, Synonym, CodeFirmCr) VALUES (2647, NEW.FirmCr, NEW.CodeFirmCr);

END;

# Триггер, в котором вызывалась ХП UpdateGUPPriceDate в случае удаления синонима для прайс-листа 2647
CREATE 
	DEFINER = 'Morozov'@'prg1.adc.analit.net'
TRIGGER farm.SynonymBeforeDelete
	BEFORE DELETE
	ON farm.Synonym
	FOR EACH ROW
BEGIN
  IF old.pricecode = 2647 THEN

    CALL UpdateGUPPriceDate();
    
  END IF;
END;


# Триггер, в котором вызывалась ХП UpdateGUPPriceDate в случае добавления синонима для прайс-листа 2647
CREATE 
	DEFINER = 'Morozov'@'prg1.adc.analit.net'
TRIGGER farm.SynonymBeforeInsert
	BEFORE INSERT
	ON farm.Synonym
	FOR EACH ROW
BEGIN
  IF new.pricecode = 2647 THEN
    CALL UpdateGUPPriceDate();
    UPDATE
      usersettings.priceitems
    SET
      LastSynonymsCreation = NOW()
    WHERE
      id = 486;
  END IF;
END;


# ХП, которая обновляет PriceDate для PriceItem прайс-листа 2647
CREATE PROCEDURE farm.UpdateGUPPriceDate()
  SQL SECURITY INVOKER
BEGIN

  UPDATE usersettings.priceitems
SET    pricedate        =now(),
       LastFormalization=Now() + interval 1 second
WHERE  id               =486;

END


# Триггер, в котором изменялись настройки Intersection для прайс-листа 2647
CREATE 
	DEFINER = 'Morozov'@'prg1.adc.analit.net'
TRIGGER usersettings.IntersectionBeforeUpdate
	BEFORE UPDATE
	ON usersettings.Intersection
	FOR EACH ROW
BEGIN

  if OLD.PriceCode=2647 then
    if (SELECT SmartOrderRuleId is not null FROM RetClientsSet where ClientCode=OLD.clientcode)
    then
      Set New.invisibleonclient=0;
      set new.disabledbyclient=0;
      set new.CostCode=2647;
    else
      Set New.invisibleonclient=1;
    end if;
   end if;

END;


# Триггер, в котором изменялись настройки Intersection для прайс-листа 2647
CREATE 
	DEFINER = 'Morozov'@'prg1.adc.analit.net'
TRIGGER usersettings.RetClientsSetLogUpdate
	AFTER UPDATE
	ON usersettings.RetClientsSet
	FOR EACH ROW
BEGIN

	if OLD.SmartOrderRuleId is null and NEW.SmartOrderRuleId is not null then
		UPDATE intersection
		SET    invisibleonclient=0,
			   disabledbyclient =0,
			   CostCode         =2647
		WHERE  PriceCode        =2647
		   AND ClientCode       =OLD.ClientCode;
	end if;

	if OLD.SmartOrderRuleId is not null and NEW.SmartOrderRuleId is null then
		UPDATE intersection
		SET    invisibleonclient=1
		WHERE  PriceCode        =2647
		   AND ClientCode       =OLD.ClientCode;
	end if;

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
CREATE 
	DEFINER = 'Morozov'@'prg1.adc.analit.net'
TRIGGER usersettings.IntersectionBeforeInsert
	BEFORE INSERT
	ON usersettings.Intersection
	FOR EACH ROW
BEGIN

#Новые поставщики для НатурПродукт отключаются с обеих сторон
  if exists (select FirmCode from clientsdata where firmcode=new.clientcode and billingcode in (2401,2821,2527,100,106)) then
    set new.disabledbyclient=1;
    set new.invisibleonclient=1;
  end if;

#Новый поставщики для ГУП и Фарм... отключаются со стороны клиента

  if exists (select FirmCode from clientsdata where firmcode=new.clientcode and billingcode in (2520,2497)) then
    set new.disabledbyclient=1;
  end if;


#Новые поставщики для НатурПродукт Ритэйл отключаются с обеих сторон в СпБ
 if exists (select FirmCode from clientsdata where firmcode=new.clientcode and billingcode in (2381)) and new.RegionCode=8192 then
    set new.disabledbyclient=1;
    set new.invisibleonclient=1;
  end if;

#Отключение прайслиста Запрет НП всем, кроме Натура
 if exists (SELECT FirmCode FROM ClientsData
where BillingCode not in (2502,1546,2345,100,2501,2411,2622,2805,2381,2401,2471,2823,2472,2821,2527)
and  FirmCode = new.clientcode) and new.PriceCode=2355 then
    set new.invisibleonclient=1;
end if;


if not exists (select Id from PricesData pd join SupplierIntersection sint ON
      sint.ClientId = new.ClientCode AND sint.SupplierId = pd.FirmCode
  where pd.PriceCode = new.PriceCode) and exists(select FirmCode from PricesData where PriceCode = new.PriceCode) then
    insert into SupplierIntersection (ClientId, SupplierId)
      values (new.ClientCode, (select FirmCode from PricesData where PriceCode = new.PriceCode));
  end if;


#устарело
  if NEW.PriceCode=2647 then

    if (SELECT SmartOrderRuleId is not null FROM RetClientsSet where ClientCode=new.clientcode)
    then
      Set New.invisibleonclient=0;
      set new.disabledbyclient=0;
      set new.CostCode=2647;
    else
      Set New.invisibleonclient=1;
    end if;

  else

    if exists (select billingcode from clientsdata where firmcode=new.clientcode and billingcode in (2520,2979,2497) and (new.clientcode not in (3390, 3923, 3924,4914,4949,4950)))
    then
      Set New.invisibleonfirm=1;
      set new.invisibleonclient=1;
      set new.CostCode=null;
    end if;

  end if;
end;

