﻿CREATE TABLE `catalogs`.`Mnn` (
  `Id` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  `Mnn` VARCHAR(255) CHARACTER SET cp1251 COLLATE cp1251_general_ci NOT NULL,
  `Description` MEDIUMTEXT CHARACTER SET cp1251 COLLATE cp1251_general_ci DEFAULT NULL,
  `VitallyImportant` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0,
  `MandatoryList` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (`Id`)
)
ENGINE = InnoDB;