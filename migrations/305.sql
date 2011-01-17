CREATE TABLE `billing`.`LegalEntities` (

  `Id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,

  `PayerId` INT(10) UNSIGNED NOT NULL,

  `Name` VARCHAR(100) COMMENT 'Краткое наименование',

  `FullName` VARCHAR(255) COMMENT 'Полное наименование',

  `Address` VARCHAR(255) COMMENT 'Юридический адрес',

  `ReceiverAddress` VARCHAR(255) COMMENT 'Адрес получателя',

  `INN` VARCHAR(12) COMMENT 'ИНН',

  `KPP` VARCHAR(9) COMMENT 'КПП',

  PRIMARY KEY (`Id`),
  CONSTRAINT `FK_LegalEntities_PayerId` FOREIGN KEY `FK_LegalEntities_PayerId` (`PayerId`)
    REFERENCES `payers` (`PayerID`));