ALTER TABLE `farm`.`FormRules` ADD COLUMN `FProducerCost` VARCHAR(20) CHARACTER SET cp1251 COLLATE cp1251_general_ci DEFAULT NULL COMMENT 'Цена производителя' AFTER `TxtMinOrderCountEnd`,
 ADD COLUMN `TxtProducerCostBegin` INT(10) UNSIGNED DEFAULT NULL AFTER `FProducerCost`,
 ADD COLUMN `TxtProducerCostEnd` INT(10) UNSIGNED DEFAULT NULL AFTER `TxtProducerCostBegin`;