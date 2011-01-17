﻿ALTER TABLE `catalogs`.`Descriptions` ADD COLUMN `Interaction` MEDIUMTEXT CHARACTER SET cp1251 COLLATE cp1251_general_ci DEFAULT NULL COMMENT 'Взаимодействие' AFTER `RawDescription`,
 ADD COLUMN `SideEffect` MEDIUMTEXT CHARACTER SET cp1251 COLLATE cp1251_general_ci DEFAULT NULL COMMENT 'Побочное действие и противопоказания ' AFTER `Interaction`,
 ADD COLUMN `IndicationsForUse` MEDIUMTEXT CHARACTER SET cp1251 COLLATE cp1251_general_ci DEFAULT NULL COMMENT 'Показания к применению ' AFTER `SideEffect`,
 ADD COLUMN `Dosing` MEDIUMTEXT CHARACTER SET cp1251 COLLATE cp1251_general_ci DEFAULT NULL COMMENT 'Способ применения и дозы' AFTER `IndicationsForUse`,
 ADD COLUMN `Warnings` MEDIUMTEXT CHARACTER SET cp1251 COLLATE cp1251_general_ci DEFAULT NULL COMMENT 'Предостережения и противопоказания' AFTER `Dosing`,
 ADD COLUMN `ProductForm` MEDIUMTEXT CHARACTER SET cp1251 COLLATE cp1251_general_ci DEFAULT NULL COMMENT 'Форма выпуска' AFTER `Warnings`,
 ADD COLUMN `PharmacologicalAction` MEDIUMTEXT CHARACTER SET cp1251 COLLATE cp1251_general_ci DEFAULT NULL COMMENT 'Фармакологическое действие' AFTER `ProductForm`,
 ADD COLUMN `Storage` MEDIUMTEXT CHARACTER SET cp1251 COLLATE cp1251_general_ci DEFAULT NULL COMMENT 'Условия хранения' AFTER `PharmacologicalAction`,
 ADD COLUMN `Expiration` MEDIUMTEXT CHARACTER SET cp1251 COLLATE cp1251_general_ci DEFAULT NULL COMMENT 'Срок годности' AFTER `Storage`,
 ADD COLUMN `Composition` MEDIUMTEXT CHARACTER SET cp1251 COLLATE cp1251_general_ci DEFAULT NULL COMMENT 'Состав' AFTER `Expiration`;