drop trigger if exists farm.SynonymAfterInsert;

CREATE 
	DEFINER = RootDBMS@127.0.0.1
TRIGGER farm.SynonymAfterInsert
	AFTER INSERT
	ON farm.Synonym
	FOR EACH ROW
BEGIN
  insert into farm.SynonymArchive(SynonymCode, PriceCode, Synonym, ProductId, Junk)
  values(NEW.SynonymCode, NEW.PriceCode, NEW.Synonym, NEW.ProductId, NEW.Junk);
END;