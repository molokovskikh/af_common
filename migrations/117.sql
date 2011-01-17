ALTER TABLE `contacts`.`contact_groups` ADD COLUMN `Specialized` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '0 - общая группа
1 - специализированная' AFTER `ContactGroupOwnerId`;