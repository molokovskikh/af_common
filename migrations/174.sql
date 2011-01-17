update Catalogs.Catalog c
	join Catalogs.Products p on p.CatalogId = c.ID
		join farm.Core0 c0 on c0.ProductId = p.Id
set c.VitallyImportant = c0.VitallyImportant
where c0.PriceCode = 2693 and c0.VitallyImportant = 1;