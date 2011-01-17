ALTER TABLE `usersettings`.`RetClientsSet` ADD COLUMN `IgnoreNewPrices` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Не включать новых поставщиков/прайс-листы
0 - новые прайс листы будут автоматически подключаться этой аптеке
1 - новые прайс-листы НЕ будут автоматически подключаться' AFTER `ShowAdvertising`;