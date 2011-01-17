ALTER TABLE `accessright`.`regionaladmins` ADD COLUMN `Department` INT(10) UNSIGNED NOT NULL COMMENT 'Идентификатор подразделения, в котором находится сотрудник: 
0 - Управление,
1 - Бухгалтерия,
2 - IT,
3 - Обработка,
4 - Техподдержка,
5 - Отдел регионального развития' AFTER `Email`;