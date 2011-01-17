create table Catalogs.ProducerEquivalents(
  Id int unsigned not null AUTO_INCREMENT,
  Name int unsigned not null,
  ProducerId int unsigned not null,
  PRIMARY KEY (Id),
  CONSTRAINT FK_ProducerId FOREIGN KEY (ProducerId) REFERENCES farm.CatalogFirmCr(CodeFirmCr)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;