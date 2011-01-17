drop procedure Usersettings.GetOffers;
CREATE DEFINER=`RootDBMS`@`127.0.0.1` PROCEDURE Usersettings.GetOffers(IN ClientCodeParam INT UNSIGNED, IN FreshOnly BOOLEAN)
BEGIN
Declare SClientCode int unsigned;
Declare ClientRegionCode bigint unsigned;
Declare TableExsists Bool DEFAULT false;
DECLARE CONTINUE HANDLER FOR 1146
if not TableExsists then
call GetActivePrices(ClientCodeParam);
set TableExsists=true;
end if;
SELECT NULL FROM ActivePrices limit 0;
DROP TEMPORARY TABLE IF EXISTS Core, MinCosts;
CREATE TEMPORARY TABLE Core (
PriceCode INT unsigned,
RegionCode bigint unsigned,
ProductId INT unsigned,
Cost DECIMAL(8,2) unsigned,
CryptCost VARCHAR(32) NOT NULL,
id bigint unsigned,
INDEX (id),
INDEX (PriceCode),
INDEX (ProductId),
INDEX (ProductId, RegionCode, Cost),
INDEX (RegionCode, id)
)engine=MEMORY ;
CREATE TEMPORARY TABLE MinCosts (
MinCost DECIMAL(8,2) unsigned,
ProductId INT unsigned,
RegionCode INT unsigned,
PriceCode INT unsigned,
id bigint unsigned,
UNIQUE  MultiK(ProductId, RegionCode, MinCost),
INDEX (id)
)engine=MEMORY;
INSERT
INTO    Core
SELECT
        Prices.PriceCode,
        Prices.regioncode,
        c.ProductId,
        if(if(round(cc.Cost*Prices.UpCost,2)<MinBoundCost, MinBoundCost, round(cc.Cost*Prices.UpCost,2))>MaxBoundCost,
        MaxBoundCost, if(round(cc.Cost*Prices.UpCost,2)<MinBoundCost, MinBoundCost, round(cc.Cost*Prices.UpCost,2))),
        '',
        c.id
FROM farm.core0 c
  JOIN ActivePrices Prices on c.PriceCode = Prices.PriceCode
    JOIN farm.CoreCosts cc on cc.Core_Id = c.Id and cc.PC_CostCode = Prices.CostCode;
Delete from Core where Cost<0.01;


if (select FirmCodeOnly from retclientsset where clientcode=ClientCodeParam) is not null then
update core, retclientsset, pricesdata
 set cost=(1+(rand()*if(rand()>0.5,2, -2)/100))*cost
 where RetClientsSet.FirmCodeOnly!=pricesdata.FirmCode
 and RetClientsSet.FirmCodeOnly=PricesData.FirmCode
 and RetClientsSet.clientcode=ClientCodeParam;
end if;

INSERT
INTO    MinCosts
SELECT  
        min(Cost),
        ProductId,
        RegionCode,
        null,
        null
FROM    Core
GROUP BY ProductId,
        RegionCode;
UPDATE MinCosts,
        Core
        SET MinCosts.ID         = Core.ID,
            MinCosts.PriceCode  = Core.PriceCode
WHERE   Core.ProductId       = MinCosts.ProductId
        And Core.RegionCode = MinCosts.RegionCode
        And Core.Cost       = MinCosts.MinCost;
END;
