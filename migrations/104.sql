alter table Future.UserPrices
drop primary key,
add primary key(UserId, PriceId, RegionId);
