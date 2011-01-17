alter table Future.UserPrices
add column RegionId bigint unsigned;

update Future.UserPrices up
	join Future.Users u on u.Id = up.UserId
	join Future.Clients c on c.Id = u.ClientId
set up.RegionId = c.RegionCode;