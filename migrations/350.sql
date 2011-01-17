DROP PROCEDURE IF EXISTS OrderSendRules.GetOrderHeader;
CREATE DEFINER=`RootDBMS`@`127.0.0.1` PROCEDURE OrderSendRules.GetOrderHeader(IN idparam  integer unsigned)
BEGIN

if (select AddressId from Orders.OrdersHead where rowid = idparam) is null then

SELECT   Writetime + interval reg.MoscowBias hour Writetime     ,
         oh.ClientCode                                          ,
         PriceDate + interval reg.MoscowBias hour PriceDate     ,
         clientAddition                           ClientComment ,
         RowCount                                               ,
         oh.PriceCode                                           ,
         cd.ShortName ClientShortName                           ,
         cd.FullName  ClientFullName                            ,
         cd.Adress    ClientAddress                             ,
         (SELECT c.contactText
         FROM    contacts.contact_groups cg
                 JOIN contacts.contacts c
                 ON      cg.Id          = c.ContactOwnerId
         WHERE   cd.ContactGroupOwnerId = cg.ContactGroupOwnerId
             AND cg.Type                = 0
             AND c.Type                 = 1 limit 1
         ) AS ClientPhone                     ,
         ifnull(iinv.FirmClientCode, i2.FirmClientCode) FirmClientCode                   ,
         ifnull(iinv.FirmClientCode2, i2.FirmClientCode2) FirmClientCode2                  ,
         ifnull(iinv.FirmClientCode3, i2.FirmClientCode3) FirmClientCode3                  ,
         MIN(i.PublicCostCorr) PublicCostCorr ,
         MIN(i.FirmCostCorr)   FirmCostCorr   ,
         (SELECT ROUND(SUM(ol.cost*ol.Quantity),2)
         FROM    orders.orderslist AS ol
         WHERE   ol.orderid= oh.RowId
         )             AS Summ            ,
         cdf.ShortName AS FirmShortName   ,
         cd.regionCode    ClientRegionCode,
         pd.FirmCode                      ,
         pd.pricename   PriceName           ,
         region         RegionName          ,
         cd.firmsegment OrderSegment        ,
         rcs.ServiceClient
      OR rcs.InvisibleOnFirm = 2 AS ServiceClient,
         cd.BillingCode                          ,
         pc.CostName                             ,
         oh.RowId AS OrderId,
		 oh.AddressId,
		 oh.UserId,
		exists (
          select *
          from Usersettings.PricesData pd
            join Usersettings.CostOptimizationRules cor on cor.SupplierId = pd.FirmCode
              join Usersettings.CostOptimizationClients coc on coc.RuleId = cor.Id
          where coc.ClientId = oh.ClientCode and pd.PriceCode = oh.PriceCode
		) as IsCostOptimizationEnabled
FROM     usersettings.clientsdata                 AS cd ,
         usersettings.clientsdata                 AS cdf,
         usersettings.pricesdata                  AS pd ,
         usersettings.regionaldata                AS rd ,
         farm.regions                             AS reg,
         usersettings.retclientsset               AS rcs,
         orders.ordershead                        AS oh
         LEFT JOIN usersettings.includeregulation AS ir
         ON       ir.includeclientcode= oh.ClientCode
         LEFT JOIN usersettings.intersection i2
         ON       i2.clientcode = oh.clientcode
              AND i2.regioncode = oh.regioncode
              AND i2.pricecode  = oh.pricecode
         LEFT JOIN usersettings.intersection i
         ON       i.PriceCode  = oh.PriceCode
              AND i.regionCode = oh.regionCode
              AND i.ClientCode = IF(ir.primaryclientcode IS NULL, oh.ClientCode, ir.primaryclientcode)
         LEFT JOIN usersettings.includeregulation AS irinv
         ON       irinv.includeclientcode= oh.ClientCode
              AND irinv.includetype      =2
         LEFT JOIN usersettings.intersection iinv
         ON       iinv.PriceCode  = oh.PriceCode
              AND iinv.regionCode = oh.regionCode
              AND iinv.ClientCode = IF(irinv.primaryclientcode IS NULL, oh.ClientCode, irinv.primaryclientcode)
         LEFT JOIN usersettings.pricescosts pc
         ON       pc.costcode = i.costcode
WHERE    cd.firmcode          = oh.ClientCode
     AND oh.PriceCode         = pd.PriceCode
     AND cdf.firmcode         = pd.FirmCode
     AND rd.regionCode        = oh.regionCode
     AND rd.firmCode          = pd.FirmCode
     AND reg.regioncode       = cd.regioncode
     AND cd.firmcode          = rcs.clientcode
     AND oh.rowid             = idparam
GROUP BY oh.RowId;


else

SELECT   Writetime + interval reg.MoscowBias hour Writetime     ,
         oh.ClientCode                                          ,
         PriceDate + interval reg.MoscowBias hour PriceDate     ,
         clientAddition                           ClientComment ,
         RowCount                                               ,
         oh.PriceCode                                           ,
         if(count(lec.id)>1, le.Name, cd.name) ClientShortName                           ,
         if(count(lec.id)>1, le.FullName, cd.Fullname) ClientFullName  ,
         a.Address    ClientAddress                             ,
         (SELECT c.contactText
         FROM    contacts.contact_groups cg
                 JOIN contacts.contacts c
                 ON      cg.Id          = c.ContactOwnerId
         WHERE   cd.ContactGroupOwnerId = cg.ContactGroupOwnerId
             AND cg.Type                = 0
             AND c.Type                 = 1 limit 1
         ) AS ClientPhone                     ,
         if(ifnull(os.SwapFirmCode, 0), ai.SupplierDeliveryId, i.SupplierClientId) FirmClientCode,
         if(ifnull(os.SwapFirmCode, 0), i.SupplierClientId, ai.SupplierDeliveryId)  FirmClientCode2,
         i.SupplierPaymentId FirmClientCode3,
         0 PublicCostCorr ,
         MIN(i.PriceMarkup)   FirmCostCorr   ,
         (SELECT ROUND(SUM(ol.cost*ol.Quantity),2)
         FROM    orders.orderslist AS ol
         WHERE   ol.orderid= oh.RowId
         )  AS Summ,
         cdf.ShortName AS FirmShortName,
         cd.regionCode ClientRegionCode,
         pd.FirmCode,
         pd.pricename   PriceName,
         region         RegionName,
         cd.segment OrderSegment,
         rcs.ServiceClient OR rcs.InvisibleOnFirm = 2 AS ServiceClient,
         cd.PayerId as BillingCode,
         pc.CostName,
         oh.RowId AS OrderId,
         oh.AddressId,
         oh.UserId,
  exists (
   select *
   from Usersettings.PricesData pd
    join Usersettings.CostOptimizationRules cor on cor.SupplierId = pd.FirmCode
     join Usersettings.CostOptimizationClients coc on coc.RuleId = cor.Id
   where coc.ClientId = oh.ClientCode and pd.PriceCode = oh.PriceCode
  ) as IsCostOptimizationEnabled
FROM     (Future.Clients                 AS cd ,
         usersettings.clientsdata                 AS cdf,
         usersettings.pricesdata                  AS pd ,
         usersettings.regionaldata                AS rd ,
         farm.regions                             AS reg,
         usersettings.retclientsset               AS rcs,
         orders.ordershead                        AS oh)
  join Future.Addresses a on a.Id = oh.AddressId 
  left join Future.Intersection i ON i.PriceId  = oh.PriceCode AND i.RegionId = oh.regionCode AND i.ClientId = oh.ClientCode and i.LegalEntityId = a.LegalEntityId
  left join Future.AddressIntersection ai on ai.AddressId = a.Id and ai.IntersectionId = i.Id
  join Billing.LegalEntities le on le.Id = a.LegalEntityId
  join Billing.LegalEntities lec on lec.PayerId=cd.Payerid
  left join usersettings.pricescosts pc ON pc.costcode = i.CostId
  left join Future.OrderSwap os on os.ClientId = oh.ClientCode and os.SupplierId = cdf.FirmCode
WHERE    cd.Id          = oh.ClientCode
     AND oh.PriceCode         = pd.PriceCode
     AND cdf.firmcode         = pd.FirmCode
     AND rd.regionCode        = oh.regionCode
     AND rd.firmCode          = pd.FirmCode
     AND reg.regioncode       = cd.regioncode
     AND cd.Id          = rcs.clientcode
     AND oh.rowid             = idparam
GROUP BY oh.RowId;

end if;

END;
