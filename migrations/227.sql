ALTER TABLE `future`.`Intersection` ADD COLUMN `AgencyEnabled` TINYINT(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'Включен административно
0 - выключен (тогда в клиентском интерфейсе этот прайс не будет показываться этому клиенту и этот поставщик не будет видеть этого клиента)
1 - включен' AFTER `AvailableForClient`;