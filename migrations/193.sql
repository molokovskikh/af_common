DROP TABLE IF EXISTS `documents`.`DocumentBodies`;
CREATE TABLE  `documents`.`DocumentBodies` (
  `Id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `DocumentId` int(10) unsigned NOT NULL,
  `Product` varchar(255) DEFAULT NULL,
  `Code` varchar(20) DEFAULT NULL,
  `Certificates` varchar(50) DEFAULT NULL,
  `Period` varchar(20) DEFAULT NULL COMMENT 'Срок годности',
  `Producer` varchar(255) DEFAULT NULL,
  `Country` varchar(150) DEFAULT NULL COMMENT 'Страна',
  `ProducerCost` decimal(12,6) unsigned DEFAULT NULL COMMENT 'Цена производителя без НДС',
  `RegistryCost` decimal(12,6) DEFAULT NULL,
  `SupplierPriceMarkup` decimal(5,3) DEFAULT NULL COMMENT 'Торговая надбавка оптовика',
  `SupplierCostWithoutNDS` decimal(12,6) unsigned DEFAULT NULL COMMENT 'Цена поставщика без НДС',
  `SupplierCost` decimal(12,6) unsigned DEFAULT NULL COMMENT 'Цена поставщика c НДС или цена в отказе',
  `Quantity` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`Id`),
  KEY `FK_DocumentBodies_DocumentId` (`DocumentId`),
  CONSTRAINT `FK_DocumentBodies_DocumentId` FOREIGN KEY (`DocumentId`) REFERENCES `documentheaders` (`Id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;