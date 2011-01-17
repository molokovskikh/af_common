ALTER TABLE `logs`.`downlogs` ADD COLUMN `SourceTypeId` INT(11) UNSIGNED DEFAULT NULL AFTER `ShortErrorMessage`,
 ADD CONSTRAINT `FK_downlogs_SourceTypeId` FOREIGN KEY `FK_downlogs_SourceTypeId` (`SourceTypeId`)
    REFERENCES `farm`.`sourcetypes` (`Id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT;