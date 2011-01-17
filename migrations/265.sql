ALTER TABLE `documents`.`waybill_sources` MODIFY COLUMN `SourceID` INT(10) UNSIGNED DEFAULT NULL COMMENT 'тип источника
1 - по email
4 - наш фтп
5 - фтп поставщика',
 ADD COLUMN `WaybillUrl` VARCHAR(255) CHARACTER SET cp1251 COLLATE cp1251_general_ci DEFAULT NULL COMMENT 'URL по которому нужно забирать накладные (пока используется только фтп)' AFTER `ReaderClassName`,
 ADD COLUMN `RejectUrl` VARCHAR(255) CHARACTER SET cp1251 COLLATE cp1251_general_ci DEFAULT NULL COMMENT 'URL по которому нужно забирать отказы (пока используется только фтп)' AFTER `WaybillUrl`,
 ADD COLUMN `UserName` VARCHAR(255) CHARACTER SET cp1251 COLLATE cp1251_general_ci DEFAULT NULL COMMENT 'Имя пользователя' AFTER `RejectUrl`,
 ADD COLUMN `Password` VARCHAR(255) CHARACTER SET cp1251 COLLATE cp1251_general_ci DEFAULT NULL COMMENT 'Пароль' AFTER `UserName`,
 ADD COLUMN `DownloadInterval` TINYINT(1) UNSIGNED DEFAULT NULL COMMENT 'Интервал в секундах, через который производится обращение к источнику (только для фтп)' AFTER `Password`;