DROP PROCEDURE IF EXISTS ordersendrules.GetOrderRows;
CREATE DEFINER = 'RootDBMS'@'127.0.0.1'
PROCEDURE ordersendrules.GetOrderRows(IN IdParam INTEGER UNSIGNED)
BEGIN

if (select AddressId from Orders.OrdersHead where rowid = idparam) is null then

  SELECT  ol.Code,
        ol.CodeCr,
        if(st.Synonym is null, concat(cn.name,'  ', concat(cf.form, ' ', ifnull(group_concat(pv.`value` SEPARATOR ' '), ''))), st.synonym) as FullName,
        if(si.SynonymFirmcrCode is null, ifNull(pr.Name, '-'), si.synonym) as CrName,
        ol.ProductId as FullCode,
        ol.CodeFirmCr,
        ol.Quantity,
        ol.Cost,
        ol.Junk,
        ol.Await,
        ol.RetailMarkup,

        OrderedOffers.period as Period,
        ol.Cost as basecost,
        ol.RowId
FROM    (orders.ordershead as oh, orders.orderslist as ol, usersettings.intersection i, usersettings.retclientsset rcs)
  LEFT JOIN Orders.OrderedOffers as OrderedOffers on OrderedOffers.id = ol.rowid
  JOIN Catalogs.Products as p on p.Id = ol.ProductId
  JOIN Catalogs.Catalog as ca on ca.Id = p.CatalogId
  JOIN Catalogs.catalognames cn on cn.id = ca.nameid
  JOIN Catalogs.catalogforms cf on cf.id = ca.formid
    LEFT JOIN Catalogs.productproperties pp on p.id = pp.productid
      LEFT JOIN Catalogs.propertyvalues pv on pv.id = pp.propertyvalueid
LEFT JOIN farm.synonymArchive as st
        ON st.SynonymCode = ol.SynonymCode
LEFT JOIN farm.synonymFirmCr as si
        ON si.SynonymFirmCrCode = ol.SynonymFirmCrCode





  LEFT JOIN Catalogs.Producers pr ON pr.Id = ol.CodefirmCr
WHERE   oh.RowId           = ol.Orderid
        AND p.Id           = ol.ProductId
        AND i.clientcode   = oh.clientcode
        AND i.regioncode   = oh.regioncode
        AND i.pricecode    = oh.pricecode
        AND rcs.clientcode = oh.clientcode
        AND ol.orderid     =IdParam
GROUP BY ol.RowId, p.id, cf.id
ORDER BY FullName;


else

  SELECT  ol.Code,
        ol.CodeCr,
        if(st.Synonym is null, concat(cn.name,'  ', concat(cf.form, ' ', ifnull(group_concat(pv.`value` SEPARATOR ' '), ''))), st.synonym) as FullName,
        if(si.SynonymFirmcrCode is null, ifNull(pr.Name, '-'), si.synonym) as CrName,
        ol.ProductId as FullCode,
        ol.CodeFirmCr,
        ol.Quantity,
        ol.Cost,
        ol.Junk,
        ol.Await,
        ol.retailmarkup,

        OrderedOffers.period as Period,
        ol.Cost as basecost,
        ol.RowId
FROM    (orders.ordershead as oh, orders.orderslist as ol, Future.intersection i, usersettings.retclientsset rcs)
  LEFT JOIN Orders.OrderedOffers as OrderedOffers on OrderedOffers.id = ol.rowid	
  JOIN Catalogs.Products as p on p.Id = ol.ProductId
  JOIN Catalogs.Catalog as ca on ca.Id = p.CatalogId
  JOIN Catalogs.catalognames cn on cn.id = ca.nameid
  JOIN Catalogs.catalogforms cf on cf.id = ca.formid
    LEFT JOIN Catalogs.productproperties pp on p.id = pp.productid
      LEFT JOIN Catalogs.propertyvalues pv on pv.id = pp.propertyvalueid
LEFT JOIN farm.synonymArchive as st
        ON st.SynonymCode = ol.SynonymCode
LEFT JOIN farm.synonymFirmCr as si
        ON si.SynonymFirmCrCode = ol.SynonymFirmCrCode





  LEFT JOIN Catalogs.Producers pr ON pr.Id = ol.CodefirmCr
WHERE   oh.RowId           = ol.Orderid
        AND p.Id           = ol.ProductId
        AND i.ClientId   = oh.clientcode
        AND i.RegionId   = oh.regioncode
        AND i.PriceId    = oh.pricecode
        AND rcs.clientcode = oh.clientcode
        AND ol.orderid     = IdParam
GROUP BY ol.RowId, p.id, cf.id
ORDER BY FullName;

end if;

END