ALTER TABLE `farm`.`Excludes` ADD COLUMN `OriginalSynonymId` INT(10) UNSIGNED DEFAULT NULL AFTER `LastUsedOn`,
 ADD CONSTRAINT `FK_Excludes_Synonym` FOREIGN KEY `FK_Excludes_Synonym` (`OriginalSynonymId`)
    REFERENCES `farm`.`Synonym` (`SynonymCode`)
    ON DELETE CASCADE
    ON UPDATE RESTRICT;