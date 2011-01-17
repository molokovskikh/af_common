DROP PROCEDURE IF EXISTS Future.GetActivePricesForAddress;

CREATE DEFINER = 'RootDBMS'@'127.0.0.1'
PROCEDURE future.GetActivePricesForAddress(IN UserIdParam INT UNSIGNED, IN AddressIdParam INT UNSIGNED)
BEGIN

Declare TabelExsists Bool DEFAULT false;
DECLARE CONTINUE HANDLER FOR 1146
begin
  Call Future.GetPricesForAddress(UserIdParam, AddressIdParam);
end;

if not TabelExsists then
DROP TEMPORARY TABLE IF EXISTS Usersettings.ActivePrices;
create temporary table
Usersettings.ActivePrices
(
 FirmCode int Unsigned,
 PriceCode int Unsigned,
 CostCode int Unsigned,
 PriceSynonymCode int Unsigned,
 RegionCode BigInt Unsigned,
 Fresh bool,
 DelayOfPayment decimal(5,3),
 Upcost decimal(7,5),
 MaxSynonymCode Int Unsigned,
 MaxSynonymFirmCrCode Int Unsigned,
 CostType bool,
 PriceDate DateTime,
 ShowPriceName bool,
 PriceName VarChar(50),
 PositionCount int Unsigned,
 MinReq mediumint Unsigned,
 FirmCategory tinyint unsigned,
 MainFirm bool,
 unique (PriceCode, RegionCode, CostCode),
 index  (CostCode, PriceCode),
 index  (PriceSynonymCode),
 index  (MaxSynonymCode),
 index  (PriceCode),
 index  (MaxSynonymFirmCrCode)
 )engine=MEMORY
 ;
set TabelExsists=true;
end if;

select null from Usersettings.Prices limit 0;

INSERT
INTO Usersettings.ActivePrices(
 FirmCode,
 PriceCode,
 CostCode,
 PriceSynonymCode,
 RegionCode,
 Fresh,
 DelayOfPayment,
 Upcost,
 MaxSynonymCode,
 MaxSynonymFirmCrCode,
 CostType,
 PriceDate,
 ShowPriceName,
 PriceName,
 PositionCount,
 MinReq,
 FirmCategory,
 MainFirm)
SELECT P.FirmCode,
       P.PriceCode,
       P.CostCode,
       P.PriceSynonymCode,
       P.RegionCode,
       1,
       p.DelayOfPayment,
       P.Upcost,
       0,
       0,
       P.CostType,
       P.PriceDate,
       P.ShowPriceName,
       P.PriceName,
       P.PositionCount,
       P.MinReq,
       P.FirmCategory,
       P.MainFirm
FROM Usersettings.Prices P
WHERE p.DisabledByClient = 0
  and p.Actual = 1;

drop temporary table IF EXISTS Usersettings.Prices;

END;



DROP PROCEDURE IF EXISTS Future.GetActivePrices;

CREATE DEFINER=`RootDBMS`@`127.0.0.1` 
PROCEDURE future.`GetActivePrices`(IN UserIdParam INT UNSIGNED)
BEGIN

Declare TabelExsists Bool DEFAULT false;
DECLARE CONTINUE HANDLER FOR 1146
begin
  Call Future.GetPrices(UserIdParam);
end;

if not TabelExsists then
DROP TEMPORARY TABLE IF EXISTS Usersettings.ActivePrices;
create temporary table
Usersettings.ActivePrices
(
 FirmCode int Unsigned,
 PriceCode int Unsigned,
 CostCode int Unsigned,
 PriceSynonymCode int Unsigned,
 RegionCode BigInt Unsigned,
 Fresh bool,
 DelayOfPayment decimal(5,3),
 Upcost decimal(7,5),
 MaxSynonymCode Int Unsigned,
 MaxSynonymFirmCrCode Int Unsigned,
 CostType bool,
 PriceDate DateTime,
 ShowPriceName bool,
 PriceName VarChar(50),
 PositionCount int Unsigned,
 MinReq mediumint Unsigned,
 FirmCategory tinyint unsigned,
 MainFirm bool,
 unique (PriceCode, RegionCode, CostCode),
 index  (CostCode, PriceCode),
 index  (PriceSynonymCode),
 index  (MaxSynonymCode),
 index  (PriceCode),
 index  (MaxSynonymFirmCrCode)
 )engine=MEMORY
 ;
set TabelExsists=true;
end if;

select null from Usersettings.Prices limit 0;

INSERT
INTO Usersettings.ActivePrices(
 FirmCode,
 PriceCode,
 CostCode,
 PriceSynonymCode,
 RegionCode,
 Fresh,
 DelayOfPayment,
 Upcost,
 MaxSynonymCode,
 MaxSynonymFirmCrCode,
 CostType,
 PriceDate,
 ShowPriceName,
 PriceName,
 PositionCount,
 MinReq,
 FirmCategory,
 MainFirm)
SELECT P.FirmCode,
       P.PriceCode,
       P.CostCode,
       P.PriceSynonymCode,
       P.RegionCode,
       1,
       p.DelayOfPayment,
       P.Upcost,
       0,
       0,
       P.CostType,
       P.PriceDate,
       P.ShowPriceName,
       P.PriceName,
       P.PositionCount,
       P.MinReq,
       P.FirmCategory,
       P.MainFirm
FROM Usersettings.Prices P
WHERE p.DisabledByClient = 0
  and p.Actual = 1;

drop temporary table IF EXISTS Usersettings.Prices;

END;



DROP PROCEDURE IF EXISTS usersettings.GetActivePrices2;

CREATE DEFINER=`RootDBMS`@`127.0.0.1` 
PROCEDURE usersettings.`GetActivePrices2`(IN ClientCodeParam INT UNSIGNED)
BEGIN
Declare TabelExsists Bool DEFAULT false;
DECLARE CONTINUE HANDLER FOR 1146
begin
Call GetPrices2(ClientCodeParam);
end;
if not TabelExsists then
DROP TEMPORARY TABLE IF EXISTS  ActivePrices;
create temporary table
ActivePrices
(
 FirmCode int Unsigned,
 PriceCode int Unsigned,
 CostCode int Unsigned,
 PriceSynonymCode int Unsigned,
 RegionCode BigInt Unsigned,
 DelayOfPayment decimal(5,3),
 Upcost decimal(7,5),
 PublicUpCost decimal(7,5),
 CostType bool,
 PriceDate DateTime,
 ShowPriceName bool,
 PriceName VarChar(50),
 PositionCount int Unsigned,
 MinReq smallint Unsigned,
 CostCorrByClient bool,
 FirmCategory tinyint unsigned,
 MainFirm bool,
 unique (PriceCode, RegionCode, CostCode),
 index  (CostCode, PriceCode),
 index  (PriceSynonymCode),
 index  (PriceCode)
 )engine=MEMORY
 ;
set TabelExsists=true;
end if;
select null from Prices limit 0;
INSERT
INTO    ActivePrices
        (
 FirmCode,
 PriceCode,
 CostCode,
 PriceSynonymCode,
 RegionCode,
 DelayOfPayment,
 Upcost,
 PublicUpCost,
 CostType,
 PriceDate,
 ShowPriceName,
 PriceName,
 PositionCount,
 MinReq,
 CostCorrByClient,
 FirmCategory,
 MainFirm
        ) 
SELECT  FirmCode,
        PriceCode, 
        CostCode,
        PriceSynonymCode,
        RegionCode,
        DelayOfPayment,
        Upcost,
        PublicUpCost,
        CostType,
        PriceDate,
        ShowPriceName,
        PriceName,
        PositionCount,
        MinReq,
        CostCorrByClient,
        FirmCategory,
        MainFirm
FROM    Prices 
WHERE DisabledByClient=0
  and Actual = 1;
drop temporary table IF EXISTS Prices;
END;