DROP PROCEDURE IF EXISTS usersettings.GetActivePrices;

CREATE DEFINER = 'RootDBMS'@'127.0.0.1'
PROCEDURE usersettings.GetActivePrices(IN ClientCodeParam INT UNSIGNED)
BEGIN
Declare TabelExsists Bool DEFAULT false;
DECLARE CONTINUE HANDLER FOR 1146
begin
Call GetPrices(ClientCodeParam);
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
 Fresh bool,
 DelayOfPayment decimal(5,3),
 Upcost decimal(7,5),
 PublicUpCost decimal(7,5),
 MaxSynonymCode Int Unsigned,
 MaxSynonymFirmCrCode Int Unsigned,
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
 index  (MaxSynonymCode),
 index  (PriceCode),
 index  (MaxSynonymFirmCrCode)
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
 Fresh,
 DelayOfPayment,
 Upcost,
 PublicUpCost,
 MaxSynonymCode,
 MaxSynonymFirmCrCode,
 
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
        Fresh,
        DelayOfPayment,
        Upcost,
        PublicUpCost,
        MaxSynonymCode,
        MaxSynonymFirmCrCode,
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
WHERE   AlowInt =0
    AND DisabledByClient=0
    AND Actual=1;
drop temporary table IF EXISTS Prices;
END