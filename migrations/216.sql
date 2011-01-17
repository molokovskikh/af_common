﻿DROP PROCEDURE IF EXISTS usersettings.GetPrices;

CREATE DEFINER = 'RootDBMS'@'127.0.0.1'
PROCEDURE usersettings.GetPrices(IN ClientCodeIN INT UNSIGNED)
BEGIN
Declare ClientCodeP int unsigned;
SELECT  min(primaryclientcode) into ClientCodeP  FROM includeregulation where includeclientcode=ClientCodeIN;
if ClientCodeP is null then
set ClientCodeP =ClientCodeIN;
end if;
drop temporary table IF EXISTS Prices;
CREATE TEMPORARY TABLE
Prices(
  FirmCode INT UNSIGNED,
  PriceCode INT UNSIGNED,
  CostCode INT UNSIGNED,
  PriceSynonymCode INT UNSIGNED,
  RegionCode BIGINT UNSIGNED,
  AlowInt BOOL,
  Fresh BOOL,
  DelayOfPayment DECIMAL (5, 3),
  Upcost DECIMAL (7, 5),
  PublicUpCost DECIMAL (7, 5),
  MaxSynonymCode INT UNSIGNED,
  MaxSynonymFirmCrCode INT UNSIGNED,
  DisabledByClient BOOL,
  Actual BOOL,
  CostType BOOL,
  PriceDate DATETIME,
  ShowPriceName BOOL,
  PriceName VARCHAR (50),
  PositionCount INT UNSIGNED,
  MinReq SMALLINT UNSIGNED,
  ControlMinReq BOOL,
  CostCorrByClient BOOL,
  AllowOrder BOOL,
  ShortName VARCHAR (50),
  FirmCategory TINYINT UNSIGNED,
  MainFirm BOOL,
  Storage BOOL,
  INDEX (PriceCode),
  INDEX (RegionCode)


) ENGINE = MEMORY;
INSERT
INTO    Prices
SELECT  pricesdata.firmcode,
        i.pricecode,
        i.costcode,
        ifnull(pricesdata.ParentSynonym, pricesdata.pricecode) PriceSynonymCode,
        i.RegionCode,
        AlowInt,
        0,
        si.DelayOfPayment,
        round((1+pricesdata.UpCost/100) * (1+pricesregionaldata.UpCost/100) * (1+(i.FirmCostCorr+i.PublicCostCorr)/100), 5),
        i.PublicCostCorr,
        0,
        0,
       if(iu.id is not null, iu.DisabledByClient, i.DisabledByClient),
        to_days(now())-to_days(pi.PriceDate)< f.maxold,
        pricesdata.CostType,
        date_sub(pi.PriceDate, interval time_to_sec(date_sub(now(), interval unix_timestamp() second)) second),
        if(iu.id is not null, ru.ShowPriceName, r.ShowPriceName),
        PriceName,
        pi.RowCount,
        if(i.MinReq>0, i.MinReq, pricesregionaldata.MinReq),
        if(iu.id is not null AND ir.includetype IN (1), iu.ControlMinReq, i.ControlMinReq),
        if(ir.includetype is not null, 0, i.CostCorrByClient),
        (if(iu.id is not null, ru.OrderRegionMask, r.OrderRegionMask) & i.RegionCode) > 0,
        clientsdata.ShortName,
        if(iu.id is not null, iu.FirmCategory, i.FirmCategory),
        if(iu.id is not null, iu.FirmCategory>=ru.BaseFirmCategory, i.FirmCategory>=r.BaseFirmCategory),
        Storage
FROM usersettings.intersection i
  JOIN usersettings.pricesdata ON pricesdata.pricecode = i.pricecode
  JOIN usersettings.SupplierIntersection si on si.SupplierId = pricesdata.FirmCode and i.ClientCode = si.ClientId
  JOIN usersettings.PricesCosts pc on pc.CostCode = i.CostCode
    JOIN usersettings.PriceItems pi on pi.Id = pc.PriceItemId
      JOIN farm.formrules f on f.Id = pi.FormRuleId
    JOIN usersettings.clientsdata ON clientsdata.firmcode = pricesdata.firmcode
    JOIN usersettings.pricesregionaldata ON pricesregionaldata.regioncode = i.regioncode AND pricesregionaldata.pricecode = pricesdata.pricecode
    JOIN usersettings.RegionalData rd ON rd.RegionCode = i.regioncode AND rd.FirmCode = pricesdata.firmcode
  JOIN usersettings.clientsdata as AClientsData ON AClientsData.firmcode = i.clientcode and clientsdata.firmsegment = AClientsData.firmsegment
    JOIN usersettings.retclientsset r ON r.clientcode = AClientsData.FirmCode
  LEFT JOIN usersettings.intersection iu ON iu.pricecode = i.pricecode and iu.clientcode = ClientCodeIN and i.regioncode = iu.regioncode
  LEFT JOIN usersettings.retclientsset ru ON ru.clientcode = iu.clientcode
  LEFT JOIN usersettings.includeregulation ir ON ir.primaryclientcode = ClientCodeP AND ir.includeclientcode = ClientCodeIN
WHERE   i.DisabledByAgency = 0
    AND clientsdata.firmstatus = 1
    AND clientsdata.firmtype = 0
    AND (clientsdata.maskregion & i.regioncode) > 0
    AND (AClientsData.maskregion & i.regioncode) > 0
    AND pricesdata.agencyenabled = 1
    AND pricesdata.enabled = 1
    AND pricesdata.pricetype <> 1
    AND pricesregionaldata.enabled = 1
    AND if(not r.ServiceClient, clientsdata.FirmCode!=234, 1)
    AND (if(iu.id is not null, ru.WorkRegionMask, r.WorkRegionMask) & i.regioncode) > 0
    AND if(iu.id is not null AND ir.includetype IN (1), 1,  i.invisibleonclient = 0)
    AND if(iu.id is not null, iu.disabledbyagency = 0, 1)
    AND if(iu.id is not null AND ir.includetype IN (1), iu.invisibleonclient=0, 1)
    AND i.clientcode = ClientCodeP;
END