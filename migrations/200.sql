ALTER TABLE `future`.`Users` ADD COLUMN `Free` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '0 - работает платно
1 - работает бесплатно' AFTER `OrderRegionMask`;