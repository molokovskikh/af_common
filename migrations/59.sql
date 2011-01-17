CREATE DEFINER=`RootDBMS`@`127.0.0.1` PROCEDURE Future.GetActivePrices(IN UserIdParam INT UNSIGNED)
BEGIN

Declare TabelExsists Bool DEFAULT false;
Declare ClientCodeParam INT UNSIGNED;
DECLARE CONTINUE HANDLER FOR 1146
begin
SELECT ClientId
INTO   ClientCodeParam
FROM   future.Users
WHERE  Id = UserIdParam;
Call Future.GetPrices(ClientCodeParam);
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
 MainFirm
        )
SELECT P.FirmCode            ,
       P.PriceCode           ,
       P.CostCode            ,
       P.PriceSynonymCode    ,
       P.RegionCode          ,
       A.ForceReplication !=0,
       P.Upcost              ,
       A.MaxSynonymCode      ,
       A.MaxSynonymFirmCrCode,
       P.CostType            ,
       P.PriceDate           ,
       P.ShowPriceName       ,
       P.PriceName           ,
       P.PositionCount       ,
       P.MinReq              ,
       P.FirmCategory        ,
       P.MainFirm
FROM Prices P
  join Usersettings.AnalitFReplicationInfo A on A.FirmCode = P.FirmCode
  join future.UserPrices up on up.PriceId = p.PriceCode
WHERE  Actual = 1
  and A.UserId = UserIdParam
  and up.UserId = UserIdParam;
 
drop temporary table IF EXISTS Prices;

END;