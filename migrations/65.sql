CREATE DEFINER = RootDBMS@127.0.0.1
TRIGGER Future.IntersectionAfterInsert AFTER INSERT ON Future.Intersection FOR EACH ROW
BEGIN

	if @Skip is null or @Skip <> 1 then

		insert into Future.AddressIntersection(IntersectionId, AddressId)
		select NEW.Id, a.Id
		from Future.Clients c
			join Future.Addresses a on a.ClientId = c.Id
		where c.Id = NEW.ClientId;

		insert into Future.UserPrices(UserId, PriceId)
		select u.Id, NEW.PriceId
		from Future.Clients c 
			join Future.Users u on u.ClientId = c.Id
		where c.Id = NEW.ClientId;

		insert into Usersettings.SupplierIntersection(SupplierId, ClientId)
		select pd.FirmCode, NEW.ClientId
		from Usersettings.PricesData pd
			left join Usersettings.SupplierIntersection si on si.SupplierId = pd.FirmCode and si.ClientId = NEW.ClientId
		where pd.PriceCode = NEW.PriceId and si.Id is null
		group by pd.FirmCode;

	end if;

END;