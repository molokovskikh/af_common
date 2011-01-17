ALTER TABLE `future`.`Users` ADD COLUMN `ContactGroupId` INT(10) UNSIGNED DEFAULT NULL AFTER `Registrant`,
 ADD CONSTRAINT `FK_Users_ContactGroupId` FOREIGN KEY `FK_Users_ContactGroupId` (`ContactGroupId`)
    REFERENCES `contacts`.`contact_groups` (`Id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE;