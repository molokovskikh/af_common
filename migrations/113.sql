ALTER TABLE `future`.`Addresses` ADD COLUMN `ContactGroupId` INT(10) UNSIGNED DEFAULT NULL AFTER `Address`,
 ADD CONSTRAINT `FK_Addresses_ContactGroupId` FOREIGN KEY `FK_Addresses_ContactGroupId` (`ContactGroupId`)
    REFERENCES `contacts`.`contact_groups` (`Id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE;