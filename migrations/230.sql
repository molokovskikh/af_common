ALTER TABLE `catalogs`.`ProducerEquivalents` ADD CONSTRAINT `FK_ProducerId` FOREIGN KEY `FK_ProducerId` (`ProducerId`)
    REFERENCES `catalogs`.`Producers` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;