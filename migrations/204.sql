ALTER TABLE `future`.`Addresses` ADD COLUMN `Free` TINYINT(3) UNSIGNED NOT NULL DEFAULT 0 COMMENT '0 - работает платно
1 - работает бесплатно' AFTER `Enabled`;