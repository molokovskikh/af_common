create temporary table GoodAssertments engine memory
select Id
  from
(select asrt.Id 
  from usersettings.PricesData pd
       join usersettings.ClientsData cd on cd.FirmCode = pd.FirmCode
       join farm.Core0 core on core.PriceCode = pd.PriceCode
       join catalogs.Products prd on prd.Id = core.ProductId
       join catalogs.Producers prds on prds.Id = core.CodeFirmCr
       join catalogs.Assortment asrt on 
         asrt.CatalogId = prd.CatalogId and asrt.ProducerId = core.CodeFirmCr
 where (cd.FirmSegment = 0 and pd.PriceType <> 1)
UNION
SELECT asrt.Id
  from orders.OrdersList ol
       join catalogs.Products prd on prd.Id = ol.ProductId
       join catalogs.Assortment asrt on 
          asrt.CatalogId = prd.CatalogId and asrt.ProducerId = ol.CodeFirmCr
UNION
  select asrt.Id
    from catalogs.Assortment asrt
         join catalogs.Producers prd on prd.Id = asrt.ProducerId
    where asrt.Checked = 1 or prd.Checked = 1) tbl
 group by Id;

ALTER TABLE GoodAssertments ADD UNIQUE INDEX temporaryIndx(Id);

delete
  from catalogs.Assortment
 where Id not in (select Id from GoodAssertments);

drop temporary TABLE GoodAssertments;