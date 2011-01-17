CREATE DEFINER = RootDBMS@127.0.0.1
TRIGGER Catalogs.CatalogBeforeInsert BEFORE INSERT ON Catalogs.Catalog FOR EACH ROW
BEGIN

	SET NEW.Name = (
		select concat(cn.Name, ' ', cf.Form)
		from Catalogs.CatalogNames cn, Catalogs.CatalogForms cf
		where cn.Id = New.NameId and cf.Id = New.FormId
	);

END;