ALTER TABLE `future`.`AddressIntersection` ADD COLUMN `ControlMinReq` TINYINT(1) UNSIGNED DEFAULT 0 COMMENT 'Контролировать минимальный заказ
0 - нет
1 - да' AFTER `SupplierDeliveryId`,
 ADD COLUMN `MinReq` INT(10) UNSIGNED COMMENT 'Минимальная сумма заказа (в рублях)' AFTER `ControlMinReq`;