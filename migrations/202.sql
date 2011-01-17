ALTER TABLE `logs`.`RecordCalls` ADD COLUMN `CallType` INT(10) UNSIGNED DEFAULT NULL COMMENT 'Тип звонка
1 - входящий
2 - исходящий
3 - отзвон
NULL - не определено' AFTER `NameTo`;