create temporary table Catalogs.mnn_names engine=memory
SELECT m.Id, c.NameId
FROM Catalogs.ProtekCatalog pc
join farm.Synonym s on pc.Synonym = s.Synonym
join Catalogs.Products p on p.Id = s.ProductId
join Catalogs.Catalog c on c.Id = p.CatalogId
join catalogs.Mnn m on m.Mnn = pc.Mnn
where s.PriceCode = 5
group by c.nameId;

update catalogs.CatalogNames
 join Catalogs.mnn_names on CatalogNames.Id = mnn_names.NameId
set CatalogNames.MnnId = mnn_names.Id;