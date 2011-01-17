CREATE TABLE `billing`.`Accounting` (
  `Id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `WriteTime` TIMESTAMP NOT NULL COMMENT 'Время, когда была заведена запись',
  `Type` TINYINT(1) UNSIGNED NOT NULL COMMENT 'Тип объекта
0 - пользователь
1 - адрес доставки',
  `AccountId` INT(10) UNSIGNED NOT NULL COMMENT 'Идентификатор пользователя или адреса доставки',
  `Operator` VARCHAR(255) NOT NULL COMMENT 'Имя оператора, поставившего на учет этого пользователя или адрес',
  PRIMARY KEY (`Id`)
)
ENGINE = InnoDB DEFAULT CHARSET=cp1251;