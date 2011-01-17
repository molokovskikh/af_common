drop temporary table if exists farm.TempForDeleteFromExcludes;
create temporary table farm.TempForDeleteFromExcludes engine 'memory'
	select e.Id
	from farm.excludes e
		join farm.synonymfirmcr sfc on e.Producersynonymid = sfc.SynonymFirmCrCode
		join catalogs.assortment a on a.CatalogId = e.CatalogId and a.ProducerId = sfc.CodeFirmCr;
delete from farm.excludes where excludes.Id in (select Id from farm.TempForDeleteFromExcludes);
drop temporary table if exists farm.TempForDeleteFromExcludes;