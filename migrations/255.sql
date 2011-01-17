CREATE TABLE  `logs`.`AccountingLogs` (
  `Id` int unsigned NOT NULL AUTO_INCREMENT,
  `LogTime` datetime NOT NULL,
  `OperatorName` varchar(50) NOT NULL,
  `OperatorHost` varchar(50) NOT NULL,
  `Operation` tinyint(3) unsigned NOT NULL,
  `AccountingId` int(10) unsigned not null,
  `WriteTime` timestamp,
  `Type` tinyint(1) unsigned,
  `AccountId` int(10) unsigned,
  `Operator` varchar(255),

  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;
