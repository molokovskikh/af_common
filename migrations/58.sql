
CREATE DEFINER=`RootDBMS`@`127.0.0.1` PROCEDURE Future.GetPrices(IN ClientCodeIN INT UNSIGNED)
BEGIN

drop temporary table IF EXISTS Prices;
create temporary table
Prices
(
 FirmCode int Unsigned,
 PriceCode int Unsigned,
 CostCode int Unsigned,
 PriceSynonymCode int Unsigned,
 RegionCode BigInt Unsigned,
 Upcost decimal(7,5),
 Actual bool,
 CostType bool,
 PriceDate DateTime,
 ShowPriceName bool,
 PriceName VarChar(50),
 PositionCount int Unsigned,
 MinReq mediumint Unsigned,
 ControlMinReq bool,
 AllowOrder bool,
 ShortName varchar(50),
 FirmCategory tinyint unsigned,
 MainFirm bool,
 Storage bool,
 index (PriceCode),
 index (RegionCode)
)engine = MEMORY;

INSERT
INTO    Prices
SELECT  pd.firmcode,
        i.PriceId,
        i.CostId,
        ifnull(pd.ParentSynonym, pd.pricecode) PriceSynonymCode,
        i.RegionId,
        round((1 + pd.UpCost / 100) * (1 + prd.UpCost / 100) * (1 + i.PriceMarkup / 100), 5),
        to_days(now()) - to_days(pi.PriceDate) < f.maxold,
        pd.CostType,
        pi.PriceDate,
        r.ShowPriceName,
        pd.PriceName,
        pi.RowCount,
        if(i.MinReq > 0, i.MinReq, prd.MinReq),
        i.ControlMinReq,
        (r.OrderRegionMask & i.RegionId) > 0,
        supplier.ShortName,
        si.SupplierCategory,
        si.SupplierCategory >= r.BaseFirmCategory,
        Storage
FROM Future.Intersection i
  JOIN usersettings.PricesData pd ON pd.pricecode = i.PriceId
    join usersettings.SupplierIntersection si on si.SupplierId = pd.FirmCode and i.ClientId = si.ClientId
  JOIN usersettings.PricesCosts pc on pc.CostCode = i.CostId
    JOIN usersettings.PriceItems pi on pi.Id = pc.PriceItemId
    JOIN farm.FormRules f on f.Id = pi.FormRuleId
    JOIN usersettings.ClientsData supplier ON supplier.firmcode = pd.firmcode
    JOIN usersettings.PricesRegionalData prd ON prd.regioncode = i.RegionId AND prd.pricecode = pd.pricecode
    JOIN usersettings.RegionalData rd ON rd.RegionCode = i.RegionId AND rd.FirmCode = pd.firmcode
  JOIN Future.Clients drugstore ON drugstore.Id = i.ClientId
    JOIN usersettings.RetClientsSet r ON r.clientcode = drugstore.Id
WHERE   supplier.firmstatus = 1
    AND supplier.firmtype = 0
    and (supplier.maskregion & i.RegionId) > 0
    AND (drugstore.maskregion & i.RegionId) > 0
    AND (r.WorkRegionMask & i.RegionId) > 0
    AND pd.agencyenabled = 1
    AND pd.enabled = 1
    AND pd.pricetype <> 1
    AND prd.enabled = 1
    AND if(not r.ServiceClient, supplier.FirmCode != 234, 1)
    and i.AvailableForClient = 1
    AND i.ClientId = ClientCodeIN;

END;