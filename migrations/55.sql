CREATE DEFINER = RootDBMS@127.0.0.1
TRIGGER Catalogs.CatalogFormBeforeUpdate BEFORE UPDATE ON Catalogs.CatalogForms FOR EACH ROW
BEGIN

	update Catalogs.Catalog c
		join Catalogs.CatalogNames cn on cn.Id = c.NameId
	set c.name = concat(cn.Name, ' ', NEW.Form)
	where c.FormId = NEW.Id;

END;