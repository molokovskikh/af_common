create table Farm.Excludes(
  Id int unsigned not null AUTO_INCREMENT,
  CatalogId int unsigned not null,
  PriceCode int unsigned not null,
  ProducerSynonymId int unsigned not null,
  primary key (Id),
  unique key ExcludesIndex (CatalogId, PriceCode, ProducerSynonymId),
  constraint FK_Excludes_CatalogId FOREIGN KEY (`CatalogId`) REFERENCES `catalogs`.`catalog` (`Id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  constraint FK_Excludes_PriceCode FOREIGN KEY (`PriceCode`) REFERENCES `usersettings`.`pricesdata` (`PriceCode`) ON DELETE CASCADE ON UPDATE RESTRICT,
  constraint FK_Excludes_ProducerSynonymId FOREIGN KEY (ProducerSynonymId) REFERENCES Farm.SynonymFirmCr(SynonymFirmCrCode) ON DELETE CASCADE ON UPDATE RESTRICT
);