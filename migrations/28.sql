create table farm.AutomaticProducerSynonyms(
  ProducerSynonymId int unsigned not null,
  Primary key (ProducerSynonymId),
  constraint FK_ProducerSynonymId FOREIGN KEY (ProducerSynonymId) REFERENCES Farm.SynonymFirmCr(SynonymFirmCrCode) ON DELETE CASCADE ON UPDATE RESTRICT
);
  