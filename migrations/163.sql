create table catalogs.Descriptions
(
  `Id` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  `Name` varchar(255) not null,
  `EnglishName` varchar(255) default null,
  `Description` MEDIUMTEXT DEFAULT NULL,
  `RawDescription` LONGTEXT default null,
  `NeedCorrect` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0,
  `UpdateTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`Id`),
  Key(`Name`),
  Key(`EnglishName`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;
