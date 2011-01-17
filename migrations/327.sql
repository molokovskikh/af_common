update `future`.`AddressIntersection`
set
  ControlMinReq = 0
where
  ControlMinReq is null;

ALTER TABLE `future`.`AddressIntersection` 
  modify COLUMN `ControlMinReq` TINYINT(1) UNSIGNED not null DEFAULT 0 COMMENT 'Контролировать минимальный заказ
0 - нет
1 - да' AFTER `SupplierDeliveryId`;