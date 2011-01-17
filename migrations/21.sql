create table Farm.SuspiciousSynonyms(
	Id int unsigned not null AUTO_INCREMENT,
	ProducerSynonymId int unsigned not null,
	primary key (Id),
	constraint FK_ProducerSynonymLogId FOREIGN KEY (ProducerSynonymId) REFERENCES Farm.SynonymFirmCr(SynonymFirmCrCode) ON DELETE CASCADE ON UPDATE RESTRICT
);