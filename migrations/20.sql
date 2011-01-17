create table Farm.BlockedProducerSynonyms(
	Id int unsigned not null AUTO_INCREMENT,
	ProducerId int unsigned not null,
        PriceCode int unsigned not null, 
	Synonym varchar(255) not null,
	BlockedOn DateTime not null,
	primary key (Id),
	constraint FK_ProducerId FOREIGN KEY FK_ProducerId(ProducerId) REFERENCES Catalogs.Producers(Id) ON DELETE CASCADE ON UPDATE RESTRICT,
        constraint FK_PriceCode FOREIGN KEY (`PriceCode`) REFERENCES `usersettings`.`pricesdata` (`PriceCode`) ON DELETE CASCADE ON UPDATE RESTRICT
);