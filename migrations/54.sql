CREATE DEFINER = RootDBMS@127.0.0.1
TRIGGER Catalogs.CatalogNameBeforeUpdate BEFORE UPDATE ON Catalogs.CatalogNames FOR EACH ROW
BEGIN

	update Catalogs.Catalog c
		join Catalogs.CatalogForms cf on cf.Id = c.FormId
	set c.name = concat(NEW.Name, ' ', cf.Form)
	where c.NameId = OLD.Id;

END;