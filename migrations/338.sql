delete from catalogs.ProducerEquivalents where Id in (410, 902, 1077);

insert into farm.Synonym 
  (PriceCode, ProductId, Synonym)
  select 
    2647, min(p.Id), c.Name
  from
    catalogs.Catalog c
    inner join catalogs.Products p on p.CatalogId = c.Id and p.Hidden = 0
  where
     c.Hidden = 0
  group by c.Id; 

insert into farm.SynonymFirmCr
  (PriceCode, CodeFirmCr, Synonym)
  select 
    2647, p.Id, p.Name
  from
    catalogs.Producers p
  where
    p.Checked = 1;


insert into farm.SynonymFirmCr
  (PriceCode, CodeFirmCr, Synonym)
  select
    2647, p.Id, pe.Name
  from
    catalogs.Producers p
    inner join catalogs.ProducerEquivalents pe on pe.ProducerId = p.Id and pe.Name <> p.Name
  where
    p.Checked = 1;