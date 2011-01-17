CREATE DEFINER = RootDBMS@127.0.0.1
TRIGGER Future.UserPricesBeforeDelete BEFORE DELETE ON Future.UserPrices FOR EACH ROW
BEGIN

	update Usersettings.AnalitFReplicationInfo ar
	join Usersettings.PricesData pd on pd.FirmCode = ar.FirmCode
	set ForceReplication = 1
	where ar.UserId = OLD.UserId and pd.PriceCode = OLD.PriceId;

END;

CREATE DEFINER = RootDBMS@127.0.0.1
TRIGGER Future.UserPricesBeforeInsert BEFORE INSERT ON Future.UserPrices FOR EACH ROW
BEGIN

	update Usersettings.AnalitFReplicationInfo ar
	join Usersettings.PricesData pd on pd.FirmCode = ar.FirmCode
	set ForceReplication = 1
	where ar.UserId = NEW.UserId and pd.PriceCode = NEW.PriceId;

END;