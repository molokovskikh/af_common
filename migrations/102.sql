alter table Future.UserPrices
change column RegionId RegionId bigint unsigned not null,
add constraint FK_UserPrices_RegionId foreign key (RegionId) references Farm.Regions(RegionCode) on delete cascade;
