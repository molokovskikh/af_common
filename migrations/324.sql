create table farm.BuyingMatrix(
  Id int not null auto_increment,
  PriceId int unsigned not null,
  AssortmentId int unsigned not null,
  primary key (Id),
  constraint FK_BuyingMatrix_PriceId foreign key (PriceId) references usersettings.PricesData(PriceCode) on delete cascade,
  constraint FK_BuyingMatrix_AssortmentId foreign key (AssortmentId) references catalogs.Assortment(Id) on delete cascade
);
