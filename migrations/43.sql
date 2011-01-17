update Catalogs.Catalog c
	join Catalogs.CatalogForms cf on cf.Id = c.FormId
	join Catalogs.CatalogNames cn on cn.Id = c.NameId
set c.name = concat(cn.Name, ' ', cf.Form)
