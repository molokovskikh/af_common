drop trigger if exists `catalogs`.`CatalogBeforeUpdate`;
 
CREATE
DEFINER=`RootDBMS`@`127.0.0.1`
TRIGGER `catalogs`.`CatalogBeforeUpdate`
BEFORE UPDATE ON `catalogs`.`catalog`
FOR EACH ROW
BEGIN

  IF NEW.Hidden = 1 AND old.Hidden = 0 THEN
    UPDATE
      Products
    SET
      Hidden = 1
    WHERE
      CatalogId = NEW.Id;
    DELETE
    FROM
      farm.excludes
    WHERE
      catalogId = NEW.Id;
    DELETE
    FROM
      catalogs.Assortment
    WHERE
      catalogId = new.Id;
   
  END IF;

  IF NEW.Hidden = 0 AND old.Hidden = 1 THEN
  
    SET new.Name = (SELECT
      CONCAT(cn.Name, ' ', cf.Form)
    FROM
      catalog c,
      catalognames cn,
      catalogforms cf
    WHERE
      cn.id = c.nameid
      AND cf.id = c.formid
      AND c.id = old.Id);
  END IF;
END;