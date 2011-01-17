ALTER TABLE `future`.`Addresses` ADD COLUMN `BeAccounted` TINYINT(1) UNSIGNED NOT NULL COMMENT '0 - адрес не подлежит учету
1 - адрес подлежит учету' AFTER `ContactGroupId`;