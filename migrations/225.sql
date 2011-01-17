ALTER TABLE `future`.`Users` ADD COLUMN `EnableUpdate` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Автоматическое обновление версий
0 - выключено
1 - включено' AFTER `SubmitOrders`;